
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/app/cow_treatment/cow_treatement_model.dart';
import 'package:fyp/app/profiles/model/profile_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// CreateProfile repository is used for performing backend operatings
/// required for profile handling.


class Treatment{
  String? cowID;
  FirebaseFirestore firestore;
  CollectionReference _mainCollection;
  DocumentReference documentReference;

  Treatment(
      this.firestore, this._mainCollection, this.documentReference,this.cowID);



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

  Future<void> uploadTreatment(CowTreatmentModel cowTreatmentModel) async{
    Map<String, dynamic> data = <String, dynamic>{
      "CowID": cowTreatmentModel.id,
      "Medicine": cowTreatmentModel.Medicine,
      "StartDate": cowTreatmentModel.StartDate,
      "LastDate": cowTreatmentModel.LastDate,
      "CurrentDate": cowTreatmentModel.StartDate,
      "DaysCount": cowTreatmentModel.DaysCount,
      "time": cowTreatmentModel.time,
      "dose": cowTreatmentModel.dose,
      "State": cowTreatmentModel.State,



    };
    DocumentReference documentReferencer =
    _mainCollection.doc();
    print(cowID);
    await documentReferencer
        .set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));

  }

  //
  // Future<List<String>> RetreiveCowTreatment() async{
  //   String Medicine ="";
  //   String StartDate="";
  //   String LastDate ="";
  //   String DaysCount="";
  //   String time="";
  //   String State="";
  //
  //   await documentReference.get().then((dataSnapshot) {
  //     print(documentReference);
  //     try {
  //
  //       Medicine = (dataSnapshot.data() as dynamic)["Medicine"];
  //       StartDate = (dataSnapshot.data() as dynamic)["StartDate"];
  //       LastDate = (dataSnapshot.data() as dynamic)["LastDate"];
  //       DaysCount = (dataSnapshot.data() as dynamic)["DaysCount"];
  //       time = (dataSnapshot.data() as dynamic)["time"];
  //       State = (dataSnapshot.data() as dynamic)["State"];
  //       print("data recieved successfully");
  //     } catch (_) {
  //       print("nothing recieved");
  //     }
  //   });
  //   print("Data Retreived");
  //   return [Medicine, StartDate, LastDate,DaysCount,time,State];
  //   ;
  //
  //
  // }
  //
  //





}