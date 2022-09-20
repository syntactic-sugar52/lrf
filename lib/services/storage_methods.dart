// import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// import 'package:uuid/uuid.dart';

// class StorageMethods {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final client = SupabaseClient('https://ehdaxvwciymzvuljhrrr.supabase.co',
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoZGF4dndjaXltenZ1bGpocnJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjM2NTEyMjIsImV4cCI6MTk3OTIyNzIyMn0.dlLeqZb9A9_VLR_HPBDBKs9zaEHfZsW70GhC7BakYg4');

//   // adding image to firebase storage
//   Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {

//     if (isPost) {
//       String id = const Uuid().v1();
//       final file = File(childName);
//       file.writeAsStringSync(id);
//       final storageResponse = await client.storage.from('postupload').upload(childName, file);
//     }
//   }
// }
