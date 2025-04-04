import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("User not logged in"));
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('content')
            .where('userId',
                isEqualTo: user.uid) // Fetch posts by the current user
            .orderBy('timestamp', descending: true) // Show latest posts first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (snapshot.error.toString().contains("FAILED_PRECONDITION")) {
              return Center(
                child: Text(
                  "Index is being created. Please wait a few minutes and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No posts available."));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final postId = posts[index].id; // Get the document ID of the post

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: post['profileImageUrl'] != null
                            ? NetworkImage(post['profileImageUrl'])
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                      ),
                      title: Text(
                        post['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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

                    // Delete Button (only for the post owner)
                    if (user.uid == post['userId'])
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Confirm deletion
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
                              // Delete the post
                              await FirebaseFirestore.instance
                                  .collection('content')
                                  .doc(postId)
                                  .delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Post deleted successfully!")),
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
      ),
    );
  }
}
