/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapp_mm/pages/edit_profile_page.dart';
import 'package:newsapp_mm/pages/Signup_page.dart';
import 'package:newsapp_mm/pages/Splash.dart';
import 'package:newsapp_mm/pages/login_page.dart';
import 'package:newsapp_mm/pages/profile_page.dart';
import 'package:newsapp_mm/pages/Content_upload.dart';
import 'package:newsapp_mm/pages/news_feed.dart';
import 'package:newsapp_mm/pages/my_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index for bottom navigation bar
  String? _profileImageUrl; // To store the profile image URL

  // Bottom navigation bar items
  static final List<Widget> _pages = [
    HomeContent(), // Home page content
    NewsFeedPage(), // News Feed page (placeholder)
    UploadContentPage(), // Post Content page
    MyPostsPage(),
    ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid), // Profile page
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfileImage(); // Fetch profile image when the page loads
  }

  // Fetch profile image URL from Firestore
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
      // Top Navigation Bar
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo2_withoutbg.png', // Your app logo
              height: 200, // Adjust the height as needed
            ),
          ],
        ),
        backgroundColor: Color(0xFFFFFFFF), // Use your theme color
        actions: [
          // Display profile image or default icon
          GestureDetector(
            onTap: () async {
              try {
                // Fetch user data
                final userData = await _fetchUserData();

                // Navigate to ProfilePage with user data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        userId: FirebaseAuth.instance.currentUser!.uid),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error fetching user data: $e")),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: _profileImageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(_profileImageUrl!),
                      radius: 20,
                    )
                  : Icon(
                      Icons.person_4_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
            ),
          ),
        ],
      ),

      // Body Content
      body: _pages[_selectedIndex],

      // Custom Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80, // Increase height for the lifted middle button
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Tab
            _buildBottomNavItem(Icons.home, "Home", 0),
            // News Feed Tab
            _buildBottomNavItem(Icons.feed, "News Feed", 1),
            // Post Content Button (Lifted)
            Container(
              margin: EdgeInsets.only(bottom: 20), // Lift the button
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2; // Navigate to Post Content page
                  });
                },
                backgroundColor: Color(0xFFD32F2F), // Use your theme color
                child: Icon(Icons.add, size: 30, color: Colors.white),
                elevation: 5,
              ),
            ),
            // Bookmarks Tab
            _buildBottomNavItem(Icons.bookmark, "My Post", 3),
            // Profile Tab
            _buildBottomNavItem(Icons.person, "Profile", 4),
          ],
        ),
      ),
    );
  }

  // Helper method to build bottom navigation items
  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Color(0xFFD32F2F) : Colors.grey,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Color(0xFFD32F2F) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Fetch user data from Firestore
  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User data not found");
    }

    return userDoc.data() as Map<String, dynamic>;
  }
}

// Home Page Content
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Breaking News Banner
          _buildBreakingNewsBanner(),

          // Top News Section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top News",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _buildTopNewsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Breaking News Banner
  Widget _buildBreakingNewsBanner() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/breaking_news_banner.jpg'), // Add a breaking news image
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Top News List
  Widget _buildTopNewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5, // Replace with actual news count
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: Image.asset(
              'assets/images/demo_cover.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text("NEWS Headline"),
            subtitle: Text("Short description of the news article."),
            onTap: () {
              // Navigate to news detail page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailPage()));
            },
          ),
        );
      },
    );
  }
}

// Placeholder for Categories Page
class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Categories Page"),
    );
  }
}

// Placeholder for Bookmarks Page
class BookmarksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Bookmarks Page"),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapp_mm/pages/edit_profile_page.dart';
import 'package:newsapp_mm/pages/Signup_page.dart';
import 'package:newsapp_mm/pages/Splash.dart';
import 'package:newsapp_mm/pages/login_page.dart';
import 'package:newsapp_mm/pages/profile_page.dart';
import 'package:newsapp_mm/pages/Content_upload.dart';
import 'package:newsapp_mm/pages/news_feed.dart';
import 'package:newsapp_mm/pages/my_post.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../model/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _profileImageUrl;

  static final List<Widget> _pages = [
    HomeContent(), // This now shows real news
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
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo2_withoutbg.png',
              height: 200,
            ),
          ],
        ),
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                final userData = await _fetchUserData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        userId: FirebaseAuth.instance.currentUser!.uid),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error fetching user data: $e")),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: _profileImageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(_profileImageUrl!),
                      radius: 20,
                    )
                  : Icon(
                      Icons.person_4_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
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
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, "Home", 0),
            _buildBottomNavItem(Icons.feed, "News Feed", 1),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                backgroundColor: Color(0xFFD32F2F),
                child: Icon(Icons.add, size: 30, color: Colors.white),
                elevation: 5,
              ),
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
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Color(0xFFD32F2F) : Colors.grey,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Color(0xFFD32F2F) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) throw Exception("User data not found");

    return userDoc.data() as Map<String, dynamic>;
  }
}

// ✅ New Real-Time News HomeContent Widget
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
    return articles.map((article) => NewsModel.fromJson(article)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitFadingCircle(color: Colors.blue, size: 50.0),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No news available right now'),
          );
        } else {
          final newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return NewsCard(news: newsList[index]);
            },
          );
        }
      },
    );
  }
}
