import 'dart:async';

import 'package:bloc/bloc.dart';


part 'spalsh_screen_event.dart';
part 'spalsh_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc(SplashScreenState? initialState) : super(Initial()){
    on<SplashScreenEvent>((event, emit) => getMonks(event));


  }

  SplashScreenState get initialState => Initial();

  void getMonks(SplashScreenEvent event) async {
    if (event is NavigateToHomeScreenEvent) {
      emit(Loading());

      await Future.delayed(Duration(seconds: 4)); // This is to simulate that above checking process
      emit(Loaded()); // In this state we can load the HOME PAGE
    }
  }


}
