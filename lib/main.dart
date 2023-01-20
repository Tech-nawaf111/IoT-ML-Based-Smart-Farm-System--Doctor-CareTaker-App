import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/app/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../home/states/status_auth.dart';

/// initializeApp and connect it to firebase
/// using bloc pattern here for authentication of users
/// authentication repository is in use inorder to check status of user

Future<void> main() {
  return BlocOverrides.runZoned(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final authenticationRepository = AuthenticationRepository();
      firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
      final user = _auth.currentUser;
      List<String> Route = [""];
      if(user!=null || AppState.unauthenticated() != true) {
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        final CollectionReference _mainCollection = _firestore.collection(
            'Approval');
        DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Approval').doc(user?.email);
        StatusRepository? statusRepository = new StatusRepository(

            _firestore, _mainCollection, documentReference, null);
        Route = await statusRepository.getApprovalStatus();
      }
      await authenticationRepository.user.first;

      runApp(App(authenticationRepository: authenticationRepository,status: Route[0],));
    },
    blocObserver: AppBlocObserver(),
  );
}



