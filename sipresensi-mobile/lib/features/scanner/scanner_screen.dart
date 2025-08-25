import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sipresensi_mobile/features/attendance/student_attendance_service.dart';
import 'package:sipresensi_mobile/core/models/attendance.dart';
import 'package:sipresensi_mobile/core/services/location_service.dart';
import 'package:sipresensi_mobile/features/camera/selfie_camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:sipresensi_mobile/core/utils/image_utils.dart';

class ScannerScreen extends StatefulWidget {
  final int classId;
  
  const ScannerScreen({Key? key, required this.classId}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isProcessing = false;
  String _message = '';
  StudentAttendanceResponse? _attendanceResponse;
  late MobileScannerController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture barcode) async {
    // Prevent multiple scans
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _message = 'Memverifikasi lokasi...';
    });

    try {
      // First, verify location
      final locationService = LocationService();
      final isWithinRadius = await locationService.isWithinSchoolRadius();
      
      if (!isWithinRadius) {
        setState(() {
          _message = 'Anda berada di luar area sekolah (radius 100m)';
          _isProcessing = false;
        });
        return;
      }

      setState(() {
        _message = 'Lokasi terverifikasi. Mengambil foto selfie...';
      });

      // Take selfie photo
      final selfieImage = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(
          builder: (context) => SelfieCameraScreen(
            onPictureTaken: (XFile image) {
              Navigator.pop(context, image);
            },
          ),
        ),
      );

      if (selfieImage == null) {
        setState(() {
          _message = 'Pengambilan foto dibatalkan';
          _isProcessing = false;
        });
        return;
      }

      setState(() {
        _message = 'Foto diambil. Memproses QR code...';
      });

      // Extract QR code value
      final qrCode = barcode.barcodes.first.rawValue;
      
      if (qrCode == null) {
        setState(() {
          _message = 'QR code tidak valid';
          _isProcessing = false;
        });
        return;
      }

      // Get current location for attendance
      final position = await locationService.getCurrentLocation();
      final latitude = position.latitude;
      final longitude = position.longitude;

      // Submit attendance
      final attendanceService = StudentAttendanceService();
      final response = await attendanceService.scanStudentQR(
        qrCode: qrCode,
        classId: widget.classId,
        latitude: latitude,
        longitude: longitude,
        // In a real implementation, you would upload the selfie image here
        // For now, we're just using the location verification and QR code
      );

      if (response != null) {
        setState(() {
          _attendanceResponse = response;
          _message = response.message;
        });
      } else {
        setState(() {
          _message = 'Gagal memproses absensi';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Code Siswa'),
        backgroundColor: const Color(0xFF007b5e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Scanner view with overlay
          Expanded(
            child: Stack(
              children: [
                // Scanner camera
                MobileScanner(
                  controller: cameraController,
                  onDetect: _handleBarcode,
                ),
                
                // Scanner overlay
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: CustomPaint(
                    painter: ScannerOverlayPainter(),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                
                // Scanner frame
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
                
                // Scanner instruction
                const Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Arahkan kamera ke QR Code siswa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Message display with modern card
          if (_message.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _attendanceResponse?.success == true
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _attendanceResponse?.success == true
                        ? Icons.check_circle
                        : Icons.error,
                    color: _attendanceResponse?.success == true
                        ? Colors.green
                        : Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _message,
                      style: TextStyle(
                        color: _attendanceResponse?.success == true
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          
          // Action buttons with modern design
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            cameraController.toggleTorch();
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF007b5e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flashlight_on,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Toggle Flash',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw transparent rectangle in the center
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 250,
      height: 250,
    );

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect,
        const Radius.circular(20),
      ));

    final path = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holePath,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}