
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoteNotificationService {
  RemoteNotificationService(
);


Future<void> SendNotification(String? title, String body,BuildContext context) async {
  Map<String, dynamic> data;

    print('updating both account and status');
    data = <String, dynamic>{
      "title": title,
      "body": body,
      "status":"deleivered",
    };

  const snackBar = SnackBar(
    content: Text('Notification Send to Administrative Body'),
  );


  ScaffoldMessenger.of(context).showSnackBar(snackBar);
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('Notifications').doc();
    await documentReference
        .set(data)
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(snackBar))
        .catchError((e) => print(e));


  }




}