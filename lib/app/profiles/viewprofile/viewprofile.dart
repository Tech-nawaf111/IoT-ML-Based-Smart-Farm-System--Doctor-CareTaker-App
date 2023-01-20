import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../loading_dailog/loading_dailog.dart';
import '../../../theme.dart';
import '../../view/app.dart';


class MYProfilePageWidget extends StatefulWidget {
  List<String> data;
  MYProfilePageWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _MYProfilePageWidgetState createState() => _MYProfilePageWidgetState();
}

class _MYProfilePageWidgetState extends State<MYProfilePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? Firstname = "";
  String? Lastname = "";
  String? DateofBirth = "";
  String? IDcardnumber = "";
  String? PhoneNumber = "";
  String? Address = "";
  String? Type = "";
  String? imageFileUrl = "";


/// initilizing all relevent fields with appropriate data

  @override
  void initState() {
    Firstname = widget.data[0];
    Lastname = widget.data[1];
    DateofBirth = widget.data[2];
    IDcardnumber = widget.data[3];
    PhoneNumber = widget.data[4];
    Address = widget.data[5];
    Type = widget.data[6];
    imageFileUrl = widget.data[7];
    //openLoadingDialog(context, 'Updating Feed Records...', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: theme.primaryColorLight,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,color: Colors.black
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: theme.primaryColorLight,
                    offset: Offset(0, 9),
                  )
                ],
                gradient: LinearGradient(
                  colors: [
                   theme.primaryColorDark,
                   theme.primaryColorLight,
                  ],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0.94, -1),
                  end: AlignmentDirectional(-0.94, 1),
                ),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                                width: 120,
                                height: 120,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(imageFileUrl!),
                              ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(Firstname! + " " + Lastname!, style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -1.5
                                ),),
                              ],
                            ),
                          ),

                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                child: Text(
                                  "Designation:  "+Type!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 0, 0),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(0x40000000),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      hoverColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.login_rounded,
                                        color: Color(0xFF000000),
                                      ),
                                      onPressed: () async {
                                        final FirebaseAuth _auth =
                                            FirebaseAuth.instance;
                                        final AuthenticationRepository
                                            authenticationRepository =
                                            new AuthenticationRepository();

                                        await _auth.signOut().then((value) =>
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) => App(
                                                        authenticationRepository:
                                                            authenticationRepository,status: "",)),
                                                (route) => false));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {},
                  child: Material(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.primaryColorLight,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                    //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: theme.primaryColorLight,
                        ),
SizedBox(width: 30),
                            Text(
                              "Date of Birth:           " + DateofBirth!,
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: theme.primaryColorLight,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 60),
                            IconButton(
                              hoverColor: Colors.transparent,
                              icon: Icon(
                                Icons.chevron_right_rounded,
                                color: theme.primaryColorLight,
                                size: 20,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {},
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.primaryColorLight,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: theme.primaryColorLight,
                              ),
                              SizedBox(width: 30),
                              Text(
                                "ID Card Number:     " + IDcardnumber!,
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: theme.primaryColorLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 30),
                              IconButton(
                                hoverColor: Colors.transparent,
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.primaryColorLight,
                                  size: 20,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {},
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.primaryColorLight,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.phone,
                                color: theme.primaryColorLight,
                              ),
                              SizedBox(width: 30),

                              Text(
                                "PhoneNumber:        " + PhoneNumber!,
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: theme.primaryColorLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 32),
                              IconButton(
                                hoverColor: Colors.transparent,
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.primaryColorLight,
                                  size: 20,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {},
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.primaryColorLight,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: theme.primaryColorLight,
                              ),
                              SizedBox(width:30),
                              Text(
                                "Address:                   " + Address!,
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: theme.primaryColorLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width:20),
                              IconButton(
                                hoverColor: Colors.transparent,
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.primaryColorLight,
                                  size: 20,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
