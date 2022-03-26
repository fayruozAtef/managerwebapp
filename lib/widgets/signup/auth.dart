import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:http/http.dart' as http;

class Auth {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  getId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> saveData(doctor) async {
    return await _db
        .collection("employee")
        .doc(getId())
        .set(doctor);
  }

}







