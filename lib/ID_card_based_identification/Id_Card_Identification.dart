import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class IdCardBasedIdentification extends StatefulWidget {
  IdCardBasedIdentification({
    Key? key,
  }) : super(key: key);

  @override
  _IdCardBasedIdentificationState createState() => _IdCardBasedIdentificationState();
}


class _IdCardBasedIdentificationState extends State<IdCardBasedIdentification> with SingleTickerProviderStateMixin {
  List<dynamic>? message;
  Future<Null> _cropImage() async {
    croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Android Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Iphone Cropper',
        ));

    var decodedImage =
    await decodeImageFromList(croppedFile!.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);

    if (!mounted) return;
    setState(() {
      if (croppedFile != null) {
        imageFile = croppedFile;
      }
    });
  }

  ///Media selecter that is in use for selecting photo from camera or Galary

  mediaTypeSelector() async {
    _getFromGallery() async {
      print('reached here');
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        setState(() {
          print('reached here 2');
          imageFile = File(pickedFile.path);
        });
      }
      _cropImage();
      // Navigator.of(context).pop();
    }

    /// Get from Camera
    // ignore: always_declare_return_types
    _getFromCamera() async {
      // ignore: deprecated_member_use
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
      _cropImage();
      // Navigator.of(context).pop();
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose image source'),
          content: Text(""),
          actions: <Widget>[
            ElevatedButton(
              child: new Column(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(height: 8),
                  Text("Camera"),
                ],
              ),
              onPressed: () => _getFromCamera(),
            ),
            ElevatedButton(
              child: new Column(
                children: [
                  Icon(Icons.browse_gallery_outlined),
                  SizedBox(height: 8),
                  Text("Galary"),
                ],
              ),
              onPressed: () => _getFromGallery(),
            ),
          ],
        );
      },
    );
  }

  File? imageFile;
  File? croppedFile;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  uploadImage() async{
    final request = http.MultipartRequest(
        "POST" , Uri.parse("https://2ce0-182-187-124-51.in.ngrok.io/upload")
    );
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        croppedFile!.readAsBytes().asStream(),
        croppedFile!.lengthSync(),
        filename: croppedFile!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];

    print('i receive the following method');
    print(res);
    final doubbList;
    doubbList = message?.map((element) => double.parse(element)).toList();

    setState(() {
      croppedFile = null;
    });

  }

  @override
  Widget build(BuildContext context) {
    mediaTypeSelector() async {
      _getFromGallery() async {
        print('reached here');
        final pickedFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
          maxWidth: 300,
          maxHeight: 300,
        );
        if (pickedFile != null) {
          setState(() {
            print('reached here 2');
            imageFile = File(pickedFile.path);
          });
        }
        // Navigator.of(context).pop();
      }

      /// Get from Camera
      // ignore: always_declare_return_types
      _getFromCamera() async {
        final pickedFile = await ImagePicker().getImage(
          source: ImageSource.camera,
          maxWidth: 300,
          maxHeight: 300,
        );
        if (pickedFile != null) {
          setState(() {
            imageFile = File(pickedFile.path);
          });
        }
      }

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose image source'),
            content: Text(""),
            actions: <Widget>[
              ElevatedButton(
                child: Column(
                  children: const [
                    Icon(Icons.camera_alt_outlined),
                    SizedBox(height: 8),
                    Text("Camera"),
                  ],
                ),
                onPressed: () => _getFromCamera(),
              ),
              ElevatedButton(
                child: Column(
                  children: const [
                    Icon(Icons.browse_gallery_outlined),
                    SizedBox(height: 8),
                    Text("Galary"),
                  ],
                ),
                onPressed: () => _getFromGallery(),
              ),
            ],
          );
        },
      );
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF292723),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: const Text(
          'Register Cow',
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    child: imageFile == null
                        ? Image.asset("assets/images/RegisterCow.png")
                        : Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),

                    //   backgroundColor: Color(0xFF292723),

                    height: 200,
                    width: 300,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black),
                  ),
                  Positioned(
                    child: GestureDetector(
                      child: const CircleAvatar(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF292723),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      onTap: mediaTypeSelector,
                    ),
                    top: 152.0,
                    right: 0.0,
                  )
                ],
              ),

              Container(
                  height: 50,
                  width: 340,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF292723),
                    ),
                    child: const Text('Register Cow'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}