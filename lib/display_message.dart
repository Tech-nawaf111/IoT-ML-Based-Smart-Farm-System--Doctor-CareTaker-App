import 'package:flutter/material.dart';

class displayMessage {
  BuildContext context;
  String? Errormessage;

  displayMessage(this.context,
      this.Errormessage
      );

  AlertDialog message() {
    return AlertDialog(
      title: Text('Error'),
      content: Text(Errormessage!),
      actions: <Widget>[
        ElevatedButton(
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),

      ],
    );
  }
}
