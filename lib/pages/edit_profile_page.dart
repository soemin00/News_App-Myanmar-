import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart'; // For image upload
import 'dart:io'; // For handling file operations

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();


  File? _profileImage; // To store the selected image
  //final ImagePicker _picker = ImagePicker(); // For picking images
  bool _showEditButton = false; // To control the visibility of the floating button/hover text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showEditButton = !_showEditButton; // Toggle floating button/hover text
                      });
                    },
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
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) // Use selected image
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
                // Floating Button/Hover Text
                if (_showEditButton)
                  Positioned(
                    top: 160, // Adjust this value to position the button
                    child: GestureDetector(
                      onTap: (){},
                      //onTap: _pickImage, // Open gallery to select image
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: Color(0xffB81736)), // Edit icon
                            SizedBox(width: 8),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffB81736), // Theme color for text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 80), // Add space below the profile image

            // Profile Form
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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

                    //email field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.key),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your new password";
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
                      onPressed: (){},
                      //onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffB81736), // Use your theme color
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
          ],
        ),
      ),
    );
  }

// Function to pick an image from the gallery
// Future<void> _pickImage() async {
//   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//   if (image != null) {
//     setState(() {
//       _profileImage = File(image.path); // Set the selected image
//       _showEditButton = false; // Hide the floating button/hover text after selection
//     });
//   }
// }
//
// // Function to save profile (commented for now)
// void _saveProfile() {
//   if (_formKey.currentState!.validate()) {
//     // Save profile logic here
//     // Example: Upload image to Firebase Storage, save data to Firestore, etc.
//     // Uncomment and implement Firebase code later.
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Profile saved successfully!")),
//     );
//   }
// }
}