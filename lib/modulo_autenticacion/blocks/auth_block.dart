import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_final/modulo_autenticacion/services/auth_service.dart';

class AuthBloc {
  final authService = AuthService();
  final fb = FacebookLogin();
  final googleSignin = GoogleSignIn(scopes: ['email']);
  final twitterLog = TwitterLogin(
    consumerKey: "2PVGe59jS7EWx6vczXcuaLcBL",
    consumerSecret: "Mii7wVPQ3qzJAg8akiPUvGbGWIdP553vJ6aNAZlGHkCzexEf9D",
  );
  String nick = "";
  String correo = "";
  String foto = "";
  var s1;
  String proveedor = "";
  String tokenPhoto = "";
  Stream<User> get currentUser => authService.currentUser;
  Future loginFacebook() async {
    print('Starting Facebook Login');
    proveedor = "fb";
    try {
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);

      final FacebookAccessToken fbToken = res.accessToken;
      tokenPhoto = fbToken.token;
      final AuthCredential credential =
          FacebookAuthProvider.credential(fbToken.token);

      final result = await authService.signInWithCredential(credential);
      nick = result.user.displayName;
      correo = result.user.email;
      foto = result.user.photoURL;
      print('${result.user.displayName} se ha logueado correctamente');
    } catch (error) {
      print(error);
    }

    // switch(res.status){
    //   case FacebookLoginStatus.success:
    //   print("Inicio de sesion exitoso");

    //   print('${result.user.displayName} is now logged in');
    //   print('${result.user.photoURL} ');
    //   print('${fbToken.token}');
    //   break;
    //   case FacebookLoginStatus.cancel:
    //   print("El usuario cancelo el inicio de sesión");
    //   break;
    //   case FacebookLoginStatus.error:
    //   print("Hubo un error");
    //   break;
    // }
  }

  Future loginGoogle() async {
    proveedor = "G";
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Firebase Sign in
      final result = await authService.signInWithCredential(credential);

      nick = result.user.displayName;
      correo = result.user.email;
      foto = result.user.photoURL;
      print('${result.user.displayName}');
    } catch (error) {
      print(error);
    }
  }

  Future loginTwitter() async {
    proveedor = "Tw";
    try {
      final TwitterLoginResult res = await twitterLog.authorize();
      var session = res.session;
      final AuthCredential credential = TwitterAuthProvider.credential(
          accessToken: session.token, secret: session.secret);
      final result = await authService.signInWithCredential(credential);
      nick = result.user.displayName;
      correo = result.user.email;
      foto = result.user.photoURL;
      print('${result.user.displayName}');
    } catch (error) {
      print(error);
    }

    // switch(res.status){
    //   case TwitterLoginStatus.loggedIn:

    //   break;
    //   case TwitterLoginStatus.cancelledByUser:
    //   print("El usuario cancelo el inicio de sesión");
    //   break;
    //   case TwitterLoginStatus.error:
    //   print("Hubo un error");
    //   break;
    // }
  }

  logout() {
    authService.logout();
  }
}
