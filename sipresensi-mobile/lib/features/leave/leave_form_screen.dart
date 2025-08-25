import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/leave/leave_service.dart';
import 'package:file_picker/file_picker.dart';

class LeaveFormScreen extends StatefulWidget {
  const LeaveFormScreen({Key? key}) : super(key: key);

  @override
  State<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  String _leaveType = 'izin';
  DateTime? _startDate;
  DateTime? _endDate;
  String _attachmentPath = '';
  bool _isSubmitting = false;
  String _message = '';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _attachmentPath = result.files.single.path ?? '';
        });
      }
    } catch (e) {
      // Handle error
      print('Error picking file: $e');
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        
        // If end date is before start date, reset end date
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal mulai terlebih dahulu')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(2030),
    );
    
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal mulai dan tanggal selesai')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
    });

    try {
      final leaveService = LeaveService();
      final response = await leaveService.submitLeave(
        leaveType: _leaveType,
        startDate: _startDate!.toIso8601String().split('T')[0],
        endDate: _endDate!.toIso8601String().split('T')[0],
        reason: _reasonController.text.trim(),
        attachmentPath: _attachmentPath.isNotEmpty ? _attachmentPath : null,
      );

      if (response != null) {
        setState(() {
          _message = 'Izin berhasil diajukan';
        });
        
        // Wait a moment then pop with success result
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });
      } else {
        setState(() {
          _message = 'Gagal mengajukan izin';
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
      appBar: AppBar(
        title: const Text('Ajukan Izin'),
        backgroundColor: const Color(0xFF007b5e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Pengajuan Izin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007b5e),
                ),
              ),
              const SizedBox(height: 20),
              
              // Leave type dropdown
              const Text(
                'Jenis Izin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'izin', child: Text('Izin')),
                  DropdownMenuItem(value: 'cuti', child: Text('Cuti')),
                  DropdownMenuItem(value: 'dinas_luar', child: Text('Dinas Luar')),
                  DropdownMenuItem(value: 'sakit', child: Text('Sakit')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _leaveType = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih jenis izin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Date range
              const Text(
                'Tanggal Izin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectStartDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Mulai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _startDate == null
                              ? 'Pilih tanggal'
                              : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _selectEndDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Selesai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _endDate == null
                              ? 'Pilih tanggal'
                              : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Reason text field
              const Text(
                'Alasan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Alasan izin',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan alasan izin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Attachment
              const Text(
                'Lampiran (Opsional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickFile,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Pilih file',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _attachmentPath.isEmpty
                              ? 'Tidak ada file dipilih'
                              : _attachmentPath.split('/').last,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_attachmentPath.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _attachmentPath = '';
                        });
                      },
                    ),
                ],
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
                  onPressed: _isSubmitting ? null : _submitLeave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF007b5e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Ajukan Izin',
                          style: TextStyle(
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