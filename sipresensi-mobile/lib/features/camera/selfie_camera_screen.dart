import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sipresensi_mobile/core/utils/image_utils.dart';

class SelfieCameraScreen extends StatefulWidget {
  final Function(XFile) onPictureTaken;
  
  const SelfieCameraScreen({Key? key, required this.onPictureTaken}) : super(key: key);

  @override
  State<SelfieCameraScreen> createState() => _SelfieCameraScreenState();
}

class _SelfieCameraScreenState extends State<SelfieCameraScreen> {
  late Future<void> _initializeControllerFuture;
  late CameraController _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get the list of available cameras
    final cameras = await availableCameras();
    
    // Get the front camera (usually the second camera in the list)
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    
    // Initialize the camera controller
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );
    
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    // Ensure that the camera is initialized.
    await _initializeControllerFuture;
    
    // Prevent multiple taps
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // Attempt to take a picture and get the file `XFile` representation.
      // Ensure that the camera is initialized.
      final image = await _controller.takePicture();
      
      // Call the callback with the captured image
      widget.onPictureTaken(image);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print('Error taking picture: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto Selfie'),
        backgroundColor: const Color(0xFF007b5e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Camera preview
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          
          // Capture button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                onPressed: _isProcessing ? null : _takePicture,
                backgroundColor: const Color(0xFF007b5e),
                child: _isProcessing 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.camera_alt, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}