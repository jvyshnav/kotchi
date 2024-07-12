import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kotchi/screens/profile/bus.dart';
import 'package:kotchi/screens/profile/hisProfile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? currentUsername;
  String? currentUserRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserDetails();
  }

  void fetchCurrentUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          currentUsername = userDoc['username'];
          currentUserRole = userDoc['role'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      displayMessageToUser("Failed to fetch user details: $e", context);
      setState(() {
        isLoading = false;
      });
    }
  }

  void displayMessageToUser(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void deleteUser(String userId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Thursday')
          .doc(userId)
          .delete();
      displayMessageToUser("User deleted successfully", context);
    } catch (error) {
      displayMessageToUser("Failed to delete user: $error", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("USERS"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("USERS"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: currentUsername == null
          ? Center(
        child: Text("No user logged in"),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: currentUserRole == 'admin'
            ? FirebaseFirestore.instance.collection('Thursday').snapshots()
            : FirebaseFirestore.instance
            .collection('Thursday')
            .where('username', isEqualTo: currentUsername)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No data"),
            );
          }

          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data() as Map<String, dynamic>;

              final username = userData.containsKey('name')
                  ? userData['name']
                  : 'No username';
              final age = userData.containsKey('age')
                  ? userData['age'].toString()
                  : 'No age available';

              return Padding(
              padding: const EdgeInsets.only(
              left: 10, right: 10, bottom: 15, top: 10),
              child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
              boxShadow: [
              BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.4),
              spreadRadius: 2,
              offset: Offset(0, 2),
              blurRadius: 5,
              )
              ],
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)),
              child: ListTile(
              leading: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
              ),
              ),
              title: Text(
              username,
              style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(age),
              trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              IconButton(
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) =>
              Hisprofile(username: username),
              ),
              );
              },
              icon: Icon(Icons.arrow_forward_ios),
              ),
              IconButton(
              onPressed: () {
              return deleteUser(user.id, context);
              },
              icon: Icon(
              Icons.delete_outline,
              size: 24,
              color: Colors.red,
              ))
              ],
              ),
              ),
              ),
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CreateDataPage();
              },
            ));
          },
          backgroundColor: Colors.pinkAccent.shade100,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}