import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'camera_screen.dart';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';
import 'package:path_provider/path_provider.dart'; // Added for temp storage

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _userImage;
  bool _isProcessing = false;

  // Picks the base image (the user's avatar) from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _userImage = file;
      });

      //  Automatically trigger the AI once the image is selected!
      await _processImageWithAI(file);
    }
  }

  // Automated On-Device AI processing function
  Future<void> _processImageWithAI(File originalImage) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Prepare the imag
      final inputImage = InputImage.fromFile(originalImage);

      //Initialize the AI Segmenter
      final options = SubjectSegmenterOptions(
        enableForegroundBitmap: true,
        enableForegroundConfidenceMask: false,
        enableMultipleSubjects: SubjectResultOptions(
          enableConfidenceMask: false,
          enableSubjectBitmap: false,
        ),
      );
      final segmenter = SubjectSegmenter(options: options);

      //Run the on-device AI processing
      final result = await segmenter.processImage(inputImage);

      // Retriev the  cutout
      final foregroundBitmap = result.foregroundBitmap;

      if (foregroundBitmap != null) {
        debugPrint("AI successfully cut out the subject!");

        // Create a temporary file on the device
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/cutout_${DateTime.now().millisecondsSinceEpoch}.png';
        final transparentFile = await File(
          filePath,
        ).writeAsBytes(foregroundBitmap);

        // Overwrite the original background image with the transparent cutout
        setState(() {
          _userImage = transparentFile;
        });
      }

      segmenter.close();
    } catch (e) {
      debugPrint("AI Processing Error: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'ClosetLens',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Setup Your AR Wardrobe",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Select Your Avatar
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _userImage == null
                            ? Icons.person_add_alt_1
                            : Icons.check_circle,
                        size: 40,
                        color: _userImage == null
                            ? Colors.blueAccent
                            : Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _userImage == null
                            ? "Step 1: Choose your model photo"
                            : "Model Photo Loaded!",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          _userImage == null ? "Select Image" : "Change Image",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // AI Status Display
              if (_isProcessing)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Colors.purpleAccent),
                        SizedBox(height: 15),
                        Text(
                          "AI is analyzing and cutting out items...",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(),
              SizedBox(
                height: 60,
                child: FilledButton.icon(
                  onPressed: _userImage == null || _isProcessing
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraScreen(userImage: _userImage!),
                            ),
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.view_in_ar, size: 28),
                  label: const Text(
                    "Launch AR Matcher",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
