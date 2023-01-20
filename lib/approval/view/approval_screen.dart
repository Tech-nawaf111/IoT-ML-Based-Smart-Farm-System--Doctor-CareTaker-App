import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/bloc/app_bloc.dart';
import '../../app/view/app.dart';
import '../../home/states/status_auth.dart';


///Approval screen that display when ever request to admin for a specific account type.


class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: ApprovalScreen());
  @override
  // ignore: library_private_types_in_public_api
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<ApprovalScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    // ignore: use_named_constants
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 140, 0, 0),
                      child: Image.asset(
                        'assets/images/approvalpending.png',
                        width: 150,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                      child: Text(
                        'Admin is evaluating your profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(2, 40, 2, 0),
                child: Text(
                  'In order to make sure  that only authorized user have access to our system.An approval from admin is required',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFF37acfd),
                  ),
                  height: 50,
                  width: 400,

                  margin: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      print('done');
                     await logout();
                    },
                    style: ElevatedButton.styleFrom(

                      primary: const Color(0xFF37acfd),
                    ),
                    child: const Text('LogOut'),

                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future logout() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final AuthenticationRepository authenticationRepository= new AuthenticationRepository();

    await _auth.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => App(authenticationRepository: authenticationRepository,status:"",)),(route) => false));


  }
}
