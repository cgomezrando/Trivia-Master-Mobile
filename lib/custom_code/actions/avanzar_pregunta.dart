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

Future<bool> avanzarPregunta(String partidaId) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final db = FirebaseFirestore.instance;
    final partidaRef = db.collection('partidas').doc(partidaId);

    final partidaSnap = await partidaRef.get();
    final data = partidaSnap.data() as Map<String, dynamic>;

    if (data['anfitrionUid'] != user.uid) {
      debugPrint('Error: Solo el anfitrión puede avanzar preguntas');
      return false;
    }

    final idxActual = (data['indiceActual'] ?? 0) as int;
    final preguntas = (data['preguntas'] ?? []) as List<dynamic>;
    final esUltima = idxActual + 1 >= preguntas.length;

    if (esUltima) {
      await partidaRef.update({
        'estado': 'terminada',
      });
    } else {
      final nuevoIdx = idxActual + 1;

      final jugadoresSnap = await partidaRef.collection('jugadores').get();
      for (final doc in jugadoresSnap.docs) {
        await doc.reference.update({
          'respuestaIndice': -1,
          'respondidoEn': null,
          'puntosRonda': 0,
        });
      }

      await partidaRef.update({
        'estado': 'jugando',
        'indiceActual': nuevoIdx,
        'numeroPreguntaActual': nuevoIdx + 1,
        'preguntaAbiertaEn': DateTime.now(),
      });

      debugPrint('Avanzando a pregunta ${nuevoIdx + 1}');
    }

    return true;
  } catch (e) {
    debugPrint('Error al avanzar pregunta: $e');
    return false;
  }
}
