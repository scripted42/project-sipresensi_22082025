import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/attendance/employee_attendance_service.dart';
import 'package:sipresensi_mobile/core/models/attendance.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  List<AttendanceRecord> _attendanceRecords = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final attendanceService = EmployeeAttendanceService();
      final history = await attendanceService.getAttendanceHistory();

      if (history != null && history.success) {
        setState(() {
          _attendanceRecords = history.data;
        });
      } else {
        setState(() {
          _errorMessage = history?.message ?? 'Gagal memuat riwayat absensi';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan saat memuat data';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        backgroundColor: const Color(0xFF007b5e),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAttendanceHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007b5e),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _attendanceRecords.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_toggle_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada riwayat absensi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Absen harian Anda akan muncul di sini',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadAttendanceHistory,
                      child: CustomScrollView(
                        slivers: [
                          // Header with summary
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
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
                                        'Ringkasan Absensi',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF007b5e),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildSummaryItem(
                                            icon: Icons.check_circle,
                                            title: 'Hadir',
                                            value: _attendanceRecords
                                                .where((r) => r.status == 'hadir')
                                                .length
                                                .toString(),
                                            color: Colors.green,
                                          ),
                                          _buildVerticalDivider(),
                                          _buildSummaryItem(
                                            icon: Icons.access_time,
                                            title: 'Terlambat',
                                            value: _attendanceRecords
                                                .where((r) => r.status == 'terlambat')
                                                .length
                                                .toString(),
                                            color: Colors.orange,
                                          ),
                                          _buildVerticalDivider(),
                                          _buildSummaryItem(
                                            icon: Icons.cancel,
                                            title: 'Tidak Hadir',
                                            value: _attendanceRecords
                                                .where((r) => r.status != 'hadir' && r.status != 'terlambat')
                                                .length
                                                .toString(),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // History list
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final record = _attendanceRecords[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Container(
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
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: record.type == 'checkin'
                                                      ? const Color(0xFF007b5e).withOpacity(0.1)
                                                      : Colors.orange.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  record.type == 'checkin'
                                                      ? Icons.login
                                                      : Icons.logout,
                                                  color: record.type == 'checkin'
                                                      ? const Color(0xFF007b5e)
                                                      : Colors.orange,
                                                  size: 24,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: record.status == 'hadir'
                                                      ? Colors.green
                                                      : record.status == 'terlambat'
                                                          ? Colors.orange
                                                          : Colors.grey,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  record.getStatusName(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            record.getTypeName(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatDate(record.timestamp),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 16,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatTime(record.timestamp),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Location info
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.05),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Color(0xFF007b5e),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Lat: ${record.latitude}, Lng: ${record.longitude}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: _attendanceRecords.length,
                            ),
                          ),
                          
                          // Footer spacing
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 16),
                          ),
                        ],
                      ),
                    ),
    );
  }

  // Format date helper
  String _formatDate(String dateTimeString) {
    try {
      final date = DateTime.parse(dateTimeString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateTimeString.split('T')[0];
    }
  }

  // Format time helper
  String _formatTime(String dateTimeString) {
    try {
      final date = DateTime.parse(dateTimeString);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString.split('T')[1].split('.')[0];
    }
  }

  // Summary item widget
  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Vertical divider for summary
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }
}