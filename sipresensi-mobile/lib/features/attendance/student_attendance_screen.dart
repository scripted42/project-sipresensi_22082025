import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/attendance/student_attendance_service.dart';
import 'package:sipresensi_mobile/core/models/attendance.dart';
import 'package:sipresensi_mobile/features/dashboard/dashboard_service.dart';
import 'package:sipresensi_mobile/core/models/dashboard.dart';
import 'package:sipresensi_mobile/features/scanner/scanner_screen.dart';
import 'package:sipresensi_mobile/core/services/location_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisnNipNikController = TextEditingController();
  final _classIdController = TextEditingController();
  List<Class> _classes = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String _message = '';
  StudentAttendanceResponse? _attendanceResponse;
  late MobileScannerController _cameraController;
  bool _showCamera = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    _nisnNipNikController.dispose();
    _classIdController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dashboardService = DashboardService();
      final classes = await dashboardService.getClasses();

      if (classes != null) {
        setState(() {
          _classes = classes;
        });
      }
    } catch (e) {
      // Handle error appropriately in production
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAttendance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
      _attendanceResponse = null;
    });

    try {
      final nisnNipNik = _nisnNipNikController.text.trim();
      final classId = int.tryParse(_classIdController.text);

      if (classId == null) {
        setState(() {
          _message = 'ID kelas tidak valid';
          _isSubmitting = false;
        });
        return;
      }

      // Get current location
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      final latitude = position.latitude;
      final longitude = position.longitude;

      final attendanceService = StudentAttendanceService();
      final response = await attendanceService.scanStudentQR(
        nisnNipNik: nisnNipNik,
        classId: classId,
        latitude: latitude,
        longitude: longitude,
      );

      setState(() {
        _attendanceResponse = response;
        _message = response?.message ?? 'Terjadi kesalahan';
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan: ${e.toString()}';
        _isSubmitting = false;
      });
    }
  }

  Future<void> _submitBulkAttendance() async {
    if (_classIdController.text.isEmpty) {
      setState(() {
        _message = 'Mohon pilih kelas terlebih dahulu';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
    });

    try {
      final classId = int.tryParse(_classIdController.text);

      if (classId == null) {
        setState(() {
          _message = 'ID kelas tidak valid';
          _isSubmitting = false;
        });
        return;
      }

      final attendanceService = StudentAttendanceService();
      final response = await attendanceService.submitBulkAttendance(
        classId: classId,
      );

      if (response != null) {
        setState(() {
          _message = response.message;
          _isSubmitting = false;
        });
      } else {
        setState(() {
          _message = 'Gagal melakukan absensi massal';
          _isSubmitting = false;
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan: ${e.toString()}';
        _isSubmitting = false;
      });
    }
  }

  Future<void> _handleBarcode(BarcodeCapture barcode) async {
    // Prevent multiple scans
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
      _message = 'Memproses QR code...';
    });

    try {
      final classId = int.tryParse(_classIdController.text);
      
      if (classId == null) {
        setState(() {
          _message = 'Mohon pilih kelas terlebih dahulu';
          _isSubmitting = false;
        });
        return;
      }

      // Extract QR code value
      final qrCode = barcode.barcodes.first.rawValue;
      
      if (qrCode == null) {
        setState(() {
          _message = 'QR code tidak valid';
          _isSubmitting = false;
        });
        return;
      }

      // Get current location for attendance
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      final latitude = position.latitude;
      final longitude = position.longitude;

      // Submit attendance
      final attendanceService = StudentAttendanceService();
      final response = await attendanceService.scanStudentQR(
        qrCode: qrCode,
        classId: classId,
        latitude: latitude,
        longitude: longitude,
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
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Absensi Siswa'),
        backgroundColor: const Color(0xFF007b5e),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showCamera
              ? _buildCameraView()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF007b5e),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Absensi Siswa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Input data siswa untuk melakukan absensi',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Form fields with modern cards
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // NISN/NIP/NIK field
                                TextFormField(
                                  controller: _nisnNipNikController,
                                  decoration: InputDecoration(
                                    labelText: 'NISN/NIP/NIK Siswa',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mohon masukkan NISN/NIP/NIK siswa';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // Class dropdown
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Kelas',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: _classIdController.text.isEmpty ? null : _classIdController.text,
                                  items: _classes.map((classItem) {
                                    return DropdownMenuItem<String>(
                                      value: classItem.id.toString(),
                                      child: Text(classItem.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _classIdController.text = value;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mohon pilih kelas';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Message display
                        if (_message.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _attendanceResponse?.success == true
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        
                        // Action buttons with modern design
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Individual attendance button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isSubmitting ? null : _submitAttendance,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: const Color(0xFF007b5e),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isSubmitting
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Absen Siswa',
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
                                
                                // Bulk attendance button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isSubmitting ? null : _submitBulkAttendance,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isSubmitting
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.group,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Absen Massal',
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
                                
                                // QR Scanner button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _classIdController.text.isEmpty
                                        ? null
                                        : () {
                                            setState(() {
                                              _showCamera = true;
                                            });
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: const Color(0xFF0aa37d),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code_scanner,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Scan QR Code',
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
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Info card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cara Absensi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const _InfoItem(
                                  icon: Icons.person,
                                  title: 'Absen Siswa',
                                  description: 'Input NISN/NIP/NIK siswa dan pilih kelas',
                                ),
                                const SizedBox(height: 12),
                                const _InfoItem(
                                  icon: Icons.group,
                                  title: 'Absen Massal',
                                  description: 'Lakukan absensi untuk seluruh siswa dalam satu kelas',
                                ),
                                const SizedBox(height: 12),
                                const _InfoItem(
                                  icon: Icons.qr_code_scanner,
                                  title: 'Scan QR Code',
                                  description: 'Gunakan kamera untuk memindai QR code siswa',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        // Scanner view with overlay
        Expanded(
          child: Stack(
            children: [
              // Scanner camera
              MobileScanner(
                controller: _cameraController,
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
        
        // Back button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showCamera = false;
                });
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
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Kembali',
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
        ),
      ],
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

// Info item widget
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF007b5e),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}