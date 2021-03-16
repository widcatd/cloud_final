import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/*

class AddUser extends StatelessWidget {
  final String fullName;
  final String zona;
  final LatLng ubicacion;

  AddUser(this.ubicacion, this.zona, this.fullName);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users =
        FirebaseFirestore.instance.collection('AlertasGeneradas');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'usuario': fullName, // John Doe
            'zona': zona, // Stokes and Sons
            'LatLng': ubicacion // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

*/
class Usuarios extends StatefulWidget {
  @override
  State createState() => UsuariosState();
}

class UsuariosState extends State<Usuarios> {
  final String documentId = '0000001';

  //UsuariosState(this.documentId);
  @override
  Widget build(BuildContext context) {
    CollectionReference alertas =
        FirebaseFirestore.instance.collection('AlertasGeneradas');

    return FutureBuilder<DocumentSnapshot>(
      future: alertas.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['Alerta']} ${data['Mensaje']}");
        }

        return Text("loading");
      },
    );
  }
}

class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AlertasGeneradas');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Alerta Arequipa"),
          ),
          body: new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document.data()['Alerta']),
                subtitle: new Text(document.data()['Mensaje']),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
