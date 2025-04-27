/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  String? _selectedLocation;
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showSearchBar
            ? _buildSearchBar()
            : Text(
                "News Feed",
                selectionColor: Colors.white,
              ),
        backgroundColor: Color(0xFFD32F2F),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _selectedLocation = null;
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('content')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No posts available."));
          }

          final posts = snapshot.data!.docs;

          final filteredPosts = _selectedLocation == null
              ? posts
              : posts
                  .where((doc) => doc['location'] == _selectedLocation)
                  .toList();

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text("No posts available for the selected location."),
            );
          }

          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index].data() as Map<String, dynamic>;
              final postId = filteredPosts[index].id;
              final userId = FirebaseAuth.instance.currentUser?.uid;
              final posterId = post['userId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(posterId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return SizedBox.shrink(); // skip if loading
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  final username = userData?['username'] ?? 'Unknown';
                  final profileImage = userData?['profileImage'];

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profileImage != null
                                ? NetworkImage(profileImage)
                                : AssetImage(
                                        'assets/images/default_profile.png')
                                    as ImageProvider,
                          ),
                          title: Text(
                            username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(post['location']),
                        ),

                        // Content
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(post['content']),
                        ),

                        // Image (if available)
                        if (post['imageUrl'] != null)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.network(
                              post['imageUrl'],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),

                        // Delete Button
                        if (userId == posterId)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Delete Post"),
                                    content: Text(
                                        "Are you sure you want to delete this post?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  await FirebaseFirestore.instance
                                      .collection('content')
                                      .doc(postId)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Post deleted successfully!"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search by location...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white),
      onSubmitted: (value) {
        setState(() {
          _selectedLocation = value;
        });
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  String? _selectedLocation;
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showSearchBar
            ? _buildSearchBar()
            : Text("News Feed", selectionColor: Colors.white),
        backgroundColor: Color(0xFFD32F2F),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _selectedLocation = null;
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('content')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No posts available."));
          }

          final posts = snapshot.data!.docs;

          final filteredPosts = _selectedLocation == null
              ? posts
              : posts
                  .where((doc) => doc['location'] == _selectedLocation)
                  .toList();

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text("No posts available for the selected location."),
            );
          }

          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index].data() as Map<String, dynamic>;
              final postId = filteredPosts[index].id;
              final userId = FirebaseAuth.instance.currentUser?.uid;
              final posterId = post['userId'];

              // Format timestamp
              final timestamp = post['timestamp'] as Timestamp?;
              String formattedTime = '';
              if (timestamp != null) {
                final postTime = timestamp.toDate();
                final now = DateTime.now();
                final difference = now.difference(postTime);

                if (difference.inHours < 24) {
                  formattedTime = DateFormat('hh:mm a').format(postTime);
                } else {
                  formattedTime = DateFormat('dd MMM yyyy').format(postTime);
                }
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(posterId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return SizedBox.shrink();
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  final username = userData?['username'] ?? 'Unknown';
                  final profileImage = userData?['profileImage'];

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info Row + Timestamp
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: profileImage != null
                                        ? NetworkImage(profileImage)
                                        : AssetImage(
                                                'assets/images/default_profile.png')
                                            as ImageProvider,
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        post['location'] ?? '',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Post Content
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(post['content'] ?? ''),
                        ),

                        // Image
                        if (post['imageUrl'] != null)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.network(
                              post['imageUrl'],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),

                        // Delete Button
                        if (userId == posterId)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Delete Post"),
                                    content: Text(
                                        "Are you sure you want to delete this post?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  await FirebaseFirestore.instance
                                      .collection('content')
                                      .doc(postId)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Post deleted successfully!"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search by location...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white),
      onSubmitted: (value) {
        setState(() {
          _selectedLocation = value;
        });
      },
    );
  }
}
