import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'camera_screen.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _userImage;

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://www.remove.bg/upload');
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _userImage = File(pickedFile.path);
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
                "Setup Your AR Avatar",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_fix_high,
                        size: 40,
                        color: Colors.purpleAccent,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Step 1: Create your cutout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _launchURL,
                            icon: const Icon(Icons.open_in_browser),
                            label: const Text("Open Remove.bg"),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.help_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("How To Do"),
                                    content: const Text(''' 
1. Open Remove.bg using the button.

2. Upload a full-body photo of yourself.

3. Switch to the 'Cutout' tab and use Eraser.

4. Erase the clothing item you want to 
   replace (e.g., your shirt).

5. Download the image.
                                    '''),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("close"),
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

              const SizedBox(height: 20),

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
                            ? Icons.image_search
                            : Icons.check_circle,
                        size: 40,
                        color: _userImage == null
                            ? Colors.blueAccent
                            : Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _userImage == null
                            ? "Step 2: Load your downloaded image"
                            : "Image Loaded Successfully!",
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

              const Spacer(),
              SizedBox(
                height: 60,
                child: FilledButton.icon(
                  onPressed: _userImage == null
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
