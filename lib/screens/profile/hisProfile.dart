import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Hisprofile extends StatelessWidget {
  final String username;

  const Hisprofile({Key? key, required this.username});

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Thursday")
        .where('name', isEqualTo: username)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("User data not available"),
            );
          }

          final userData = snapshot.data!.data()!;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  MyNamedContainer(text: "Name : ${userData['name']}"),
                  MyNamedContainer(text: "field : ${userData['bagColor']}"),
                  MyNamedContainer(text: "Age : ${userData['age']}"),
                  MyNamedContainer(text: "Umbrella Color : ${userData['umbrellaColor']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyNamedContainer extends StatelessWidget {
  final String text;

  const MyNamedContainer({Key? key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: GoogleFonts.abhayaLibre(fontSize: 21, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
