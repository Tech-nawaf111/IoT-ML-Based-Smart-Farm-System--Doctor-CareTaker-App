import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp/app/app.dart';
import 'package:fyp/splash_screen_bloc/spalsh_screen_bloc.dart';
import 'package:fyp/theme.dart';

import '../../Splash_Screen.dart';

/// Main App that requires authentication repository

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required String? status,
  })  : _authenticationRepository = authenticationRepository,
  _status = status,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  final String? _status;

  @override
  Widget build(BuildContext context) {

    return RepositoryProvider.value(
      value: _authenticationRepository,
      child:MultiBlocProvider(providers:
      [

    BlocProvider<SplashScreenBloc>(
    create: (counterCubitContext) => SplashScreenBloc(null),
    lazy: false,
    ),
    BlocProvider(
    create: (_) => AppBloc(
    authenticationRepository: _authenticationRepository,status: _status
    ),
    )
    ],


        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const SplashScreen(),
    );
  }
}

/// Home Page generate pages based on current user status
/// this work is done by onGeneratePages that decide
/// that which page should be generated bepending upon user routes
/// while route is depend upon user status

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//       const Duration(seconds: 3),
//       () => Navigator.pushReplacement<void, void>(
//         context,
//         MaterialPageRoute(
//           builder: (context) => FlowBuilder<AppStatus>(
//             state: context.select((AppBloc bloc) => bloc.state.status),
//             onGeneratePages: onGenerateAppViewPages,
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Image.asset('assets/images/bloc_logo_small.png'),
//     );
//   }
// }
