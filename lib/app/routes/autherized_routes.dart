import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/approval/view/approval_screen.dart';
import '../../app/profiles/caretaker_profile/create_profile/view/User_profile.dart';
import '../../display_message.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../home/states/status_auth.dart';
import '../../home/view/account_type.dart';

class AutherizedRoutes extends StatefulWidget {
  const AutherizedRoutes({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: AutherizedRoutes());

  @override
  _AutherizedRoutes createState() => _AutherizedRoutes();
}

class _AutherizedRoutes extends State<AutherizedRoutes> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isTrueForDoctor = false;
  bool isTrueForCareTaker = false;
  displayMessage? displaymessage;

  initState() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

       /// Checking the current user status from backend (firebase)
        /// and navigating them accordingly to respective screens


        firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
        final user = _auth.currentUser!;
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        final CollectionReference _mainCollection =
            _firestore.collection('Approval');
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('Approval').doc(user.email);
        StatusRepository? statusRepository = new StatusRepository(

            _firestore, _mainCollection, documentReference, null);
        List<String> Route = await statusRepository.getApprovalStatus();

        print("the status from here is ");
        print(Route);

        /// if user already created account and request admin for approval,
        /// but admin have not accept it yet than he ll be redirected to
        /// Approval page

        if (Route[0] == "Pending") {
          print("i am in pending");
          Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (context) => const ApprovalScreen()),
          );

          /// if user already created account and request admin for approval,
          /// and admin accept it yet than he ll be redirected to create profile

        } else if (Route[0] == "Approved") {
          print("i am in approved ");
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => EditProfileWidget(
          //         accountTypeFromroutes: Route[1],
          //       ),
          //     ));
        } else {

          ///incase user just signed to system then navigate to Homepage
          ///where he can request for desired account type

          Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (context) => const HomePageWidget()),
          );
        }
      },
      child: Scaffold(),
    );
  }
}
