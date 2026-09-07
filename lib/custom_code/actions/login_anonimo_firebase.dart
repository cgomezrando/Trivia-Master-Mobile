// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_auth/firebase_auth.dart';

Future<bool> loginAnonimoFirebase() async {
  try {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      debugPrint('Usuario ya autenticado: ${auth.currentUser!.uid}');
      return true;
    }
    final userCredential = await auth.signInAnonymously();
    debugPrint('Login anónimo exitoso. UID: ${userCredential.user!.uid}');
    return true;
  } catch (e) {
    debugPrint('Error en login anónimo: $e');
    return false;
  }
}
