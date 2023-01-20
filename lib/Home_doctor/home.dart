import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Notifications/Remote/Remote_Notifications.dart';
import '../app/profiles/Repository/CreateProfile.dart';
import '../app/profiles/viewprofile/viewprofile.dart';
import '../theme.dart';
import '../widgets/search_bar.dart';
import 'details.dart';

class Home extends StatefulWidget {
  String? Email;

  Home({
    Key? key,
    required this.Email,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  String tempdata = "";


  @override
  void initState() {

    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('temperature_value');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        tempdata = event.snapshot.value.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor\'s Home',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: theme.primaryColorLight,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SearchBar(),
          ),
          buildHorizontalList(context,tempdata),
          Card(
            elevation: 8.0,
            shadowColor: Colors.black,
            color: theme.primaryColorLight,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.primaryColorLight,
              ),
              borderRadius: BorderRadius.circular(8.0), //<-- SEE HERE
            ),
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
                height: 40,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(Icons.error_rounded),
                      Text(
                        "Cows Need to be Checked",
                        style: GoogleFonts.poppins(fontSize: 20),
                      )
                    ]))),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Checkup')
                  .where('State', isEqualTo: "NotChecked")
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
                    return Container(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final row =
                              data[index].data() as Map<String, dynamic>;
                          final id = data[index].id;
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
                                              width: 1.0,
                                              color: Colors.black))),
                                  child: Text(
                                    'Cow ID \n ' + id,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  row["EmergencyType"],
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
                                      Text("Date: " + row["DateForCheckUp"],
                                          style: TextStyle(color: Colors.black))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.camera_roll_sharp,
                                          color: theme.primaryColorLight),
                                      Text("Temp-°C: " + tempdata,
                                          style: TextStyle(color: Colors.black))
                                    ],
                                  ),
                                ]),

                                // https://console.firebase.google.com/u/2/project/fyp-nawaf-mujeeb/database/fyp-nawaf-mujeeb-default-rtdb/data/~2F

                                trailing: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                  child: ElevatedButton(
                                    child: new Text("Checked", style: TextStyle(color: Colors.black),),
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection('Checkup').doc(id).update({'State': 'Checked'});
                                      RemoteNotificationService
                                      remoteNotificationService =
                                      new RemoteNotificationService();
                                      remoteNotificationService.SendNotification(
                                          "Cow Checkup Completed",
                                          "Cow " +
                                              row["CowID"] +
                                              "Checkup has been done by Doctor Abdullah",
                                          context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColorLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                }
              }),
        ],
      ),
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
                        image: AssetImage('assets/images/bgfordoctor.png'))),
                child: Stack(children: <Widget>[])),
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
                List<String> Data;
                final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                print(widget.Email);
                final CollectionReference _mainCollection =
                    _firestore.collection('Profiles');
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('Profiles')
                    .doc(widget.Email);
                CreateProfile createProfile = new CreateProfile(
                    _firestore, _mainCollection, documentReference, widget.Email);
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
          ],
        ),
      ),
    );
  }

  buildHorizontalList(BuildContext context,String tempdata) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Cows').snapshots(),
        builder: (context, snapshot) {
          print('NNNN');
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
              return Container(
                padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                height: 250.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final row = data[index].data() as Map<String, dynamic>;
                    //   Map place = places.reversed.toList()[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: InkWell(
                        child: Container(
                          height: 250.0,
                          width: 140.0,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  row["profilePhotoURL"] ?? '',
                                  height: 178.0,
                                  width: 140.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 7.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  row["Breed"] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  row["CowID"] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: Colors.blueGrey[300],
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return Details(place: row, temperature: tempdata);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
              break;
          }
        });
  }


  }



