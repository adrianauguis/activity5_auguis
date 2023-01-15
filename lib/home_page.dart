import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;

  Future selectImage(ImageSource source)async{
    try{
      final selectedImage = await ImagePicker().pickImage(source: source);
      if(selectedImage==null){
        return;
      }else{
        final selImage = File(selectedImage.path);
        setState(() {
          image = selImage;
        });
      }
    }on PlatformException catch(e){
      if (kDebugMode) {
        print("Failed to select image $e");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(50),
        children: [
          image!=null?Image.file(image!,width: 200,height: 200):const Icon(Icons.person),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: ()async{
                PermissionStatus filePermission = await Permission.manageExternalStorage.request();
                if (filePermission.isGranted){
                  selectImage(ImageSource.gallery);
                }else{
                  selectImage(ImageSource.gallery);
                }
              },
              child: const Text("Select Image")),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: ()async{
                var cameraPermission = await Permission.camera.request();
                if (cameraPermission.isGranted){
                  selectImage(ImageSource.camera);
                }else{
                  selectImage(ImageSource.camera);
                }
              },
              child: const Text("Use Camera")),
        ],
      ),
    );
  }
}
