// /*import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:newsapp_mm/pages/edit_profile_page.dart';
// //import 'package:newsapp_mm/pages/Signup_page.dart';
// //import 'package:newsapp_mm/pages/Splash.dart';
// //import 'package:newsapp_mm/pages/login_page.dart';
// import 'package:newsapp_mm/pages/profile_page.dart';
// import 'package:newsapp_mm/pages/Content_upload.dart';
// import 'package:newsapp_mm/pages/news_feed.dart';
// import 'package:newsapp_mm/pages/my_post.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import '../model/news_model.dart';
// import '../services/news_service.dart';
// import '../widgets/news_card.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   String? _profileImageUrl;

//   static final List<Widget> _pages = [
//     HomeContent(), // This now shows real news
//     NewsFeedPage(),
//     UploadContentPage(),
//     MyPostsPage(),
//     ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileImage();
//   }

//   Future<void> _fetchProfileImage() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     if (userDoc.exists) {
//       setState(() {
//         _profileImageUrl = userDoc['profileImage'];
//       });
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/logo2_withoutbg.png',
//               height: 200,
//             ),
//           ],
//         ),
//         backgroundColor: Color(0xFFFFFFFF),
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               try {
//                 final userData = await _fetchUserData();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfilePage(
//                         userId: FirebaseAuth.instance.currentUser!.uid),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Error fetching user data: $e")),
//                 );
//               }
//             },
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: _profileImageUrl != null
//                   ? CircleAvatar(
//                       backgroundImage: NetworkImage(_profileImageUrl!),
//                       radius: 20,
//                     )
//                   : Icon(
//                       Icons.person_4_rounded,
//                       color: Colors.red,
//                       size: 30,
//                     ),
//             ),
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Container(
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildBottomNavItem(Icons.home, "Home", 0),
//             _buildBottomNavItem(Icons.feed, "News Feed", 1),
//             Container(
//               margin: EdgeInsets.only(bottom: 20),
//               child: FloatingActionButton(
//                 onPressed: () {
//                   setState(() {
//                     _selectedIndex = 2;
//                   });
//                 },
//                 backgroundColor: Color(0xFFD32F2F),
//                 child: Icon(Icons.add, size: 30, color: Colors.white),
//                 elevation: 5,
//               ),
//             ),
//             _buildBottomNavItem(Icons.bookmark, "My Post", 3),
//             _buildBottomNavItem(Icons.person, "Profile", 4),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavItem(IconData icon, String label, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: _selectedIndex == index ? Color(0xFFD32F2F) : Colors.grey,
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: _selectedIndex == index ? Color(0xFFD32F2F) : Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _fetchUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("User not logged in");

//     final userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     if (!userDoc.exists) throw Exception("User data not found");

//     return userDoc.data() as Map<String, dynamic>;
//   }
// }

// // ✅ New Real-Time News HomeContent Widget
// class HomeContent extends StatefulWidget {
//   @override
//   _HomeContentState createState() => _HomeContentState();
// }

// class _HomeContentState extends State<HomeContent> {
//   late Future<List<NewsModel>> _newsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _newsFuture = _fetchNews();
//   }

//   Future<List<NewsModel>> _fetchNews() async {
//     final newsService = NewsService();
//     final data = await newsService.fetchNews();
//     final articles = data['articles'] as List;
//     return articles.map((article) => NewsModel.fromJson(article)).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<NewsModel>>(
//       future: _newsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: SpinKitFadingCircle(color: Colors.blue, size: 50.0),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error: ${snapshot.error}',
//               style: TextStyle(color: Colors.red, fontSize: 18),
//             ),
//           );
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text('No news available right now'),
//           );
//         } else {
//           final newsList = snapshot.data!;
//           return ListView.builder(
//             itemCount: newsList.length,
//             itemBuilder: (context, index) {
//               return NewsCard(news: newsList[index]);
//             },
//           );
//         }
//       },
//     );
//   }
// }
// */
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import '../model/news_model.dart';
// import '../services/news_service.dart';
// import '../widgets/news_card.dart';
// import 'profile_page.dart';
// import 'news_feed.dart';
// import 'Content_upload.dart';
// import 'my_post.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   String? _profileImageUrl;

//   static final List<Widget> _pages = [
//     HomeContent(), // News Home
//     NewsFeedPage(),
//     UploadContentPage(),
//     MyPostsPage(),
//     // ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
//     ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid)
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileImage();
//   }

//   Future<void> _fetchProfileImage() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     if (userDoc.exists) {
//       setState(() {
//         _profileImageUrl = userDoc['profileImage'];
//       });
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Image.asset(
//           'assets/images/logo2_withoutbg.png',
//           height: 150,
//         ),
//         backgroundColor: Colors.white,
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProfilePage(
//                       userId: FirebaseAuth.instance.currentUser!.uid),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _profileImageUrl != null
//                   ? CircleAvatar(
//                       backgroundImage: NetworkImage(_profileImageUrl!),
//                       radius: 20,
//                     )
//                   : Icon(Icons.person, color: Colors.red, size: 30),
//             ),
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Container(
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildBottomNavItem(Icons.home, "Home", 0),
//             _buildBottomNavItem(Icons.feed, "News Feed", 1),
//             FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _selectedIndex = 2;
//                 });
//               },
//               backgroundColor: Colors.red,
//               child: Icon(Icons.add, size: 30, color: Colors.white),
//               elevation: 5,
//             ),
//             _buildBottomNavItem(Icons.bookmark, "My Post", 3),
//             _buildBottomNavItem(Icons.person, "Profile", 4),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavItem(IconData icon, String label, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: _selectedIndex == index ? Colors.red : Colors.grey,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: _selectedIndex == index ? Colors.red : Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ✅ News Content Widget with Refresh Support
// class HomeContent extends StatefulWidget {
//   @override
//   _HomeContentState createState() => _HomeContentState();
// }

// class _HomeContentState extends State<HomeContent> {
//   late Future<List<NewsModel>> _newsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _newsFuture = _fetchNews();
//   }

//   Future<List<NewsModel>> _fetchNews() async {
//     final newsService = NewsService();
//     final data = await newsService.fetchNews();
//     final articles = data['articles'] as List;
//     return articles.map((article) => NewsModel.fromJson(article)).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         setState(() {
//           _newsFuture = _fetchNews();
//         });
//       },
//       child: FutureBuilder<List<NewsModel>>(
//         future: _newsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: SpinKitFadingCircle(color: Colors.red, size: 50.0),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: TextStyle(color: Colors.red, fontSize: 18),
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No news available right now'),
//             );
//           } else {
//             final newsList = snapshot.data!;
//             return ListView.builder(
//               itemCount: newsList.length,
//               itemBuilder: (context, index) {
//                 return NewsCard(news: newsList[index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../model/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';
import 'profile_page.dart';
import 'news_feed.dart';
import 'Content_upload.dart';
import 'my_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _profileImageUrl;

  final List<Widget> _pages = [
    HomeContent(),
    NewsFeedPage(),
    UploadContentPage(),
    MyPostsPage(),
    ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  Future<void> _fetchProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _profileImageUrl = userDoc['profileImage'];
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logo2_withoutbg.png', height: 150),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () => _onItemTapped(4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _profileImageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(_profileImageUrl!),
                      radius: 20,
                    )
                  : const Icon(Icons.person, color: Colors.red, size: 30),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, "Home", 0),
            _buildBottomNavItem(Icons.feed, "News Feed", 1),
            FloatingActionButton(
              onPressed: () => _onItemTapped(2),
              backgroundColor: Colors.red,
              child: const Icon(Icons.add, size: 30, color: Colors.white),
              elevation: 5,
            ),
            _buildBottomNavItem(Icons.bookmark, "My Post", 3),
            _buildBottomNavItem(Icons.person, "Profile", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _selectedIndex == index ? Colors.red : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.red : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _fetchNews();
  }

  Future<List<NewsModel>> _fetchNews() async {
    final newsService = NewsService();
    final data = await newsService.fetchNews();
    final articles = data['articles'] as List;
    return articles.map((e) => NewsModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitFadingCircle(color: Colors.blue, size: 50.0));
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available'));
        } else {
          final newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) => NewsCard(news: newsList[index]),
          );
        }
      },
    );
  }
}
