import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kotchi/screens/profile/bus.dart';


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
          title: Text("CLENTS"),
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
        title: Text("CLIENTS"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: currentUsername == null
          ? Center(
              child: Text("No user logged in"),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: currentUserRole == 'admin'
                  ? FirebaseFirestore.instance
                      .collection('Thursday')
                      .snapshots()
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
                    final field = userData.containsKey('bagColor')
                        ? userData['bagColor'].toString()
                        : 'No field available';
                    final umbrellaColor = userData.containsKey('umbrellaColor')
                        ? userData['umbrellaColor'].toString()
                        : 'No color available';
                    final careof = userData.containsKey('username')
                        ? userData['username'].toString()
                        : 'No name available';

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 5, top: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: $username",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Field: $field"),
                                Text("Age: $age"),
                                Text("Umbrella colour: $umbrellaColor"),
                                Text("Care of: $careof"),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: IconButton(
                                  onPressed: () {
                                    return deleteUser(user.id, context);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent.shade400,
                                  )),
                            )
                          ],
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
