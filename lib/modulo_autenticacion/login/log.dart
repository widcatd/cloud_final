import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_final/modulo_autenticacion/blocks/auth_block.dart';
import 'package:cloud_final/modulo_autenticacion/login/home.dart';
import 'package:cloud_final/modulo_autenticacion/login/homeEmail.dart';
import 'package:cloud_final/modulo_autenticacion/login/homeGoogle.dart';
import 'package:cloud_final/modulo_autenticacion/login/homeTwitter.dart';
import 'package:cloud_final/modulo_autenticacion/services/auth_service.dart';
import 'package:provider/provider.dart';
// import 'package:project/blocks/auth_block_google.dart';

enum AuthServiceType { google, facebook }

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  StreamSubscription<User> loginStateSubscription;
  String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    print(authBloc.proveedor);
    // switch(authBloc.proveedor){
    //   case "fb":
    //   loginStateSubscription=authBloc.currentUser.listen((fbUser){
    //     if (fbUser!=null){
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context)=>Home())
    //     );
    //   }
    //   });
    //   break;
    //   case "G":
    //   loginStateSubscription=authBloc.currentUser.listen((fbUser){
    //   if (fbUser!=null){
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context)=>HomeScreen1())
    //     );
    //   }
    //   });
    //   break;
    //   case "Tw":
    //   loginStateSubscription=authBloc.currentUser.listen((fbUser){
    //   if (fbUser!=null){
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context)=>HomeScreen2())
    //     );
    //   }
    //   });
    //   break;
    // }
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    // var authBlocGoogle= Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/login/yoshi.png',
              width: 200.0,
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  child: Text('Iniciar Sesion'),
                  onPressed: () {
                    auth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    });
                  }),
              ElevatedButton(
                child: Text('Registrarse'),
                onPressed: () {
                  auth
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((_) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
              )
            ]),
            SignInButton(Buttons.Facebook,
                onPressed: () => authBloc.loginFacebook().then((_) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Home()));
                    })),
            SignInButton(Buttons.Google,
                onPressed: () => authBloc.loginGoogle().then((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen1()));
                    })),
            SignInButton(Buttons.Twitter,
                onPressed: () => authBloc.loginTwitter().then((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen2()));
                    })),
          ],
        ),
      ),
    );
  }

  Widget user_contra() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: 'ingrese su usuario'),
      ),
    );
  }

  // Widget password() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     child: TextFormField(
  //       decoration: InputDecoration(hintText: 'ingrese su contraseña'),
  //       obscureText: true,
  //     ),
  //   );
  // }

  // Widget button_login() {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 32.0),
  //     child: RaisedButton(
  //       child: Text("ingresar"),
  //       onPressed: () {},
  //     ),
  //   );
  // }
}
