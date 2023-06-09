import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase app
  await Firebase.initializeApp();

  // Retrieve all the collections in the database
  var collections = await FirebaseFirestore.instance.listCollections();
  for (var collection in collections) {
    print('Collection Name: ${collection.id}');

    // Retrieve all the documents in the collection
    var documents = await collection.get();
    for (var document in documents.docs) {
      print('Document ID: ${document.id}');

      // Retrieve all the subcollections of the document
      var subcollections = await document.reference.collections();
      for (var subcollection in subcollections) {
        print('Subcollection Name: ${subcollection.id}');
      }
    }
  }
}
