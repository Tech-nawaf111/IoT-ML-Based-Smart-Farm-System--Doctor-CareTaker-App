import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentication_repository/authentication_repository.dart';

///Repository to set and retrieve user status to firebase cloud database

class StatusRepository {
  User? user;
  FirebaseFirestore firestore;
  CollectionReference _mainCollection;
  DocumentReference documentReference;

  StatusRepository(
      this.firestore, this._mainCollection, this.documentReference, this.user);

  /// get user status pending,approved or null from server

  Future<List<String>> getApprovalStatus() async {
    String status = "null";
    String accountType = "null";
    await documentReference.get().then((dataSnapshot) {
      try {
        //  print(status);
        status = (dataSnapshot.data() as dynamic)["Status"];
        accountType = (dataSnapshot.data() as dynamic)["AccountType"];
      } catch (_) {}
    });
    print("getting approval status");
    print([status, accountType]);
    return [status, accountType];
    accountType;
    ;
  }


  // String name = "";
  // await documentReference.get().then((dataSnapshot) {
  // try {
  // name = (dataSnapshot.data() as dynamic)["name"];
  // } catch (_) {}
  // });

  /// setting user status to pending when first time user request for any account type

  Future<void> setApprovalStatus(String? account, String status) async {
    Map<String, dynamic> data;
    if (account != null){
      print('updating both account and status');
      data = <String, dynamic>{
        "Status": status,
        "AccountType": account,
      };

      DocumentReference documentReferencer = _mainCollection.doc(user?.email);
      await documentReferencer
          .set(data)
          .whenComplete(() => print("Notes item added to the database"))
          .catchError((e) => print(e));
    }else{
      print('updating only status');
      data = <String, dynamic>{
        "Status": status,
      };

      FirebaseFirestore.instance.collection('Approval').doc(user?.email).update({'Status':status});
    }



  }
}
