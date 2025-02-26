import 'package:flutter/material.dart';
import 'package:newsapp_mm/pages/Content_upload.dart';
import 'package:newsapp_mm/pages/Signup_page.dart';
import 'package:newsapp_mm/pages/Splash.dart';
import 'package:newsapp_mm/pages/login_page.dart';
import 'package:newsapp_mm/pages/profile page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index for bottom navigation bar

  // Bottom navigation bar items
  static List<Widget> _pages = [
    HomeContent(), // Home page content
    CategoriesPage(), // News Feed page (placeholder)
    UploadContentPage(), // Post Content page
    BookmarksPage(), // Bookmarks page (placeholder)
    //ProfilePage(), // Profile page (placeholder)
  ];

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
          IconButton(
            icon: Icon(Icons.person_4_rounded),
            color: Colors.red,
            onPressed: () {
              // Navigate to profile page
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
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
            _buildBottomNavItem(Icons.bookmark, "Bookmarks", 3),
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
          image: AssetImage('assets/images/breaking_news_banner.jpg'), // Add a breaking news image
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          "Breaking News: Major Event Happening Now!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
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