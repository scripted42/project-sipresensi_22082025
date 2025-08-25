import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/dashboard/dashboard_service.dart';
import 'package:sipresensi_mobile/core/models/dashboard.dart';
import 'package:sipresensi_mobile/features/attendance/employee_attendance_screen.dart';
import 'package:sipresensi_mobile/features/attendance/attendance_history_screen.dart';
import 'package:sipresensi_mobile/features/attendance/student_attendance_screen.dart';
import 'package:sipresensi_mobile/features/leave/leave_screen.dart';
import 'package:sipresensi_mobile/features/announcement/announcement_screen.dart';
import 'package:sipresensi_mobile/features/user_management/user_management_screen.dart';
import 'package:sipresensi_mobile/features/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardData? _dashboardData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dashboardService = DashboardService();
      final data = await dashboardService.getDashboardData();

      if (data != null) {
        setState(() {
          _dashboardData = data;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data dashboard';
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

  // Menu items for dashboard
  List<Map<String, dynamic>> _getMenuItems() {
    final List<Map<String, dynamic>> allItems = [
      {
        'title': 'Absensi Siswa',
        'icon': Icons.school,
        'color': const Color(0xFF007b5e),
        'screen': const StudentAttendanceScreen(),
        'allowedRoles': [2, 3, 4, 5], // Teacher, Headmaster, Admin
      },
      {
        'title': 'Absensi Pegawai',
        'icon': Icons.work,
        'color': const Color(0xFF0aa37d),
        'screen': EmployeeAttendanceScreen(userId: _dashboardData!.user.id),
        'allowedRoles': [2, 3, 4, 5], // Teacher, Headmaster, Admin
      },
      {
        'title': 'Riwayat Absensi',
        'icon': Icons.history,
        'color': Colors.orange,
        'screen': const AttendanceHistoryScreen(),
        'allowedRoles': [1, 2, 3, 4, 5], // All users
      },
      {
        'title': 'Pengajuan Izin',
        'icon': Icons.event_note,
        'color': Colors.blue,
        'screen': const LeaveScreen(),
        'allowedRoles': [1, 2, 3, 4, 5], // All users
      },
      {
        'title': 'Pengumuman',
        'icon': Icons.campaign,
        'color': Colors.purple,
        'screen': const AnnouncementScreen(),
        'allowedRoles': [1, 2, 3, 4, 5], // All users
      },
      {
        'title': 'Manajemen Pengguna',
        'icon': Icons.admin_panel_settings,
        'color': Colors.red,
        'screen': const UserManagementScreen(),
        'allowedRoles': [5], // Admin only
      },
      {
        'title': 'Profil',
        'icon': Icons.person,
        'color': Colors.teal,
        'screen': ProfileScreen(),
        'allowedRoles': [1, 2, 3, 4, 5], // All users
      },
    ];

    // Filter based on user role
    return allItems.where((item) {
      return item['allowedRoles'].contains(_dashboardData!.user.roleId);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDashboardData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _dashboardData != null
                  ? CustomScrollView(
                      slivers: [
                        // App bar with gradient background
                        SliverAppBar(
                          expandedHeight: 200.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: const Color(0xFF007b5e),
                          flexibleSpace: FlexibleSpaceBar(
                            title: const Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF007b5e), Color(0xFF0aa37d)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Decorative circles
                                  Positioned(
                                    top: -50,
                                    right: -50,
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -30,
                                    left: -30,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  // User info
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Selamat Datang,',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _dashboardData!.user.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'NISN/NIP/NIK: ${_dashboardData!.user.nisnNipNik}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Main content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // All Menu Items as Icons
                                const Text(
                                  'Menu Utama',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
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
                                    padding: const EdgeInsets.all(16),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.85,
                                      ),
                                      itemCount: _getMenuItems().length,
                                      itemBuilder: (context, index) {
                                        final item = _getMenuItems()[index];
                                        return _buildMenuItem(
                                          icon: item['icon'],
                                          title: item['title'],
                                          color: item['color'],
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => item['screen'],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Quick Actions Section
                                if (_dashboardData!.user.roleId >= 2 && _dashboardData!.user.roleId <= 4) ...[
                                  const Text(
                                    'Aksi Cepat',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Modern card with shadow
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
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          // Two action buttons in a row
                                          Row(
                                            children: [
                                              // Absen Sekarang Button
                                              Expanded(
                                                child: _buildActionButton(
                                                  icon: Icons.fingerprint,
                                                  title: 'Absen Sekarang',
                                                  subtitle: 'Mulai absensi harian',
                                                  color: const Color(0xFF007b5e),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => EmployeeAttendanceScreen(
                                                          userId: _dashboardData!.user.id,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Riwayat Absensi Button
                                              Expanded(
                                                child: _buildActionButton(
                                                  icon: Icons.history,
                                                  title: 'Riwayat',
                                                  subtitle: 'Lihat absensi sebelumnya',
                                                  color: const Color(0xFF0aa37d),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const AttendanceHistoryScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                
                                // Attendance Statistics (for teachers)
                                if (_dashboardData!.attendanceStatistics != null) ...[
                                  const Text(
                                    'Statistik Absensi',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
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
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          // Stats grid
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildStatCard(
                                                  icon: Icons.people,
                                                  title: 'Total Siswa',
                                                  value: _dashboardData!.attendanceStatistics!.totalStudents.toString(),
                                                  color: const Color(0xFF007b5e),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _buildStatCard(
                                                  icon: Icons.check_circle,
                                                  title: 'Hadir',
                                                  value: _dashboardData!.attendanceStatistics!.present.toString(),
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildStatCard(
                                                  icon: Icons.access_time,
                                                  title: 'Terlambat',
                                                  value: _dashboardData!.attendanceStatistics!.late.toString(),
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _buildStatCard(
                                                  icon: Icons.cancel,
                                                  title: 'Tidak Hadir',
                                                  value: _dashboardData!.attendanceStatistics!.absent.toString(),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                
                                // Recent Announcements
                                if (_dashboardData!.recentAnnouncements != null &&
                                    _dashboardData!.recentAnnouncements!.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Pengumuman Terbaru',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const AnnouncementScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Lihat Semua',
                                          style: TextStyle(
                                            color: Color(0xFF007b5e),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
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
                                    child: Column(
                                      children: _dashboardData!.recentAnnouncements!
                                          .take(2)
                                          .map((announcement) => _buildAnnouncementItem(announcement))
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                
                                // Recent Leaves
                                if (_dashboardData!.recentLeaves != null &&
                                    _dashboardData!.recentLeaves!.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Izin Terbaru',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LeaveScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Lihat Semua',
                                          style: TextStyle(
                                            color: Color(0xFF007b5e),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
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
                                    child: Column(
                                      children: _dashboardData!.recentLeaves!
                                          .take(2)
                                          .map((leave) => _buildLeaveItem(leave))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(child: Text('Tidak ada data dashboard')),
    );
  }

  // Menu item widget for dashboard menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Action button widget for quick actions
  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stat card widget for statistics
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Stat item for detailed statistics
  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.grey),
        const SizedBox(width: 8),
        Text('$label: '),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Announcement item
  Widget _buildAnnouncementItem(Announcement announcement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            announcement.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            announcement.publishedAt.split('T')[0],
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Leave item
  Widget _buildLeaveItem(Leave leave) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leave.getLeaveTypeName(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: leave.status == 'disetujui'
                      ? Colors.green
                      : leave.status == 'ditolak'
                          ? Colors.red
                          : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  leave.getStatusName(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${leave.startDate} - ${leave.endDate}',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            leave.reason,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}