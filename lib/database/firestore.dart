import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreDatabaseee {
  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference posts =
  FirebaseFirestore.instance.collection("Users");

  final CollectionReference messages =
  FirebaseFirestore.instance.collection("messages");

  Future<void> addMessage(String message) async {
    try {
      if (user != null) {
        String email = user!.email!;
        await messages.add({
          'userEmail': email,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception("User not logged in");
      }
    } catch (error) {
      print("Failed to add message: $error");
      throw error;
    }
  }
  Future<void> addFieldToUserById(
      String userId, String fieldName, dynamic fieldValue) async {
    try {
      DocumentReference docRef = posts.doc(userId);
      await docRef.update({
        fieldName: fieldValue,
      });
    } catch (error) {
      print("Failed to update document: $error");
      throw error; // Rethrow the error after logging it
    }
  }

  Stream<QuerySnapshot> getPostsStream() {
    return posts.orderBy('timeStamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getMessagesStream() {
    return messages.orderBy('timestamp', descending: true).snapshots();
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      // Get a reference to the storage bucket location
      final Reference storageReference =
      FirebaseStorage.instance.ref().child(path);

      // Upload the file to Firebase Storage
      final UploadTask uploadTask =
      storageReference.putFile(File(image.path));

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();

      return url;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      print('FirebaseException: ${e.message}');
      throw Exception('Failed to upload image: ${e.message}');
    } catch (e) {
      // Handle other errors
      print('Exception: $e');
      throw Exception('Failed to upload image: $e');
    }
  }
}
