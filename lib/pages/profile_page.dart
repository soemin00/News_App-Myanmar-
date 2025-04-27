// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:newsapp_mm/pages/edit_profile_page.dart';
// import 'package:newsapp_mm/pages/login_page.dart';

// class ProfilePage extends StatelessWidget {
//   final String userId;

//   const ProfilePage({Key? key, required this.userId}) : super(key: key);

//   void _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<DocumentSnapshot>(
//         future:
//             FirebaseFirestore.instance.collection('users').doc(userId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("No profile data found"));
//           }

//           final userData = snapshot.data!.data() as Map<String, dynamic>;
//           final username = userData['username'] ?? "No username";
//           final email = userData['email'] ?? "No email";
//           final dob = userData['dob'] ?? "No date of birth";
//           final bio = userData['bio'] ?? "No bio";
//           final profileImage = userData['profileImage'];

//           return SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 10),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xffB81736), Color(0xff281537)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "My Profile",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.white),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         EditProfilePage(userData: userData),
//                                   ),
//                                 );
//                               },
//                             ),
//                             IconButton(
//                               icon:
//                                   const Icon(Icons.logout, color: Colors.white),
//                               onPressed: () => _logout(context),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: profileImage != null
//                         ? NetworkImage(profileImage)
//                         : null,
//                     child: profileImage == null
//                         ? const Icon(Icons.person,
//                             size: 60, color: Colors.white)
//                         : null,
//                   ),
//                   const SizedBox(height: 24),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _label("Username"),
//                         Text(username, style: const TextStyle(fontSize: 18)),
//                         const SizedBox(height: 20),
//                         _label("Email"),
//                         Text(email, style: const TextStyle(fontSize: 18)),
//                         const SizedBox(height: 20),
//                         _label("Date of Birth"),
//                         Text(dob, style: const TextStyle(fontSize: 18)),
//                         const SizedBox(height: 20),
//                         _label("Bio"),
//                         Text(bio, style: const TextStyle(fontSize: 18)),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _label(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//         color: Color(0xffB81736),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp_mm/pages/edit_profile_page.dart';
import 'package:newsapp_mm/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No profile data found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final username = userData['username'] ?? "No username";
          final email = userData['email'] ?? "No email";
          final dob = userData['dob'] ?? "No date of birth";
          final bio = userData['bio'] ?? "No bio";
          final profileImage = userData['profileImage'];

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffB81736), Color(0xff281537)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(userData: userData),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.logout, color: Colors.white),
                              onPressed: () => _logout(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage)
                        : null,
                    child: profileImage == null
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Username"),
                        Text(username, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        _label("Email"),
                        Text(email, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        _label("Date of Birth"),
                        Text(dob, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        _label("Bio"),
                        Text(bio, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xffB81736),
      ),
    );
  }
}
