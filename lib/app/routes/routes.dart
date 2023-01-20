import 'package:flutter/widgets.dart';
import 'package:fyp/app/app.dart';
import 'package:fyp/app/caretakerhome/CareTakerhome/careTaker.dart';
import 'package:fyp/login/login.dart';
import '../../Home_doctor/main_screen.dart';
import '../../app/bloc/app_bloc.dart';
import '../../approval/view/approval_screen.dart';
import '../../home/view/account_type.dart';
import '../profiles/caretaker_profile/create_profile/view/User_profile.dart';

/// authorized route for user already signedIn or loggedIn
/// unAuthorized for user not logged or signed in

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages){

  switch (state) {
    case AppStatus.unauthenticated:
      print('here1');
      return [LoginPage.page()];
    case AppStatus.authenticated:
      print('here2');
      return [HomePageWidget.page()];
    case AppStatus.Pending:
      print('here3');
      return [ApprovalScreen.page()];
    case AppStatus.Approved:
      print('here4');
      return [EditProfileWidget.page()];
    case AppStatus.ToDoctorHome:
      return [MainScreen.page()];
    case AppStatus.ToCareTakerHome:
      return [CaretakerHome.page()];
      print('here5');


  }


}

