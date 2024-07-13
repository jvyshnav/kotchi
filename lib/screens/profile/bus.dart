import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateDataPage extends StatefulWidget {
  @override
  CreateDataPageState createState() => CreateDataPageState();
}

class CreateDataPageState extends State<CreateDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bagColorController = TextEditingController();
  final _ageController = TextEditingController();
  final _umbrellaColorController = TextEditingController();


  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the current user's email
        final String email = FirebaseAuth.instance.currentUser?.email ?? "";

        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to get the user email. Please log in again.'),
            ),
          );
          return;
        }

        print("Current user's email: $email");

        // Query user document from "users" collection
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs.first.data();
          final String username = userData['username'] ?? "";

          print("Retrieved username: $username");

          // Now you have the username and can use it
          await FirebaseFirestore.instance.collection('Thursday').add({
            'name': _nameController.text,
            'bagColor': _bagColorController.text,
            'age': int.parse(_ageController.text),
            'umbrellaColor': _umbrellaColorController.text,
            'username': username, // Use the retrieved username
          });

          await FirebaseFirestore.instance.collection(username).add({
            'name': _nameController.text,
            'bagColor': _bagColorController.text,
            'age': int.parse(_ageController.text),
            'umbrellaColor': _umbrellaColorController.text,
            'username': username, // Use the retrieved username
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data saved successfully!'),
            ),
          );

          _formKey.currentState!.reset();
          Navigator.pop(context);
        } else {
          // Handle the case where the user document doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User document not found!'),
            ),
          );
          print("User document not found! Email queried: $email");
        }
      } catch (e) {
        // Handle any errors that occur during the data retrieval and saving process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save data: $e'),
          ),
        );
        print("Error during data save: $e");
      }
    }
  }

  Future<void> _printAllUserDocuments() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in querySnapshot.docs) {
      print("Document ID: ${doc.id}, Data: ${doc.data()}");
    }
  }

  @override
  void initState() {
    super.initState();
    _printAllUserDocuments(); // Optionally call this function at init to print all documents
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Data'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 150),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _bagColorController,
                  decoration: InputDecoration(
                    labelText: 'field',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bag color';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _umbrellaColorController,
                  decoration: InputDecoration(
                    labelText: 'Umbrella Color',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an umbrella color';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Save Data',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bagColorController.dispose();
    _ageController.dispose();
    _umbrellaColorController.dispose();
    super.dispose();
  }
}
