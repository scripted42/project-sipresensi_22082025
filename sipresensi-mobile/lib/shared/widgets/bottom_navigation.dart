import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/dashboard/dashboard_screen.dart';
import 'package:sipresensi_mobile/features/profile/profile_screen.dart';
import 'package:sipresensi_mobile/features/dashboard/dashboard_service.dart';
import 'package:sipresensi_mobile/core/models/dashboard.dart';
import 'package:sipresensi_mobile/features/auth/auth_service.dart';
import 'package:sipresensi_mobile/core/models/user.dart';
import 'package:sipresensi_mobile/features/attendance/employee_attendance_screen.dart';
import 'package:sipresensi_mobile/features/attendance/student_attendance_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  User? _currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final authService = AuthService();
      final user = await authService.getProfile();
      
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
    }
  }
  
  void _updateCurrentUser(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _navigateToAttendance() async {
    // Check if user is employee/teacher/headmaster (role_id 2-4)
    final bool isEmployee = _currentUser != null && 
        _currentUser!.roleId >= 2 && _currentUser!.roleId <= 4;
    
    if (isEmployee) {
      // For employees, navigate to employee attendance screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeAttendanceScreen(userId: _currentUser!.id),
        ),
      );
    } else {
      // For students, navigate to student attendance screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentAttendanceScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build children list - only 3 tabs: Dashboard, Absen Pegawai, Profil
    List<Widget> children = [
      const DashboardScreen(),
      EmployeeAttendanceScreen(userId: _currentUser?.id ?? 0),
      ProfileScreen(onUserUpdated: _updateCurrentUser),
    ];
    
    // Adjust current index if needed
    int adjustedIndex = _currentIndex;
    if (_currentIndex >= children.length) {
      adjustedIndex = 0;
    }

    // Build bottom navigation items - only 3 tabs
    List<BottomNavigationBarItem> bottomItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.fingerprint),
        label: 'Absen Pegawai',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profil',
      ),
    ];

    return Scaffold(
      body: _isLoadingUser 
          ? const Center(child: CircularProgressIndicator())
          : children[adjustedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            color: Colors.white,
            elevation: 0,
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                onTap: _onTabTapped,
                currentIndex: adjustedIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0xFF007b5e),
                unselectedItemColor: Colors.grey,
                items: bottomItems,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _navigateToAttendance,
          backgroundColor: const Color(0xFF007b5e),
          elevation: 5,
          child: const Icon(Icons.fingerprint, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}