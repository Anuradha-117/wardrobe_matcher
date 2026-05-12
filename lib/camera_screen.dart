import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  final File userImage; //made t store the png img of usr

  const CameraScreen({super.key, required this.userImage});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  // turn on bck cam
  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.first;

    _controller = CameraController(backCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // when leaving t.off cam
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _controller != null) {
            return Stack(
              fit: StackFit.expand, 
              children: [
                // Live Cam Feed
                CameraPreview(_controller!),

                // Transparent PNG
                Positioned.fill(
                  child: Image.file(
                    widget.userImage,
                    fit: BoxFit.contain, // Stretches the image to fit the screen
                  ),
                ),

                // made to bck frm cam screen
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          } else {
            // loading circle till cam opens
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }
}