import 'package:cloud_final/modulo_alertas/features/puntos_de_peligro/presentation/pages/puntos_de_peligro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_final/modulo_autenticacion/login/log.dart';
import 'package:cloud_final/modulo_alertas/moduloAlertas.dart';
import 'package:cloud_final/modulo_reportes/moduloReportes.dart';
import 'package:cloud_final/modulo_usuarios/moduloUsuarios.dart';
import 'package:cloud_final/modulo_alertas/core/routes/router.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("alerta arequipa"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (Reportes())));
                },
                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/reportes.png',
                        width: 70.0,
                        height: 70.0,
                      ),
                      Text(
                        "generar reporte",
                        style: new TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (PuntosDePeligroPage())));
                },
                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/alerta.jpg',
                        width: 80.0,
                        height: 80.0,
                      ),
                      Text(
                        "generar alerta",
                        style: new TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text("emaildeprueba"),
              accountEmail: new Text("emaildeprueba@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  //backgroundImage: NetworkImage(authBloc.foto + '?width=500&height=500&access_token=' + s2),
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
