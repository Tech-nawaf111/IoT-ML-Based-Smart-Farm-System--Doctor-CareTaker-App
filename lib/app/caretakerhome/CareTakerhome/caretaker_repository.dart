import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CareTakerRepo{
  DocumentReference documentReference;

  CareTakerRepo(
     this.documentReference,);



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

  Future<void> uploadCheckUpRequest(String CowID, String CheckUpType) async{
    Map<String, dynamic> data = <String, dynamic>{
      "CowID": CowID,
      "DateForCheckUp" : "",
      "EmergencyType": CheckUpType,
      "State": "NotChecked",
    };

    await documentReference
        .set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));

  }

}