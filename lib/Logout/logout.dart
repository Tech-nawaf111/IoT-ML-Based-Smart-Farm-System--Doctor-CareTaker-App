
import 'package:firebase_auth/firebase_auth.dart';

class LogOut{
  FirebaseAuth auth = FirebaseAuth.instance;

 Future<void> signOut() async {
    await auth.signOut();
    print("done");
  }
}