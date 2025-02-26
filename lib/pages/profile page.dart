import 'package:flutter/material.dart';
import 'dart:io'; // For handling file operations

class ProfilePage extends StatefulWidget {
  final String username;
  final String dob;
  final String bio;
  final File? profileImage;

  const ProfilePage({
    Key? key,
    required this.username,
    required this.dob,
    required this.bio,
    this.profileImage,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xffB81736), // Match the theme color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Half-Circle with Gradient and Profile Image
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none, // Allow the CircleAvatar to overflow
              children: [
                // Gradient Half-Circle Shape
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffB81736), // Start color
                        Color(0xff281537), // End color
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                // Profile Image (Overlapping the Half-Circle)
                Positioned(
                  top: 75, // Adjust this value to position the image
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Add a border for better visibility
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: widget.profileImage != null
                          ? FileImage(widget.profileImage!) // Use selected image
                          : null,
                      child: widget.profileImage == null
                          ? Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80), // Add space below the profile image

            // Profile Information
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffB81736), // Theme color
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.username,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),

                  // Date of Birth
                  Text(
                    "Date of Birth",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffB81736), // Theme color
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.dob,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),

                  // Bio
                  Text(
                    "Bio",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffB81736), // Theme color
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.bio,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}