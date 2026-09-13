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

Future<bool> enviarRespuesta(
  String partidaId,
  int respuestaIndice,
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || respuestaIndice < 0 || respuestaIndice > 3) {
      return false;
    }

    final db = FirebaseFirestore.instance;
    final jugadorRef = db
        .collection('partidas')
        .doc(partidaId)
        .collection('jugadores')
        .doc(user.uid);

    final docSnapshot = await jugadorRef.get();
    if (!docSnapshot.exists) {
      debugPrint('Error: Jugador no encontrado en partida');
      return false;
    }

    final data = docSnapshot.data() as Map<String, dynamic>;
    if (data['respuestaIndice'] != -1 && data['respondidoEn'] != null) {
      debugPrint('Jugador ya respondió a esta pregunta');
      return false;
    }

    // Hora del SERVIDOR, no la del dispositivo de cada jugador. Es la
    // misma corrección que en avanzar_pregunta.dart / iniciar_partida.dart:
    // preguntaAbiertaEn y respondidoEn tienen que medirse con el MISMO
    // reloj para que la resta (respondidoEn - preguntaAbiertaEn) sea un
    // tiempo real comparable entre jugadores, en vez de depender del reloj
    // de cada tablet.
    await jugadorRef.update({
      'respuestaIndice': respuestaIndice,
      'respondidoEn': FieldValue.serverTimestamp(),
    });

    debugPrint('Respuesta enviada: pregunta índice $respuestaIndice');
    return true;
  } catch (e) {
    debugPrint('Error al enviar respuesta: $e');
    return false;
  }
}
