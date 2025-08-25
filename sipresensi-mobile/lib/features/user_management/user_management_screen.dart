import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/user_management/user_management_service.dart';
import 'package:sipresensi_mobile/core/models/user.dart';
import 'package:sipresensi_mobile/features/user_management/user_form_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  int _selectedRoleId = 0; // 0 means all roles

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userService = UserManagementService();
      final users = await userService.getUsers();

      if (users != null) {
        setState(() {
          _users = users;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data pengguna';
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

  String _getRoleName(int roleId) {
    switch (roleId) {
      case 1:
        return 'Siswa';
      case 2:
        return 'Guru';
      case 3:
        return 'Pegawai';
      case 4:
        return 'Kepala Sekolah';
      case 5:
        return 'Admin';
      default:
        return 'Tidak Diketahui';
    }
  }

  List<User> _getFilteredUsers() {
    List<User> filtered = _users;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final query = _searchQuery.toLowerCase();
        return user.name.toLowerCase().contains(query) ||
            user.nisnNipNik.toLowerCase().contains(query) ||
            user.email?.toLowerCase().contains(query) == true;
      }).toList();
    }

    // Filter by role
    if (_selectedRoleId > 0) {
      filtered = filtered.where((user) => user.roleId == _selectedRoleId).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredUsers();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Manajemen Pengguna'),
        backgroundColor: const Color(0xFF007b5e),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserFormScreen(),
                ),
              ).then((value) {
                // Refresh users after form is closed
                if (value == true) {
                  _loadUsers();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with greeting
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF007b5e), Color(0xFF0aa37d)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manajemen Pengguna',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola data pengguna sistem',
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
          
          // Search and filter section with modern cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  children: [
                    // Search field
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Cari pengguna',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Role filter
                    DropdownButtonFormField<int>(
                      value: _selectedRoleId,
                      decoration: InputDecoration(
                        labelText: 'Filter berdasarkan peran',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Semua Peran')),
                        DropdownMenuItem(value: 1, child: Text('Siswa')),
                        DropdownMenuItem(value: 2, child: Text('Guru')),
                        DropdownMenuItem(value: 3, child: Text('Pegawai')),
                        DropdownMenuItem(value: 4, child: Text('Kepala Sekolah')),
                        DropdownMenuItem(value: 5, child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRoleId = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // User list or loading/error message
          Expanded(
            child: _isLoading
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
                              onPressed: _loadUsers,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007b5e),
                              ),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : filteredUsers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tidak ada pengguna yang ditemukan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Coba ubah kata kunci pencarian atau filter peran',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadUsers,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
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
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF007b5e),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Color(0xFF007b5e),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user.name,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${_getRoleName(user.roleId)} - ${user.nisnNipNik}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    if (user.email != null)
                                                      Text(
                                                        user.email!,
                                                        style: TextStyle(
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: user.isActive
                                                      ? Colors.green.withOpacity(0.1)
                                                      : Colors.red.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  user.isActive ? 'Aktif' : 'Tidak Aktif',
                                                  style: TextStyle(
                                                    color: user.isActive ? Colors.green : Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          // Action buttons
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => UserFormScreen(user: user),
                                                    ),
                                                  ).then((value) {
                                                    if (value == true) {
                                                      _loadUsers();
                                                    }
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  // Show confirmation dialog
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Hapus Pengguna'),
                                                        content: Text(
                                                            'Apakah Anda yakin ingin menghapus ${user.name}?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: Navigator.of(context).pop,
                                                            child: const Text('Batal'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                              // Call delete function
                                                            },
                                                            child: const Text('Hapus'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}