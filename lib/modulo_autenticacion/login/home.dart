import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:cloud_final/modulo_autenticacion/blocks/auth_block.dart';
import 'package:cloud_final/modulo_autenticacion/login/log.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<User> homeStateSubscription;
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    homeStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Loginpage()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    homeStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    // final AuthBloc i1= ModalRoute.of(context).settings.arguments;
    // var s2="EAAkHvZCTo7cIBANr4aVbyb8hWTV62WRH1YJhNVac2weoekAJ1YCGiR5nZBFCfKRHPX4qHWdZBijAh0hW7GuZBGv6DYupZCklvRa8748EVqX1YMt7uR0LsAFMCfsu2Wrw7Cq9YmLbfEspSPH9T6ruHLJed6b0fE0QgboMBXd4TRrtNwoR6mjjh4jgZBMzq8r76UpnzjGjmfHbZCXYcmzflgDQCtZAhXBxBjCM6vRB1nHzvIOFb9K2W9WS336WrqKrkKYZD";
    var s2 = authBloc.tokenPhoto;
    return Scaffold(
      appBar: new AppBar(
        title: Text("alerta arequipa"),
        backgroundColor: Colors.blue,
      ),
      body: Container(),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text(authBloc.nick),
              accountEmail: new Text(authBloc.correo),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    authBloc.foto + '?width=500&height=500&access_token=' + s2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Perfil"),
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text("Cambiar contraseña"),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("info"),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Salir de la aplicacion"),
            )
          ],
        ),
      ),
    );
  }
}
