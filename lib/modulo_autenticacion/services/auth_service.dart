import 'package:firebase_auth/firebase_auth.dart';
//AUTH ACTUAL
// class AuthService{
//   final _auth= FirebaseAuth.instance; 

//   Stream<User> get currentUser => _auth.authStateChanges();
//   }

//AUTH VERSION 0.20
class AuthService{
  final _auth= FirebaseAuth.instance; 

  Stream<User> get currentUser => _auth.authStateChanges();
  Future<UserCredential> signInWithCredential(AuthCredential credential) => _auth.signInWithCredential(credential);
  Future<void> logout() => _auth.signOut();
  }
  
