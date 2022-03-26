import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  getId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> saveData(doctor) async {
    return await _db
        .collection("users")
        .doc(getId())
        .set(doctor);
  }

}







