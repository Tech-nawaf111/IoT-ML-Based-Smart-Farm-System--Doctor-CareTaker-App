import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:fyp/app/cow_treatment/cow_treatement_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Notifications/Remote/Remote_Notifications.dart';
import '../loading_dailog/loading_dailog.dart';
import '../theme.dart';
import '../util/places.dart';
import '../widgets/icon_badge.dart';
import 'Treatment_Repository.dart';

class Details extends StatefulWidget {
  final Map? place;
 final String? temperature;
  Details({this.place, this.temperature});
  @override
  _DetailsState createState() => _DetailsState();

}

class _DetailsState extends State<Details>{
  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  String? dateTime;

  DateTime selectedDate = DateTime.now();
String time = "";
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  int _dateCount = 0;
  String start_Date = '';
  String end_date = '';
  String medicine ="";
  String dose = "";
  List dropdownItemListofMedicine = [];
  List dropdownItemListofDose = [];
  List<String> medicines =
  [
    'Apomorphine',
    'Alprazolam',
    'Bethanechol ',
    'Moxifloxacin',
    'Nitroscanate',
    'Xylazine',
    'Prednisone','Theophylline','oxymorphone',
  ];
  List<String> dosevalues =
  [
    '5ml',
    '10ml',
    '15ml ',
    '20ml',
    '25ml',
    '30ml',
    '35ml',
    '40ml',

  ];

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        start_Date = DateFormat('dd/MM/yyyy').format(args.value.startDate);
            end_date = DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate);
        _dateCount = (DateTime(args.value.endDate.year,args.value.endDate.month,args.value.endDate.day).difference(DateTime(args.value.startDate.year,args.value.startDate.month,args.value.startDate.day)).inHours / 24).round();
      }
    });
  }



  @override
  void initState() {
    for (var i = 0; i < medicines.length; i++) {
      dropdownItemListofMedicine.add(
        {
          'label': medicines[i],
        },
      );
    }
    for (var i = 0; i < dosevalues.length; i++) {
      dropdownItemListofDose.add(
        {
          'label': dosevalues[i],
        },
      );
    }


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text('Cow\'s detail',style: TextStyle(color: Colors.black),),
        backgroundColor:theme.primaryColorLight,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                "${widget.place!["profilePhotoURL"]}",
                height: 250.0,
                width: MediaQuery.of(context).size.width - 40.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cow ID: ${widget.place!["CowID"]}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    "${widget.place!["Age"]}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),

                ],
              ),
              Row(
                children: <Widget>[

                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.place!["Breed"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.sanitizer_outlined,
                    size: 14,
                    color: Colors.blueGrey[300],
                  ),
                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.temperature}"+"°C",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[

                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.place!["Calfs"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[

                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.place!["Vaccinated"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),


              ElevatedButton(
                child: Text('Add Treatment'),
                style: ElevatedButton.styleFrom(
                  primary: theme.primaryColorLight,
                  onPrimary: Colors.black,
                  textStyle: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 30,
                      fontStyle: FontStyle.normal

                  ),
                ),
                onPressed: () {

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Add Treatment for Cow',style: TextStyle(fontSize: 20),),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                            child: Row(

                              children:[
                                CoolDropdown(

                                defaultValue: dropdownItemListofMedicine[0],
                                dropdownList: dropdownItemListofMedicine,
                                resultHeight: 74,
                                resultWidth: 190,
                                dropdownWidth: 190,
                                dropdownHeight: 200,
                                resultBD: BoxDecoration(
                                  border: Border.all(color: Color(0xFF292723), width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onChange: (value) {
                                  setState(() {
                                    medicine = value['label'];
                                  });
                                  print(medicine);
                                },
                              ),
                                SizedBox(width: 10),
                                CoolDropdown(

                                  defaultValue: dropdownItemListofDose[0],
                                  dropdownList: dropdownItemListofDose,
                                  resultHeight: 74,
                                  resultWidth: 190,
                                  dropdownWidth: 190,
                                  dropdownHeight: 200,
                                  resultBD: BoxDecoration(
                                    border: Border.all(color: Color(0xFF292723), width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onChange: (value) {
                                    setState(() {
                                      dose = value['label'];
                                    });
                                    print(dose);
                                  },
                                ),

                              ]
                            ),
                          ),
                          SizedBox(height:20),
                          Text("Select Number of days",style: TextStyle(fontSize: 20)),

                          SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.range,
                            initialSelectedRange: PickerDateRange(
                                DateTime.now().subtract(const Duration(days: 4)),
                                DateTime.now().add(const Duration(days: 3))),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: theme.primaryColorLight,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    showPicker(
                                      context: context,
                                      value: _time,
                                      onChange: onTimeChanged,
                                      minuteInterval: MinuteInterval.FIVE,
                                      // Optional onChange to receive value as DateTime
                                      onChangeDateTime: (DateTime dateTime) {

                                        setState(() {
                                          time = dateTime.hour.toString()+ " "+dateTime.minute.toString();
                                        });

                                        debugPrint(time);
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Select Time",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),

                            ],
                          ),

                          ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: theme.primaryColorLight,
                            ),
                            child: const Text('Confirm',style: TextStyle(color: Colors.black),),
                            onPressed: () async {

                              openLoadingDialog(
                                  context, 'Uploading Treatment....', true);
                              print(medicine);
                              print(start_Date);
                              print(end_date);
                              print(_dateCount);
                              print(time);

                              CowTreatmentModel cowTreatmentModel = new CowTreatmentModel(
                                  widget.place!["CowID"],
                                  medicine,
                              start_Date,
                                end_date,
                                _dateCount.toString(),
                                time,
                                dose,
                                "NotCompleted"
                              );
                              RemoteNotificationService
                              remoteNotificationService =
                              new RemoteNotificationService();
                              remoteNotificationService.SendNotification(
                                  "Cow Treatment prescribered",
                                  "Cow " +
                                      widget.place!["CowID"] +
                                      " prescribered treatment by Doctor Abdullah",
                                  context);
                              final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                              final CollectionReference _mainCollection1 = _firestore.collection('Treatment');
                              DocumentReference documentReference1 =
                              FirebaseFirestore.instance.collection('Treatment').doc();
                              Treatment treatment = new Treatment(
                                  _firestore, _mainCollection1, documentReference1, widget.place!["CowID"]);
                            await treatment.uploadTreatment(cowTreatmentModel);
                              openLoadingDialog(
                                  context, 'Uploading Treatment....', false);
                            },
                          ),


                        ],
                      ),
                    ),
                  );






                },
              ),
              SizedBox(height: 20),
    Row(
    children:[
    Icon(Icons.history_outlined),
    Text("Treatment History"),
    ]
    ),
        SizedBox(height:20),

        StreamBuilder<QuerySnapshot>(

            stream: FirebaseFirestore.instance
                .collection('Treatment')
                .where("CowID", isEqualTo: widget.place!["CowID"] )
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
                        final row = data[index].data() as Map<String, dynamic>;
                        final id = data[index].id;

                        return Card(
                          elevation: 8.0,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: row["State"]=="Completed"?theme.primaryColorLight:Colors.red,
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
                                child: Column(
                                  children: [
                                    Text(
                                    'Total Days',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                    Text(
                                      row['DaysCount'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]
                                ),
                              ),
                              title: Text(
                                "Medicine: \n"+row["Medicine"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                              subtitle: Column(children:
                              [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today,
                                        color: row["State"]=="Completed"?theme.primaryColorLight:Colors.red),
                                    Text("Start Date: "+row["StartDate"],
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today,
                                        color: row["State"]=="Completed"?theme.primaryColorLight:Colors.red),
                                    Text("End Date: "+row["LastDate"],
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                              ]),

                              // https://console.firebase.google.com/u/2/project/fyp-nawaf-mujeeb/database/fyp-nawaf-mujeeb-default-rtdb/data/~2F

                              trailing: row['State']!="NotCompleted"?Icon(Icons.check_circle,color: theme.primaryColorLight):
                              Icon(Icons.pie_chart,color: Colors.red)
                            ),
                          ),
                        );
                      },
                    ),
                  );
              }
            }),
              SizedBox(height: 10.0),
            ],
          ),
        ],
      ),

    );
  }

}







