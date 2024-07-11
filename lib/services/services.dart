import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/utils/file_utils.dart';
import 'package:social_media_app/utils/firebase.dart';

abstract class Service {

  //function to upload images to firebase storage and retrieve the url.
  Future<String> uploadImage(Reference ref, File file) async {
    print("!!!!!!uploadimagge");
    String ext = FileUtils.getFileExtension(file);
    print(ext);
    Reference storageReference = ref.child("${uuid.v4()}.$ext");
    print(storageReference.toString());
    UploadTask uploadTask = storageReference.putFile(file);
    try {
      await uploadTask;
      print('upload finished');
    } catch (e) {
      print("upload failed: $e");
    }
    String fileUrl = await storageReference.getDownloadURL();
    print("!!!!!!fileUrl");
    print(fileUrl);
    return fileUrl;
  }
}
