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
      appBar: AppBar(title: Text("Wardrobe Matcher")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.cut),
              label: Text("1. Remove Background (Web)"),
              onPressed: _launchURL,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text("2. Load Transparent PNG"),
              onPressed: _pickImage,
            ),
            if (_userImage != null) ...[
              SizedBox(height: 20),
              Text(
                "Image Loaded Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
            ],
            SizedBox(height: 40),
            FilledButton.icon(
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
              icon: const Icon(Icons.camera_alt),
              label: const Text("3. Start AR Matcher"),
            ),
          ],
        ),
      ),
    );
  }
}
