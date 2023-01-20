import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

openLoadingDialog(BuildContext context, String text, bool state) {
  if(state == true){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 35, height: 35, child: LoadingWidget()),
            const SizedBox(height: 15),
            Text(text + "...")
          ],
        ),
      ),
    );}
  else{
    Navigator.of(context, rootNavigator: true).pop();
  }
}



class LoadingWidget extends Center {
  LoadingWidget()
      : super(
    child: SizedBox(
      width: 45,
      height: 45,
      child: SpinKitFoldingCube(color: Color(0xffff1616)),
    ),
  );
}
