// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:newsapp_mm/pages/profile_page.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EditProfilePage extends StatefulWidget {
//   final Map<String, dynamic> userData;

//   const EditProfilePage({Key? key, required this.userData}) : super(key: key);

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _usernameController;
//   late TextEditingController _emailController;
//   late TextEditingController _dobController;
//   late TextEditingController _bioController;

//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _usernameController =
//         TextEditingController(text: widget.userData['username']);
//     _emailController = TextEditingController(text: widget.userData['email']);
//     _dobController = TextEditingController(text: widget.userData['dob']);
//     _bioController = TextEditingController(text: widget.userData['bio']);
//   }

//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           _profileImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   // Upload image to Cloudinary and return the URL
//   Future<String?> _uploadImageToCloudinary(File image) async {
//     try {
//       final url =
//           Uri.parse('https://api.cloudinary.com/v1_1/dixeg7nch/image/upload');

//       final request = http.MultipartRequest('POST', url)
//         ..fields['upload_preset'] = 'my_upload_preset'
//         ..files.add(await http.MultipartFile.fromPath('file', image.path));

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final responseData = await response.stream.bytesToString();
//         final jsonResponse = jsonDecode(responseData);
//         return jsonResponse['secure_url'];
//       } else {
//         print("Failed to upload image: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error uploading image to Cloudinary: $e");
//       return null;
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? user = FirebaseAuth.instance.currentUser;
//         if (user == null) {
//           throw Exception("User not logged in");
//         }

//         String? imageUrl;
//         if (_profileImage != null) {
//           imageUrl = await _uploadImageToCloudinary(_profileImage!);
//           if (imageUrl == null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Failed to upload profile image!")),
//             );
//             return;
//           }
//         }

//         String newUsername = _usernameController.text.trim();
//         String newEmail = _emailController.text.trim();
//         String newDob = _dobController.text.trim();
//         String newBio = _bioController.text.trim();
//         String finalProfileImageUrl =
//             imageUrl ?? widget.userData['profileImage'];

//         await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//           'username': newUsername,
//           'email': newEmail,
//           'dob': newDob,
//           'bio': newBio,
//           'profileImage': finalProfileImageUrl,
//         });

//         // 🔥 Update all user posts in content collection
//         await FirebaseFirestore.instance
//             .collection('content')
//             .where('userId', isEqualTo: user.uid)
//             .get()
//             .then((snapshot) {
//           for (var doc in snapshot.docs) {
//             doc.reference.update({
//               'username': newUsername,
//               'profileImageUrl': finalProfileImageUrl,
//             });
//           }
//         });

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProfilePage(userId: user.uid),
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error saving profile: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.bottomCenter,
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   height: 150,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xffB81736), Color(0xff281537)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(150),
//                       bottomRight: Radius.circular(150),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 75,
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 4),
//                       ),
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.grey[300],
//                         backgroundImage: _profileImage != null
//                             ? FileImage(_profileImage!)
//                             : widget.userData['profileImage'] != null
//                                 ? NetworkImage(widget.userData['profileImage'])
//                                 : null,
//                         child: _profileImage == null &&
//                                 widget.userData['profileImage'] == null
//                             ? Icon(Icons.person, size: 60, color: Colors.white)
//                             : null,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 80),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         labelText: "Username",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         prefixIcon: Icon(Icons.person),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter a username";
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         prefixIcon: Icon(Icons.email),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter your email address";
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _dobController,
//                       decoration: InputDecoration(
//                         labelText: "Date of Birth",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         prefixIcon: Icon(Icons.calendar_today),
//                       ),
//                       onTap: () async {
//                         final DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(1900),
//                           lastDate: DateTime.now(),
//                         );
//                         if (pickedDate != null) {
//                           setState(() {
//                             _dobController.text =
//                                 "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                           });
//                         }
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter your date of birth";
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _bioController,
//                       decoration: InputDecoration(
//                         labelText: "Bio",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         prefixIcon: Icon(Icons.edit),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter a bio";
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: _saveProfile,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xffB81736),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       child: Text(
//                         "Save Profile",
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapp_mm/pages/home_page.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _bioController;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.userData['username']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _dobController = TextEditingController(text: widget.userData['dob']);
    _bioController = TextEditingController(text: widget.userData['bio']);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Upload image to Cloudinary and return the URL
  Future<String?> _uploadImageToCloudinary(File image) async {
    try {
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/dixeg7nch/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'my_upload_preset'
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url'];
      } else {
        print("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image to Cloudinary: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }

        String? imageUrl;
        if (_profileImage != null) {
          imageUrl = await _uploadImageToCloudinary(_profileImage!);
          if (imageUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to upload profile image!")),
            );
            return;
          }
        }

        String newUsername = _usernameController.text.trim();
        String newEmail = _emailController.text.trim();
        String newDob = _dobController.text.trim();
        String newBio = _bioController.text.trim();
        String finalProfileImageUrl =
            imageUrl ?? widget.userData['profileImage'];

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': newUsername,
          'email': newEmail,
          'dob': newDob,
          'bio': newBio,
          'profileImage': finalProfileImageUrl,
        });

        // 🔥 Update all user posts in content collection
        await FirebaseFirestore.instance
            .collection('content')
            .where('userId', isEqualTo: user.uid)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({
              'username': newUsername,
              'profileImageUrl': finalProfileImageUrl,
            });
          }
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving profile: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffB81736), Color(0xff281537)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : widget.userData['profileImage'] != null
                                ? NetworkImage(widget.userData['profileImage'])
                                : null,
                        child: _profileImage == null &&
                                widget.userData['profileImage'] == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffB81736),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
}
