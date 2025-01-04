
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:paybiz/core/app/routes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Timer? _inactivityTimer;

  // Signup with additional user details
  Future<void> signup({
    required String accountNumber,
    required String firstName,
    required String lastName,
    required String cellNumber,
    required String email,
    required String province,
    required String suburb,
    required String city,
    required String streetNumber,
    required String streetName,
    required String idNumber,
    required String password,
    required double initialBalance, // Added initial balance
    required BuildContext context,
  }) async {
    try {
      // Derive date of birth from ID number
      DateTime dob = _extractDOBFromID(idNumber);

      // Create the user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save additional user details in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'accountNumber': accountNumber,
          'firstName': firstName,
          'lastName': lastName,
          'cellNumber': cellNumber,
          'email': email,
          'province': province,
          'suburb': suburb,
          'city': city,
          'streetNumber': streetNumber,
          'streetName': streetName,
          'idNumber': idNumber,
          'dob': dob.toIso8601String(),
          'balance': initialBalance, // Initialize balance
          'createdAt': FieldValue.serverTimestamp(),
        });

        Fluttertoast.showToast(
          msg: 'Signup successful! Welcome, $firstName.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        // Navigate to the home screen
        Navigator.pushReplacementNamed(context, '/');
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Signin method (updated to support email or cell number login)
  Future<void> signin({
    required String emailOrCellNumber,
    required String password,
    required BuildContext context,
  }) async {
    try {
      String emailToUse = emailOrCellNumber;

      // If it's a cell number, look up the associated email in Firestore
      if (!emailOrCellNumber.contains('@')) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .where('cellNumber', isEqualTo: emailOrCellNumber)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.isNotEmpty
                ? snapshot.docs.first
                : throw Exception('No user found with this cell number'));

        emailToUse = userDoc['email'];
      }

      // Use the email to sign in
      await _auth.signInWithEmailAndPassword(email: emailToUse, password: password);

      Fluttertoast.showToast(
        msg: 'Login successful!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      // Start inactivity timer
      _startInactivityTimer(context);

       Navigator.pushNamed(context, Routes.home);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email or cell number.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Signout method
  Future<void> signout({required BuildContext context}) async {
    _inactivityTimer?.cancel();
    await _auth.signOut();
    Fluttertoast.showToast(
      msg: 'Logout successful!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );

     Navigator.pushNamed(context, Routes.login);
  }

  // Start inactivity timer
  void _startInactivityTimer(BuildContext context) {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 5), () {
      signout(context: context);
      Fluttertoast.showToast(
        msg: 'You have been logged out due to inactivity.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    });
  }

  // Reset inactivity timer 
  void resetInactivityTimer(BuildContext context) {
    _startInactivityTimer(context);
  }

  // Extract Date of Birth from ID Number
  DateTime _extractDOBFromID(String idNumber) {
    if (idNumber.length != 13) {
      throw Exception('Invalid ID Number length');
    }

    String yy = idNumber.substring(0, 2);
    String mm = idNumber.substring(2, 4);
    String dd = idNumber.substring(4, 6);

    int year = int.parse(yy);
    year += (year < 50) ? 2000 : 1900;

    int month = int.parse(mm);
    int day = int.parse(dd);

    DateTime dob = DateTime(year, month, day);
    if (dob.isAfter(DateTime.now())) {
      throw Exception('Invalid Date of Birth');
    }

    return dob;
  }
}
