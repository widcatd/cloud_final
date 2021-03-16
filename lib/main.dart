import 'package:flutter/material.dart';
import 'package:cloud_final/modulo_alertas/moduloAlertas.dart';
import 'package:cloud_final/modulo_reportes/moduloReportes.dart';
import 'package:cloud_final/modulo_usuarios/moduloUsuarios.dart';
import 'package:cloud_final/modulo_alertas/core/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_final/modulo_autenticacion/blocks/auth_block.dart';
import 'package:cloud_final/modulo_autenticacion/login/log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //primer reportno maps
    /*
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: Alertas(),
      //home: Reportes(),
      home: Loginpage(),
      //routes: Routes.routes,
      //home: UserInformation(),
    );
    */
    return Provider(
        // providers: [
        // Provider(create: (context)=> AuthBloc()),
        create: (context) => AuthBloc(),
        // ],
        // create: (context)=> AuthBloc(),
        child: MaterialApp(
          title: 'Alerta Arequipa',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: Loginpage(),
        ));
  }
}
