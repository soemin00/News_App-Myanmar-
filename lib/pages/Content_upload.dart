import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadContentPage extends StatefulWidget {
  @override
  _UploadContentPageState createState() => _UploadContentPageState();
}

class _UploadContentPageState extends State<UploadContentPage> {
  final TextEditingController _contentController = TextEditingController();
  String _username = "Loading...";
  String _profileImageUrl = "";
  String _location = "Fetching location...";
  bool _isLocationLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data (username and profile image)
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _username = userDoc['username'] ?? "Unknown User";
        _profileImageUrl = userDoc['profileImage'] ?? "";
      });
    }
  }

  // Request location permission and fetch location
  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLocationLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = "Location services are disabled.";
        _isLocationLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = "Location permission denied.";
          _isLocationLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = "Location permissions are permanently denied.";
        _isLocationLoading = false;
      });
      return;
    }

    // Fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _location =
            "${place.locality}, ${place.country}"; // e.g., "New York, USA"
        _isLocationLoading = false;
      });
    } else {
      setState(() {
        _location = "Location not found.";
        _isLocationLoading = false;
      });
    }
  }

  // Pick image from gallery or camera
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Upload image to Cloudinary and return the URL
  Future<String?> _uploadImageToCloudinary(File image) async {
    try {
      // Cloudinary API endpoint
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/dixeg7nch/image/upload');

      // Create a multipart request
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'my_upload_preset' // Use your upload preset
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      // Send the request
      final response = await request.send();

      // Check if the upload was successful
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url']; // Return the image URL
      } else {
        print("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image to Cloudinary: $e");
      return null;
    }
  }

  // Save content to Firestore
  Future<void> _saveContentToFirestore(
      String content, String? imageUrl, String location) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Save the content to Firestore
      await FirebaseFirestore.instance.collection('content').add({
        'userId': user.uid,
        'username': _username,
        'profileImageUrl': _profileImageUrl,
        'content': content,
        'imageUrl': imageUrl,
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the form after successful upload
      setState(() {
        _contentController.clear();
        _image = null;
        _location = "Fetching location...";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Content uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading content: $e")),
      );
    }
  }

  // Handle content upload
  Future<void> _handleUpload() async {
    String content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some content!")),
      );
      return;
    }

    // Upload image to Cloudinary if selected
    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImageToCloudinary(_image!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload image!")),
        );
        return;
      }
      print("Image URL: $imageUrl"); // Debug log
    }

    // Save content to Firestore
    await _saveContentToFirestore(content, imageUrl, _location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Username
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: _profileImageUrl.isNotEmpty
                      ? NetworkImage(_profileImageUrl)
                      : AssetImage('assets/images/default_profile.png')
                          as ImageProvider,
                ),
                SizedBox(width: 10),
                Text(
                  _username,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Display Location under Profile
            Text(
              _location,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Content Input Field
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Image and Location Buttons
            Row(
              children: [
                // Image Button
                IconButton(
                  icon: Icon(Icons.image, color: Colors.blue),
                  onPressed: _pickImage,
                ),
                SizedBox(width: 10),

                // Location Button
                IconButton(
                  icon: Icon(Icons.location_on, color: Colors.red),
                  onPressed: _requestLocationPermission,
                ),
              ],
            ),
            SizedBox(height: 10),

            // Display Selected Image
            if (_image != null)
              Image.file(
                _image!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),

            // Upload Button
            Center(
              child: ElevatedButton(
                onPressed: _handleUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F), // Use your theme color
                ),
                child: Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
