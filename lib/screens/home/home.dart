import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kotchi/auth/auth.dart';
import 'package:kotchi/database/firestore.dart';
import '../../components/my_post_button.dart';
import '../../components/my_textfield.dart';
import '../../components/mydrawer.dart';
import '../signup/register.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final FirestoreDatabaseee database = FirestoreDatabaseee();
  final TextEditingController newPostController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $error')),
      );
    });
  }

  void postMessage() {
    if (newPostController.text.isNotEmpty && currentUser != null) {
      String message = newPostController.text;
      database.addMessage(message);
      newPostController.clear();
    }
  }

  void deleteMessage(String messageId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('messages').doc(messageId).delete();
      displayMessageToUser("Message deleted successfully", context);
    } catch (error) {
      displayMessageToUser("Failed to delete message: $error", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_outlined, size: 35),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyTextField(
                      hintText: "Say something",
                      controller: newPostController,
                    ),
                  ),
                  PostButton(
                    onTap: postMessage,
                  ),
                ],
              ),
            ),
            Expanded(
              child: currentUser == null
                  ? const Center(child: Text("No user logged in"))
                  : StreamBuilder(
                stream: database.getMessagesStream(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No posts...post something..."));
                  }

                  final posts = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      String message = post['message'] ?? '';
                      dynamic timestampData = post['timestamp'];

                      Timestamp timestamp;
                      if (timestampData is Timestamp) {
                        timestamp = timestampData;
                      } else {
                        // Fallback to current timestamp if not a valid Timestamp
                        timestamp = Timestamp.now();
                      }

                      DateTime dateTime = timestamp.toDate();
                      String formattedDate = DateFormat('MMM d, yyyy').format(dateTime);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(message),
                          subtitle: Text(formattedDate),
                          trailing: IconButton(
                            onPressed: () {
                              deleteMessage(post.id, context);
                            },
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
