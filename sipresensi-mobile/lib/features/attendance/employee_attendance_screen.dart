import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/attendance/employee_attendance_service.dart';
import 'package:sipresensi_mobile/core/models/attendance.dart';
import 'package:sipresensi_mobile/core/services/location_service.dart';
import 'package:sipresensi_mobile/features/camera/selfie_camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:sipresensi_mobile/core/utils/image_utils.dart';
import 'package:geolocator/geolocator.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  final int userId;
  
  const EmployeeAttendanceScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<EmployeeAttendanceScreen> createState() => _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  DynamicQRToken? _currentQRToken;
  bool _isLoading = false;
  bool _isProcessing = false;
  String _message = '';
  QRVerificationResponse? _verificationResponse;
  Position? _currentPosition;
  double _distanceToSchool = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDynamicQRToken();
    _getCurrentLocation();
  }

  Future<void> _loadDynamicQRToken() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final attendanceService = EmployeeAttendanceService();
      final token = await attendanceService.getDynamicQRToken();

      if (token != null) {
        setState(() {
          _currentQRToken = token;
          _message = 'Token QR diperbarui. Berlaku selama 10 detik.';
        });
      } else {
        setState(() {
          _message = 'Gagal memuat token QR';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      
      final distance = await locationService.calculateDistanceToSchool(position);
      final isWithinRadius = distance <= 100; // 100 meters radius
      
      setState(() {
        _currentPosition = position;
        _distanceToSchool = distance;
        
        if (!isWithinRadius) {
          _message = 'Anda berada di luar area sekolah (${distance.toStringAsFixed(0)}m dari lokasi sekolah)';
        } else {
          _message = 'Lokasi terverifikasi (${distance.toStringAsFixed(0)}m dari lokasi sekolah)';
        }
      });
    } catch (e) {
      setState(() {
        _message = 'Gagal mendapatkan lokasi: ${e.toString()}';
      });
    }
  }

  Future<void> _performCheckin() async {
    // Verify location first
    setState(() {
      _isProcessing = true;
      _message = 'Memverifikasi lokasi...';
    });

    try {
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
        _message = 'Foto diambil. Memproses absen masuk...';
      });

      // Get current location
      final position = await locationService.getCurrentLocation();
      final latitude = position.latitude;
      final longitude = position.longitude;

      // Convert image to base64
      final photoBase64 = await ImageUtils.xFileToBase64(selfieImage.path);

      // Submit checkin
      final attendanceService = EmployeeAttendanceService();
      final response = await attendanceService.submitCheckin(
        qrToken: _currentQRToken?.token ?? '',
        latitude: latitude,
        longitude: longitude,
        accuracy: position.accuracy?.toInt() ?? 0,
        photo: photoBase64,
      );

      if (response != null) {
        setState(() {
          _verificationResponse = response;
          _message = response.message;
        });
        
        // Refresh QR token
        _loadDynamicQRToken();
      } else {
        setState(() {
          _message = 'Gagal melakukan absen masuk';
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

  Future<void> _performCheckout() async {
    // Verify location first
    setState(() {
      _isProcessing = true;
      _message = 'Memverifikasi lokasi...';
    });

    try {
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
        _message = 'Foto diambil. Memproses absen keluar...';
      });

      // Get current location
      final position = await locationService.getCurrentLocation();
      final latitude = position.latitude;
      final longitude = position.longitude;

      // Convert image to base64
      final photoBase64 = await ImageUtils.xFileToBase64(selfieImage.path);

      // Submit checkout
      final attendanceService = EmployeeAttendanceService();
      final response = await attendanceService.submitCheckout(
        qrToken: _currentQRToken?.token ?? '',
        latitude: latitude,
        longitude: longitude,
        accuracy: position.accuracy?.toInt() ?? 0,
        photo: photoBase64,
      );

      if (response != null) {
        setState(() {
          _verificationResponse = response;
          _message = response.message;
        });
        
        // Refresh QR token
        _loadDynamicQRToken();
      } else {
        setState(() {
          _message = 'Gagal melakukan absen keluar';
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Absensi Pegawai'),
        backgroundColor: const Color(0xFF007b5e),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting
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
                            'Absensi Harian',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selamat datang, silakan lakukan absensi harian Anda',
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
                  
                  // Location info with modern card
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF007b5e).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF007b5e),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Lokasi Anda',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                _distanceToSchool <= 100 ? Icons.check_circle : Icons.error,
                                color: _distanceToSchool <= 100 ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _distanceToSchool <= 100 
                                      ? 'Dalam radius sekolah (${_distanceToSchool.toStringAsFixed(0)}m)' 
                                      : 'Di luar radius sekolah (${_distanceToSchool.toStringAsFixed(0)}m)',
                                  style: TextStyle(
                                    color: _distanceToSchool <= 100 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_currentPosition != null) ...[
                            Text(
                              'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Akurasi: ${_currentPosition!.accuracy?.toStringAsFixed(2) ?? 'N/A'} meter',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _isProcessing ? null : _getCurrentLocation,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Refresh Lokasi',
                                    style: TextStyle(
                                      fontSize: 14,
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
                  ),
                  const SizedBox(height: 20),
                  
                  // QR Token display with modern card
                  if (_currentQRToken != null) ...[
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF007b5e).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Color(0xFF007b5e),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Token QR Dinamis',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _currentQRToken!.token,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                      letterSpacing: 2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Berlaku sampai: ${_formatTime(_currentQRToken!.expiresAt)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Token ini akan diperbarui secara otomatis setiap 10 detik',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  // Message display
                  if (_message.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _verificationResponse?.success == true
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _verificationResponse?.success == true
                                ? Icons.check_circle
                                : Icons.error,
                            color: _verificationResponse?.success == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _message,
                              style: TextStyle(
                                color: _verificationResponse?.success == true
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
                          // Checkin button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isProcessing || _distanceToSchool > 100
                                  ? null
                                  : _performCheckin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF007b5e),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isProcessing
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.login,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Absen Masuk',
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
                          
                          // Checkout button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isProcessing || _distanceToSchool > 100
                                  ? null
                                  : _performCheckout,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isProcessing
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Absen Keluar',
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
                          
                          // Refresh button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _loadDynamicQRToken,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Refresh Token QR',
                                          style: TextStyle(
                                            fontSize: 16,
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
                            'Petunjuk Absensi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _InfoItem(
                            icon: Icons.location_on,
                            title: 'Verifikasi Lokasi',
                            description: 'Pastikan Anda berada di area sekolah (radius 100m)',
                          ),
                          const SizedBox(height: 12),
                          const _InfoItem(
                            icon: Icons.camera_alt,
                            title: 'Foto Selfie',
                            description: 'Ambil foto selfie untuk verifikasi identitas',
                          ),
                          const SizedBox(height: 12),
                          const _InfoItem(
                            icon: Icons.qr_code_scanner,
                            title: 'Token QR',
                            description: 'Gunakan token QR yang ditampilkan di monitor sekolah',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  // Helper to format time from datetime string
  String _formatTime(String dateTimeString) {
    try {
      final date = DateTime.parse(dateTimeString);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString.split('T')[1].split('.')[0];
    }
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