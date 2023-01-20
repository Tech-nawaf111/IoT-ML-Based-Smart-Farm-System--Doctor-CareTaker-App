import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fyp/address_prediction_handler/address_prediction.dart';
import 'package:fyp/app/profiles/model/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../../Home_doctor/main_screen.dart';
import '../../../../../dailog_messages.dart';
import '../../../../../display_message.dart';
import '../../../../../home/states/status_auth.dart';
import '../../../../../profile_validators/profile_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../theme.dart';
import '../../../../bloc/app_bloc.dart';
import '../../../../caretakerhome/CareTakerhome/careTaker.dart';
import '../../../Repository/CreateProfile.dart';


class EditProfileWidget extends StatefulWidget {

  EditProfileWidget({Key? key})
      : super(key: key);

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();

  static Page page() =>  MaterialPage<void>(child: EditProfileWidget());
}

///possible mobile Authetication states

enum mobileNumber {
  Verified,
  Unverifed,
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  /// controllers for textEditers


  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _firstnameController = new TextEditingController();
  final TextEditingController _lastnameController = new TextEditingController();
  final TextEditingController _identitycardController = new TextEditingController();
  final TextEditingController _PhoneNumberController = new TextEditingController();
  final TextEditingController _otpcontroller = new TextEditingController();

  /// initilization of desired variables

  final TextEditingController _dateValue = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Custom_validators Profile_validators = new Custom_validators();
  DateFormat displayDateFormat = DateFormat('MMM dd, yyyy');
  firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  File? imageFile;
  File? croppedFile;
  String verificationID = "";
  final cropKey = GlobalKey<CropState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Date  Picker to choose a  date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        _dateValue.text = "${displayDateFormat.format(picked)}";
      });
    }
  }

  /// initState  initilizing the initialDate
  @override
  void initState() {
    super.initState();
    _dateValue.text = "Nov 28,2022";
  }

  @override
  Widget build(BuildContext context) {
    /// creating firebase instance and initilizing the desired funtionalities
    /// that are reqired by createprofile instance for performing operations
    /// with firebase

    firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
    final user = _auth.currentUser!;
    final email = user.email;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user1 = context.select((AppBloc bloc) => bloc.state.user);
    final CollectionReference _mainCollection =
    _firestore.collection('Approval');
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('Approval').doc(user.email);
    StatusRepository? statusRepository = new StatusRepository(
        _firestore, _mainCollection, documentReference, user1);
    final CollectionReference _mainCollection1 =
        _firestore.collection('Profiles');
    DocumentReference documentReference1 =
        FirebaseFirestore.instance.collection('Profiles').doc(user.email);
    CreateProfile createProfile = new CreateProfile(
        _firestore, _mainCollection1, documentReference1, email);

    /// image cropper for cropping imageFile
    Future<Null> _cropImage() async {
      croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile!.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Android Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Iphone Cropper',
          ));

      var decodedImage =
          await decodeImageFromList(croppedFile!.readAsBytesSync());
      print(decodedImage.width);
      print(decodedImage.height);

      if (!mounted) return;
      setState(() {
        if (croppedFile != null) {
          imageFile = croppedFile;
        }
      });
    }

    ///Media selecter that is in use for selecting photo from camera or Galary

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
        _cropImage();
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
        _cropImage();
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
    }

    ///Main Scafforld of create profile page
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.primaryColorDark,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: Text(
          'Complete Your Profile',
          style: GoogleFonts.poppins(),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 80,
                      child: imageFile == null
                          ? Icon(
                              Icons.account_circle_rounded,
                              size: 160.0,
                              color: Color(0xFFFFFFFF),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              ),
                            ),
                      backgroundColor: theme.primaryColorDark,
                    ),
                    height: 200,
                  ),
                  Positioned(
                    child: GestureDetector(
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: theme.primaryColorLight,
                        ),
                        backgroundColor: theme.primaryColorDark,
                      ),
                      onTap: mediaTypeSelector,
                    ),
                    top: 152.0,
                    right: 0.0,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  obscureText: false,
                  controller: _firstnameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (Profile_validators.CustomTextValidator(text, "T") !=
                        null) {
                      return Profile_validators.CustomTextValidator(text, "T");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter Your First Name',
                    hintStyle: TextStyle(color: theme.primaryColorDark),
                    prefixIcon: Icon(
                      Icons.drive_file_rename_outline,
                      color: theme.primaryColorDark,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(
                      color: theme.primaryColorDark,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (Profile_validators.CustomTextValidator(text, "T") !=
                        null) {
                      return Profile_validators.CustomTextValidator(text, "T");
                    }
                    return null;
                  },
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.drive_file_rename_outline,
                        color: theme.primaryColorDark),
                    labelText: 'Last Name',
                    hintText: 'Enter Your Last Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(
                      color: theme.primaryColorDark,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _dateValue,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: 'Date of Birth',
                    labelText: 'Date of Birth',
                    prefixIcon:
                        Icon(Icons.calendar_today, color: theme.primaryColorDark),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(
                      color: theme.primaryColorDark,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                    ),
                    filled: true,
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value != null) {
                      return 'Please select dates';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _identitycardController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (Profile_validators.CustomTextValidator(text, "N") !=
                        null) {
                      return Profile_validators.CustomTextValidator(text, "N");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'ID card',
                    hintText: '34104-1234567-8',
                    prefixIcon: Icon(Icons.featured_video_rounded,
                        color: theme.primaryColorDark),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(
                      color: theme.primaryColorDark,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    // fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _PhoneNumberController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (Profile_validators.CustomTextValidator(text, "N") !=
                        null) {
                      return Profile_validators.CustomTextValidator(text, "N");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+923151234567',

                    prefixIcon: Icon(Icons.phone, color: theme.primaryColorDark),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: theme.primaryColorDark),
                      onPressed: () async {
                        await getOtp();
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return verifyCode();
                          },
                        );
                      },
                    ),
                    suffixText: "Verify",

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(
                      color: theme.primaryColorDark,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    // fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _addressController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (Profile_validators.CustomTextValidator(text, "T") !=
                        null) {
                      return Profile_validators.CustomTextValidator(text, "T");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Your Address',
                    prefixIcon:
                        Icon(Icons.map_outlined, color: theme.primaryColorDark),
                    suffixIcon: GestureDetector(
                      onTap: () => _handlePressButton(),
                      child: Icon(Icons.question_mark,color: theme.primaryColorDark),

                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(
                      color: theme.primaryColorDark,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColorDark,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    // fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(

              borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color(0xFF37acfd),
    ),
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      primary: const Color(0xFF37acfd),
                    ),

                    onPressed: () async {

                      if (mobileNumber.Unverifed == true) {
                        generateNumberError();
                      } else {
                        List<String> Route = await statusRepository.getApprovalStatus();
                        ProfileModel uploadProfile = new ProfileModel(
                            _firstnameController.text,
                            _lastnameController.text,
                            _dateValue.text,
                            _identitycardController.text,
                            _PhoneNumberController.text,
                            _addressController.text,
                            Route[1],
                            imageFile);
                        await createProfile.uploadProfile(uploadProfile);
if(Route[1] == "Doctor"){
  await statusRepository.setApprovalStatus(null,"ToDoctorHome");
  Navigator.push<void>(
    context,
    MaterialPageRoute(
        builder: (context) => MainScreen()),
  );
}
else{
  await statusRepository.setApprovalStatus(null,"ToCareTakerHome");
  Navigator.push<void>(
    context,
    MaterialPageRoute(
        builder: (context) => CaretakerHome()),
  );

}






                      }
                    },

                    child: const Text('Create Profile'),
                  )),
            ],
          ),
        ),
      ),
    );
  }





/// generate error if user number if not varrified

  generateNumberError() async {
    displayMessage displaymessage =
        new displayMessage(context, Dailog_Messages.NON_VERIFIED_NUMBER);
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return displaymessage!.message();
        });
  }


/// generate OTP

  Future<void> getOtp() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "${_PhoneNumberController.text}",
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (verificationFailed) {
          setState(() {});
          print(verificationFailed);
        },
        codeSent: (verificationID, resendingToken) async {
          setState(() {
            this.verificationID = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (verificationID) async {});

    // Navigator.of(context)
    //.push(MaterialPageRoute(builder: (context) => OtpScreen()));
  }

///Verify OTP

  AlertDialog verifyCode() {
    return AlertDialog(
      title: Text('Please Enter OTP'),
      actions: <Widget>[
        TextField(
          controller: _otpcontroller,
          decoration: InputDecoration(
            labelText: "Enter OTP",
            labelStyle: TextStyle(fontSize: 19),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 5),
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
          ),
        ),
        ElevatedButton(
         style: ElevatedButton.styleFrom(

            primary: const Color(0xFF37acfd),
          ),
          child: new Text("Submit"),
          onPressed: () {
            AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                verificationId: verificationID, smsCode: _otpcontroller.text);
            signin(phoneAuthCredential);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }

  void signin(AuthCredential phoneAuthCredential) async {
    try {
   if(phoneAuthCredential!=null)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('SUCCESSFULLY VERIFIED! ✅')));
        mobileNumber.Verified;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occured. Try Again Later')));
      mobileNumber.Unverifed;
    }
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: predictionAddress.kGoogleApiKey,
      onError: null,
      mode: Mode.overlay,
      language: "fr",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "fr")],
    );

  //  displayPrediction(p, homeScaffoldKey.currentState, context);
  }
}

///Display prediciton of address

// Future<Null> displayPrediction(Prediction? p, ScaffoldState? scaffold, BuildContext context) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: predictionAddress.kGoogleApiKey,
//       apiHeaders: await GoogleApiHeaders().getHeaders(),
//     );
//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
//     final lat = detail.result.geometry?.location.lat;
//     final lng = detail.result.geometry?.location.lng;
//
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${p.description} - $lat/$lng")),
//
//     );
//   }
// }
