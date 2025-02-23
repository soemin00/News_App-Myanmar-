import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // Uncomment for image upload
// import 'dart:io'; // Uncomment for image upload

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  // File? _profileImage; // Uncomment for image upload
  // final ImagePicker _picker = ImagePicker(); // Uncomment for image upload

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture Section
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    // backgroundImage: _profileImage != null
                    //     ? FileImage(_profileImage!) // Uncomment for image upload
                    //     : null,
                    // child: _profileImage == null
                    //     ? Icon(Icons.person, size: 60, color: Colors.white)
                    //     : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD32F2F), // Use your theme color
                        shape: BoxShape.circle,
                      ),
                      child:Icon(Icons.camera_alt, color: Colors.white),

                      // child: IconButton(
                      //   icon: Icon(Icons.camera_alt, color: Colors.white),
                      //   onPressed: _pickImage, // Uncomment for image upload
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Date of Birth Field
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your date of birth";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Bio Field
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a bio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F), // Use your theme color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Save Profile",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to pick an image (commented for now)
  // Future<void> _pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       _profileImage = File(image.path);
  //     });
  //   }
  // }

  // Function to save profile (commented for now)
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save profile logic here
      // Example: Upload image to Firebase Storage, save data to Firestore, etc.
      // Uncomment and implement Firebase code later.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile saved successfully!")),
      );
    }
  }
}