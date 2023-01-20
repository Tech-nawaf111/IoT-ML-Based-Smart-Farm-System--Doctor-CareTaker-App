
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/app/profiles/model/profile_model.dart';
 import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// CreateProfile repository is used for performing backend operatings
/// required for profile handling.

class CreateProfile{
  String? useremail;
  FirebaseFirestore firestore;
  CollectionReference _mainCollection;
  DocumentReference documentReference;
  static final _firebaseStorage = FirebaseStorage.instance;

  CreateProfile(
      this.firestore, this._mainCollection, this.documentReference,this.useremail);



  /// Upload Profile
  /// normal ok
  /// id card format invalid ok
  /// photo no availble ok
  /// phone number not verified ok
  /// phone number size invalid ok
  /// accountype not selected
  /// field empty
  /// pic greater than 1mb ok
  /// profile no url returned ok





  Future<void> uploadProfile(ProfileModel profileModel) async{
    String url = await uploadFile(profileModel.imageFile?.path);
    Map<String, dynamic> data = <String, dynamic>{
      "FirstName": profileModel.Firstname,
      "LastName" : profileModel.Lastname,
      "DateOfBirth": profileModel.DateofBirth,
      "IdCardNumber": profileModel.IDcardnumber,
      "PhoneNumber" : profileModel.PhoneNumber,
    "Address" :profileModel.Address,
    "AccountType":profileModel.Type,
      "profilePhotoURL" :url,

    };
    DocumentReference documentReferencer =
    _mainCollection.doc(useremail);
    print(useremail);
    await documentReferencer
        .set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));

  }


/// upload photo to firebase Cloud Storage and return its URL

  static Future<String> uploadFile(String? path) async {
  try {
  final _fileName = DateTime.now().toIso8601String();
  final _reference = _firebaseStorage.ref().child(_fileName);
  final _task = await _reference.putFile(File(path!));
  return await _task.ref.getDownloadURL();
  } catch (e) {
  rethrow;
  }
  }

/// RetreiveProfile from firebase realtime database and photo from Cloud storage

  Future<List<String>> RetreiveProfile() async{
    String Firstname = "";
    String Lastname= "";
    String DateofBirth="";
    String IDcardnumber="";
    String PhoneNumber="";
    String  Address="";
    String Type="";
    String imageFileURL="";

    await documentReference.get().then((dataSnapshot) {
      print(documentReference);
      try {

        Firstname = (dataSnapshot.data() as dynamic)["FirstName"];
        print("name is "+Firstname);
        Lastname = (dataSnapshot.data() as dynamic)["LastName"];
        DateofBirth = (dataSnapshot.data() as dynamic)["DateOfBirth"];
        IDcardnumber = (dataSnapshot.data() as dynamic)["IdCardNumber"];
        PhoneNumber = (dataSnapshot.data() as dynamic)["PhoneNumber"];
        Address = (dataSnapshot.data() as dynamic)["Address"];
        Type = (dataSnapshot.data() as dynamic)["AccountType"];
        imageFileURL = (dataSnapshot.data() as dynamic)["profilePhotoURL"];
        print("data recieved successfully");
      } catch (_) {
        print("nothing recieved");
      }
    });
    print("Data Retreived");
    return [Firstname, Lastname, DateofBirth,IDcardnumber,PhoneNumber,Address,Type,imageFileURL];
    ;


  }







 }