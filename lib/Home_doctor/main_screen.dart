
import 'package:flutter/material.dart';
import '../widgets/icon_badge.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,

  }) : super(key: key);
  static Page page() =>  MaterialPage<void>(child: MainScreen());
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController? _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
    final user = _auth.currentUser!;
    final email = user.email;
    return Scaffold(
      body: Home(Email: email),

    );
  }

  void navigationTapped(int page) {
    _pageController?.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  Widget barIcon(
      {IconData icon = Icons.home, int page = 0, bool badge = false}) {
    return IconButton(
      icon: badge ? IconBadge(icon: icon, size: 24.0, key: null, color: null,) : Icon(icon, size: 24.0),
      color:
          _page == page ? Theme.of(context).accentColor : Colors.blueGrey[300],
      onPressed: () => _pageController?.jumpToPage(page),
    );
  }
}
