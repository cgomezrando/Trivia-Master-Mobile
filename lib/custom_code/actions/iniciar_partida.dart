// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> iniciarPartida(String partidaId) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final db = FirebaseFirestore.instance;
    final partidaRef = db.collection('partidas').doc(partidaId);

    final partidaSnap = await partidaRef.get();
    final data = partidaSnap.data() as Map<String, dynamic>;

    if (data['anfitrionUid'] != user.uid) {
      debugPrint('Error: Solo el anfitrión puede iniciar la partida');
      return false;
    }

    await partidaRef.update({
      'estado': 'jugando',
      'indiceActual': 0,
      'numeroPreguntaActual': 1,
      'preguntaAbiertaEn': DateTime.now(),
    });

    debugPrint('Partida iniciada');
    return true;
  } catch (e) {
    debugPrint('Error al iniciar partida: $e');
    return false;
  }
}
