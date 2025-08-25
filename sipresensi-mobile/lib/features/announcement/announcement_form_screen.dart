import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/features/announcement/announcement_service.dart';
import 'package:sipresensi_mobile/core/models/announcement.dart';

class AnnouncementFormScreen extends StatefulWidget {
  final Announcement? announcement;
  
  const AnnouncementFormScreen({Key? key, this.announcement}) : super(key: key);

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    if (widget.announcement != null) {
      _titleController.text = widget.announcement!.title;
      _contentController.text = widget.announcement!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitAnnouncement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
    });

    try {
      final announcementService = AnnouncementService();
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();
      
      Announcement? response;
      
      if (widget.announcement == null) {
        // Create new announcement
        response = await announcementService.createAnnouncement(
          title: title,
          content: content,
        );
      } else {
        // Update existing announcement
        response = await announcementService.updateAnnouncement(
          id: widget.announcement!.id,
          title: title,
          content: content,
        );
      }

      if (response != null) {
        setState(() {
          _message = widget.announcement == null 
              ? 'Pengumuman berhasil dibuat' 
              : 'Pengumuman berhasil diperbarui';
        });
        
        // Wait a moment then pop with success result
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });
      } else {
        setState(() {
          _message = widget.announcement == null 
              ? 'Gagal membuat pengumuman' 
              : 'Gagal memperbarui pengumuman';
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
        title: Text(widget.announcement == null ? 'Buat Pengumuman' : 'Edit Pengumuman'),
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
                widget.announcement == null ? 'Buat Pengumuman Baru' : 'Edit Pengumuman',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007b5e),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title field
              const Text(
                'Judul',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul pengumuman',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan judul pengumuman';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Content field
              const Text(
                'Isi Pengumuman',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi pengumuman',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan isi pengumuman';
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
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
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
                  onPressed: _isSubmitting ? null : _submitAnnouncement,
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
                          widget.announcement == null ? 'Buat Pengumuman' : 'Simpan Perubahan',
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