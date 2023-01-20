import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:very_good_analysis/very_good_analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/approval/view/approval_screen.dart';
import '../../app/profiles/caretaker_profile/create_profile/view/User_profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../home/states/status_auth.dart';
import '../../home/view/account_type.dart';
part 'app_event.dart';
part 'app_state.dart';


/// AppBloc is basically act as an intermediate between app events
/// app state. when an event is observed, it change the appstate accordingly

class AppBloc extends Bloc<AppEvent, AppState> {


  AppBloc({required AuthenticationRepository authenticationRepository, required String? status})
      : _authenticationRepository = authenticationRepository, _status = status,
        super(

        status == "Pending" ?AppState.Pending(authenticationRepository.currentUser):
        status == "Approved" ?AppState.Approved(authenticationRepository.currentUser):
        status == "ToDoctorHome" ?AppState.ToDoctorHome(authenticationRepository.currentUser):
        status == "ToCareTakerHome" ?AppState.ToCareTakerHome(authenticationRepository.currentUser):
        authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),

        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final String? _status;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async{
    firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
    final user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _mainCollection = _firestore.collection('Approval');
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('Approval').doc(user?.email);
    StatusRepository? statusRepository = new StatusRepository(

        _firestore, _mainCollection, documentReference, null);
    List<String> Route = await statusRepository.getApprovalStatus();
    String statusx= Route[0];
    emit(
      statusx == "Pending" ?AppState.Pending(_authenticationRepository.currentUser):
      statusx == "Approved" ?AppState.Approved(_authenticationRepository.currentUser):
      statusx == "ToDoctorHome" ?AppState.ToDoctorHome(_authenticationRepository.currentUser):
      statusx == "ToCareTakerHome" ?AppState.ToCareTakerHome(_authenticationRepository.currentUser):
    _authenticationRepository.currentUser.isNotEmpty
    ? AppState.authenticated(_authenticationRepository.currentUser)
        : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
