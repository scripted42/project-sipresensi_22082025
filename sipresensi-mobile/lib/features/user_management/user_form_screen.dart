import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/user_management/user_management_service.dart';
import 'package:sipresensi_mobile/core/models/user.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  
  const UserFormScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisnNipNikController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  int _selectedRoleId = 1; // Default to student
  bool _isSubmitting = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nisnNipNikController.text = widget.user!.nisnNipNik;
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email ?? '';
      _phoneController.text = widget.user!.phone ?? '';
      _selectedRoleId = widget.user!.roleId;
    }
  }

  @override
  void dispose() {
    _nisnNipNikController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
    });

    try {
      final userService = UserManagementService();
      final nisnNipNik = _nisnNipNikController.text.trim();
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      
      bool success = false;
      
      if (widget.user == null) {
        // Create new user
        final response = await userService.createUser(
          nisnNipNik: nisnNipNik,
          name: name,
          email: email,
          roleId: _selectedRoleId,
          phone: phone,
        );
        success = response != null;
      } else {
        // Update existing user
        final response = await userService.updateUser(
          id: widget.user!.id,
          nisnNipNik: nisnNipNik,
          name: name,
          email: email,
          roleId: _selectedRoleId,
          phone: phone,
        );
        success = response != null;
      }

      if (success) {
        setState(() {
          _message = widget.user == null 
              ? 'Pengguna berhasil dibuat' 
              : 'Pengguna berhasil diperbarui';
        });
        
        // Wait a moment then pop with success result
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });
      } else {
        setState(() {
          _message = widget.user == null 
              ? 'Gagal membuat pengguna' 
              : 'Gagal memperbarui pengguna';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Tambah Pengguna' : 'Edit Pengguna'),
        backgroundColor: const Color(0xFF007b5e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user == null ? 'Tambah Pengguna Baru' : 'Edit Pengguna',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007b5e),
                ),
              ),
              const SizedBox(height: 20),
              
              // NISN/NIP/NIK field
              const Text(
                'NISN/NIP/NIK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nisnNipNikController,
                decoration: const InputDecoration(
                  labelText: 'NISN/NIP/NIK',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan NISN/NIP/NIK';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Name field
              const Text(
                'Nama',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama lengkap';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email field
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Alamat email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan alamat email';
                  }
                  // Simple email validation
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Phone field
              const Text(
                'Telepon',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              // Role dropdown
              const Text(
                'Peran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedRoleId,
                decoration: const InputDecoration(
                  labelText: 'Pilih peran',
                  border: OutlineInputBorder(),
                ),
                items: const [
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
                validator: (value) {
                  if (value == null) {
                    return 'Pilih peran pengguna';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Message display
              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _message.contains('berhasil')
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('berhasil')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF007b5e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.user == null ? 'Tambah Pengguna' : 'Simpan Perubahan',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}