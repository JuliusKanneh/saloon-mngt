import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sotreDataProvider = Provider((ref) {
  return StoreData();
});

class StoreData {
  final _storage = FirebaseStorage.instance.ref();

  Future<String> uploadImageToStorage(
      {required String fileName,
      required Uint8List file,
      required String folderName}) async {
    //TODO: Fix this
    // final ref = _storage.child('$folderName/$fileName');
    // UploadTask uploadTask = ref.putData(file);
    // TaskSnapshot taskSnapshot = uploadTask.snapshot;
    final ref = _storage.child('$folderName/$fileName');
    final uploadTaskSnapshot = await ref.putData(file);
    log("Snapshot: $uploadTaskSnapshot");
    String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
