import 'dart:io';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fyp/Notifications/Remote/Remote_Notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scan/scan.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../../loading_dailog/loading_dailog.dart';
import '../../../theme.dart';
import '../../profiles/Repository/CreateProfile.dart';
import '../../profiles/viewprofile/viewprofile.dart';
import '../../view/app.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'caretaker_repository.dart';

class CaretakerHome extends StatefulWidget {
  const CaretakerHome({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: CaretakerHome());

  @override
  // ignore: library_private_types_in_public_api
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<CaretakerHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int pageIndex = 0;
  File? imageFile;
  String _verticalGroupValue = "Normal";
  final pages = [
    const treatmentpage(),
    feedpage(),
  ];

  mediaTypeSelector() async {
    _getFromGallery() async {
      print('reached here');
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        setState(() {
          print('reached here 2');
          imageFile = File(pickedFile.path);
        });
      }
      // Navigator.of(context).pop();
    }

    /// Get from Camera
    // ignore: always_declare_return_types
    _getFromCamera() async {
      // ignore: deprecated_member_use
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
      // Navigator.of(context).pop();
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose image source'),
          content: Text(""),
          actions: <Widget>[
            ElevatedButton(
              child: new Column(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(height: 8),
                  Text("Camera"),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: theme.primaryColorLight,
              ),
              onPressed: () => _getFromCamera(),
            ),
            ElevatedButton(
              child: new Column(
                children: [
                  Icon(Icons.browse_gallery_outlined),
                  SizedBox(height: 8),
                  Text("Galary"),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: theme.primaryColorLight),
              onPressed: () => _getFromGallery(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/caretaker.png'))),
                child: Stack(children: <Widget>[])),
            SizedBox(height: 20),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.person),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Profile"),
                  )
                ],
              ),
              onTap: () async {
                firebase_auth.FirebaseAuth _auth =
                    firebase_auth.FirebaseAuth.instance;
                final user = _auth.currentUser!;
                final email = user.email;
                List<String> Data;
                final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                print(email);
                final CollectionReference _mainCollection =
                    _firestore.collection('Profiles');
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('Profiles')
                    .doc(email);
                CreateProfile createProfile = new CreateProfile(
                    _firestore, _mainCollection, documentReference, email);
                Data = await createProfile.RetreiveProfile();
                print("the length is");
                print(Data.length);
                print(Data);

                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MYProfilePageWidget(data: Data)),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.medical_services),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Report for CheckUp"),
                  )
                ],
              ),
              onTap: () async {
                ReportCow(BuildContext context, String result) async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Report to Doctor',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          actions: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Cows')
                                    .where("CowID", isEqualTo: result)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print(snapshot.data);
                                  print(snapshot.connectionState);
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator());
                                    case ConnectionState.active:
                                    //    return Center(child: CircularProgressIndicator());
                                    case ConnectionState.done:
                                      if (snapshot.hasError) {
                                        return Container(
                                          height: 50,
                                          width: 50,
                                          child: Text(
                                            'No data found',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        );
                                      }
                                      if (snapshot.hasData == false) {
                                        return Container(
                                          height: 50,
                                          width: 50,
                                          child: Text(
                                            'No data found',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        );
                                      }
                                      final data = snapshot.data!.docs;
                                      print(snapshot.data!.size);
                                      return snapshot.data!.size > 0
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: 5.0,
                                                  left: 20.0,
                                                  right: 20.0),
                                              height: 250.0,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                children: [
                                                  Text("Cow ID is:",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Text(data[0]["CowID"],
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 26)),
                                                  Text("Schedule CheckUp Type",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  CustomCheckBoxGroup(
                                                    buttonTextStyle:
                                                        ButtonTextStyle(
                                                      selectedColor:
                                                          Colors.black,
                                                      unSelectedColor:
                                                          Colors.black,
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    autoWidth: false,
                                                    enableButtonWrap: true,
                                                    wrapAlignment:
                                                        WrapAlignment.center,
                                                    unSelectedColor:
                                                        Theme.of(context)
                                                            .canvasColor,
                                                    buttonLables: [
                                                      "Regular",
                                                      "Urgent",
                                                      "Later"
                                                    ],
                                                    buttonValuesList: [
                                                      "Regular",
                                                      "Urgent",
                                                      "Later"
                                                    ],
                                                    checkBoxButtonValues:
                                                        (values) {
                                                      setState(() {
                                                        _verticalGroupValue =
                                                            values.first
                                                                .toString();
                                                      });
                                                      print(
                                                          _verticalGroupValue);
                                                    },

                                                    horizontal: false,
                                                    width: 120,
                                                    // hight: 50,
                                                    selectedColor:
                                                        theme.primaryColorLight,
                                                    padding: 5,
                                                    enableShape: true,
                                                  ),
                                                ],
                                              ))
                                          : Container(
                                              padding: EdgeInsets.only(
                                                  top: 5.0,
                                                  left: 20.0,
                                                  right: 20.0),
                                              height: 250.0,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.asset(
                                                  'assets/images/no_cow.png'),
                                            );
                                  }
                                }),
                            Container(
                              child: ElevatedButton(
                                child: new Text(
                                  "Schedule",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () async {
                                  openLoadingDialog(
                                      context, 'Scheduling CheckUp...', true);
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('Checkup')
                                          .doc(result);
                                  CareTakerRepo? careTakerRepo =
                                      new CareTakerRepo(
                                    documentReference,
                                  );
                                  await careTakerRepo.uploadCheckUpRequest(
                                      result, _verticalGroupValue);
                                  openLoadingDialog(
                                      context, 'Scheduling CheckUp...', false);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColorLight,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }

                _getFromGallery() async {
                  print('reached here');
                  final pickedFile = await ImagePicker().getImage(
                    source: ImageSource.gallery,
                    maxWidth: 300,
                    maxHeight: 300,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      print('reached here 2');
                      imageFile = File(pickedFile.path);
                    });
                  }
                  String? result = await Scan.parse(imageFile?.path);
                  print("the result is as follow" + result!);

                  ReportCow(context, result);
                }

                /// Get from Camera
                // ignore: always_declare_return_types
                _getFromCamera() async {
                  // ignore: deprecated_member_use
                  final pickedFile = await ImagePicker().getImage(
                    source: ImageSource.camera,
                    maxWidth: 300,
                    maxHeight: 300,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      imageFile = File(pickedFile.path);
                    });
                  }
                  String? result = await Scan.parse(imageFile?.path);
                  print("the result is as follow" + result!);

                  ReportCow(context, result);
                }

                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Choose image source'),
                      content: Text(""),
                      actions: <Widget>[
                        ElevatedButton(
                          child: new Column(
                            children: [
                              Icon(Icons.camera_alt_outlined),
                              SizedBox(height: 8),
                              Text("Camera"),
                            ],
                          ),
                          onPressed: () => _getFromCamera(),
                        ),
                        ElevatedButton(
                          child: new Column(
                            children: [
                              Icon(Icons.browse_gallery_outlined),
                              SizedBox(height: 8),
                              Text("Galary"),
                            ],
                          ),
                          onPressed: () => _getFromGallery(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: theme.primaryColorLight,
        title: Text("CareTaker", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final AuthenticationRepository authenticationRepository =
                  new AuthenticationRepository();
              await _auth
                  .signOut()
                  .then((value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => App(
                                authenticationRepository:
                                    authenticationRepository,
                                status: "",
                              )),
                      (route) => false));
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          color: theme.primaryColorLight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.medical_services, color: Colors.white),
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.food_bank_outlined, color: Colors.white),
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: pages[pageIndex],
    );
  }
}

class treatmentpage extends StatelessWidget {
  const treatmentpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Treatment')
            .where('State', isEqualTo: "NotCompleted")
            .snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data);
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            //    return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('No data found');
              }
              if (snapshot.data == null) {
                return Text('No data found');
              }
              final data = snapshot.data!.docs;
              DateTime date = new DateTime.now();
              var formatter = new DateFormat('dd/MM/yyyy');
              String formattedDate = formatter.format(date);

              List<QueryDocumentSnapshot<Object?>> filtereddata = [];

              for (int i = 0; i < data.length; i++) {
                final row = data[i].data() as Map<String, dynamic>;
                if (formattedDate == row["CurrentDate"]) {
                  if (row["CurrentDate"] != row["LastDate"]) {
                    filtereddata.add(data[i]);
                    print(data[i].data() as Map<String, dynamic>);
                  }
                }
              }

              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filtereddata.length,
                  itemBuilder: (BuildContext context, int index) {
                    final row =
                        filtereddata[index].data() as Map<String, dynamic>;
                    final id = filtereddata[index].id;
                    return Card(
                      elevation: 8.0,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: theme.primaryColorLight,
                        ),
                        borderRadius:
                            BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black))),
                            child: Text(
                              'Cow ID \n ' + row["CowID"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            row["Medicine"] + "Dose " "-" + row["dose"],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                          subtitle: Column(children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.calendar_today,
                                    color: theme.primaryColorLight),
                                Text("Date: " + row["StartDate"],
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.timer,
                                    color: theme.primaryColorLight),
                                Text("Time: " + row["time"],
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                          ]),

                          // https://console.firebase.google.com/u/2/project/fyp-nawaf-mujeeb/database/fyp-nawaf-mujeeb-default-rtdb/data/~2F

                          trailing: IconButton(
                              icon: Icon(Icons.check,
                                  color: theme.primaryColorLight, size: 30.0),
                              onPressed: () {
                                DateTime nextday = new DateTime.now()
                                    .add(const Duration(days: 1));
                                var formatter = new DateFormat('dd/MM/yyyy');
                                String nextdate = formatter.format(nextday);
                                RemoteNotificationService
                                    remoteNotificationService =
                                    new RemoteNotificationService();
                                remoteNotificationService.SendNotification(
                                    "Cow Treatment Completed",
                                    "Cow " +
                                        row["CowID"] +
                                        " prescribered treatment is completed",
                                    context);
                                if (nextdate == row["LastDate"]) {
                                  FirebaseFirestore.instance
                                      .collection('Treatment')
                                      .doc(id)
                                      .update({'State': 'Completed'});
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Treatment')
                                      .doc(id)
                                      .update({'CurrentDate': nextdate});
                                }
                              }),
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        });
  }
}

class feedpage extends StatelessWidget {
  feedpage({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CurrentCow').snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data);
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            //    return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('No data found');
              }
              if (snapshot.data == null) {
                return Text('No data found');
              }
              final data = snapshot.data!.docs;
              int CurrentCow = data[0]["CurrentCow"];
              String CurrentFeedDate = data[1]["CurrentFeedDate"];

              DateTime date = new DateTime.now();
              var formatter = new DateFormat('dd/MM/yyyy');
              String todaydate = formatter.format(date);

              return StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('feed').snapshots(),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    print(snapshot.connectionState);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      //    return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('No data found');
                        }
                        if (snapshot.data == null) {
                          return Text('No data found');
                        }

                        final datax = snapshot.data!.docs;

                        DateTime date = new DateTime.now();
                        String day = DateFormat('EEEE').format(DateTime.now());
                        var formatter = new DateFormat('dd/MM/yyyy');
                        String formattedDate = formatter.format(date);
                        print(formattedDate);

                        int feed1 = int.parse(datax[0]["perday"]);
                        int feed2 = int.parse(datax[1]["perday"]);
                        int feed3 = int.parse(datax[2]["perday"]);
                        int feed4 = int.parse(datax[3]["perday"]);
                        int totalinkgs = feed1 + feed2 + feed3 + feed4;
                        DateTime nextday =
                            new DateTime.now().add(const Duration(days: 1));
                        var formatterx = new DateFormat('dd/MM/yyyy');
                        String nextdate = formatterx.format(nextday);

                        if (CurrentFeedDate == todaydate) {
                          FirebaseFirestore.instance
                              .collection('feed')
                              .doc("Maize")
                              .update({
                            'available': (int.parse(datax[0]["available"]) -
                                    (feed1 * CurrentCow))
                                .toString()
                          });
                          FirebaseFirestore.instance
                              .collection('feed')
                              .doc("Plant Protein")
                              .update({
                            'available': (int.parse(datax[1]["available"]) -
                                    (feed2 * CurrentCow))
                                .toString()
                          });
                          FirebaseFirestore.instance
                              .collection('feed')
                              .doc("Roughages")
                              .update({
                            'available': (int.parse(datax[2]["available"]) -
                                    (feed3 * CurrentCow))
                                .toString()
                          });
                          FirebaseFirestore.instance
                              .collection('feed')
                              .doc("Wheat middlings")
                              .update({
                            'available': (int.parse(datax[3]["available"]) -
                                    (feed4 * CurrentCow))
                                .toString()
                          });
                          FirebaseFirestore.instance
                              .collection('CurrentCow')
                              .doc("CurrentFeedDate")
                              .update({'CurrentFeedDate': nextdate});
                        }

                        return SafeArea(
                          child: GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: theme.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 30, 0, 0),
                                        child: SelectionArea(
                                            child: GradientText(
                                          'Today Cow\'s\nFeed Details',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 50,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          colors: [
                                            Color(0xff159DFF),
                                            Color(0xff002981),
                                          ],
                                          gradientDirection:
                                              GradientDirection.ltr,
                                          gradientType: GradientType.linear,
                                        )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: theme.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 20, 0, 0),
                                        child: SelectionArea(
                                            child: Text(
                                          'Date Today: ' + formattedDate,
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 10,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                    ),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: theme.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 20, 0, 0),
                                        child: SelectionArea(
                                            child: Text(
                                          'Day Today: ' + day,
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      // decoration: BoxDecoration(
                                      //   color: Color(0xFFF5F5F5),
                                      // ),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: theme.primaryColorDark,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.primaryColorLight,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    SelectionArea(
                                                        child: Text(
                                                      ' Total Registered Cows  ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Container(
                                                      width: 140,
                                                      height: 70,
                                                      child: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color: theme
                                                            .primaryColorDark,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Text(
                                                            "    " +
                                                                CurrentCow
                                                                    .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        50)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.primaryColorLight,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    SelectionArea(
                                                        child: Text(
                                                      ' Feeds to each Cow (KG)',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                    SizedBox(
                                                      width: 13,
                                                    ),
                                                    Container(
                                                      width: 140,
                                                      height: 70,
                                                      child: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color: theme
                                                            .primaryColorDark,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              totalinkgs
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          50)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  "Feed Details in KG's (Per Cow)",
                                                  style: GoogleFonts.poppins()),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.primaryColorLight,
                                                ),
                                                child: Row(children: [
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            datax[0]["Name"],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            datax[1]["Name"],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            datax[2]["Name"],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            datax[3]["Name"],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16)),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.primaryColorLight,
                                                ),
                                                child: Row(children: [
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            feed1.toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            feed2.toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            feed3.toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            feed4.toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Text(
                                                  "Feed Details in KG's (Per Cow)"),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.primaryColorLight,
                                                ),
                                                child: Row(children: [
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            (feed1 * CurrentCow)
                                                                .toString()
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            (feed2 * CurrentCow)
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            (feed3 * CurrentCow)
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 50,
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: theme
                                                          .primaryColorDark,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            (feed4 * CurrentCow)
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 34)),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
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
                          ),
                        );
                    }
                  });
          }
        });
  }
}
