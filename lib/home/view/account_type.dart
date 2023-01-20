import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/approval/view/approval_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp/dailog_messages.dart';
import '../../app/bloc/app_bloc.dart';
import '../../display_message.dart';
import '../states/status_auth.dart';
import 'package:flutter/services.dart';



class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePageWidget());

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isTrueForDoctor = false;
  bool isTrueForCareTaker = false;
  displayMessage? displaymessage;

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _mainCollection =
        _firestore.collection('Approval');
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Approval').doc(user.email);
    StatusRepository? statusRepository = new StatusRepository(
        _firestore, _mainCollection, documentReference, user);

    // ignore: unnecessary_null_comparison

    String? Status = null;
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
    child: Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Align(
            alignment: AlignmentDirectional(1, 0),
            child: SingleChildScrollView(
            child:
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 60, 0),
                  child: Text(
                    'Please Select \na User Type',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: InkWell(
                    onTap: () {
                      isStateDoctor();
                      if (kDebugMode) {
                        print('Hello clicked');
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 250.0,
                          color: Colors.white,
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x32000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                child: Align(
                                  alignment: AlignmentDirectional(0, 1),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 2),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 40, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(0),
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(0),
                                              ),
                                              child: Image.asset(
                                                'assets/images/doctor.png',
                                                width: 200,
                                                height: 170,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Doctor',
                                                  style: TextStyle(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 205,
                          left: 175,
                          child: Visibility(
                            visible: isTrueForDoctor,
                            child: const CircleAvatar(
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      isStateCareTaker();
                      print("Hello clicked");
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 250.0,
                          color: Colors.white,
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x32000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                child: Align(
                                  alignment: AlignmentDirectional(0, 1),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 2),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 0, 0, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(0),
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(0),
                                              ),
                                              child: Image.asset(
                                                'assets/images/caretaker.png',
                                                width: 200,
                                                height: 170,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'CareTaker',
                                                  style: TextStyle(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 205,
                          left: 175,
                          child: Visibility(
                            visible: isTrueForCareTaker,
                            child: const CircleAvatar(
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(

                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFF37acfd) ,
                ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isTrueForDoctor == false &&
                            isTrueForCareTaker == false) {
                          nonAccount();
                        } else {
                          List<String> data = await statusRepository.getApprovalStatus();

                          if (data[0] == "Pending") {
                            toApprovalScreen();
                          } else if (data[0] == "null") {
                            String accountType ="";
                            if(isTrueForCareTaker){
                              accountType = "CareTaker";
                            }else{
                              accountType = "Doctor";
                            }
                        await  statusRepository.setApprovalStatus(accountType,"Pending");
                            toApprovalScreen();
                          }
                        }
                      },
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF37acfd),
                      ),
                    )),
              ],
            ),),
          ),
        ),
      ),
    ),
    );
  }

  void isStateDoctor() {
    setState(() {
      if (isTrueForDoctor == false) {
        isTrueForDoctor = true;
        isTrueForCareTaker = false;
      } else {
        isTrueForDoctor = false;
      }
    });
  }

  void isStateCareTaker() {
    setState(() {
      if (isTrueForCareTaker == false) {
        isTrueForCareTaker = true;
        isTrueForDoctor = false;
      } else {
        isTrueForCareTaker = false;
      }
    });
  }

  Future<void> nonAccount() async {
    displaymessage =
        new displayMessage(context, Dailog_Messages.NON_ACCOUNT_ERROR);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return displaymessage!.message();
      },
    );
  }

  void toApprovalScreen() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const ApprovalScreen()),
    );
  }
  //
  // void toMakeProfileScreen() {
  //   Navigator.push<void>(
  //     context,
  //     MaterialPageRoute(builder: (context) => const EditProfileWidget()),
  //   );
  // }
}
