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

Future<bool> cerrarPregunta(String partidaId) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final db = FirebaseFirestore.instance;
    final partidaRef = db.collection('partidas').doc(partidaId);

    final partidaSnap = await partidaRef.get();
    final data = partidaSnap.data() as Map<String, dynamic>;

    if (data['anfitrionUid'] != user.uid) {
      debugPrint('Error: Solo el anfitrión puede cerrar preguntas');
      return false;
    }

    final indiceActual = (data['indiceActual'] ?? 0) as int;
    final preguntas = (data['preguntas'] ?? []) as List<dynamic>;
    final segundosPorPregunta = (data['segundosPorPregunta'] ?? 20) as int;

    int correctIndex = -1;
    if (indiceActual >= 0 && indiceActual < preguntas.length) {
      final pregunta = preguntas[indiceActual] as Map<String, dynamic>;
      correctIndex = (pregunta['correctIndex'] ?? -1) as int;
    }

    DateTime? abiertaEn;
    final rawAbierta = data['preguntaAbiertaEn'];
    if (rawAbierta is Timestamp) {
      abiertaEn = rawAbierta.toDate();
    } else if (rawAbierta is DateTime) {
      abiertaEn = rawAbierta;
    }

    final jugadoresSnap = await partidaRef.collection('jugadores').get();
    for (final doc in jugadoresSnap.docs) {
      final jugadorData = doc.data();
      final respuestaIndice = (jugadorData['respuestaIndice'] ?? -1) as int;
      final puntosActuales = (jugadorData['puntos'] ?? 0) as int;

      int puntosRonda = 0;
      if (correctIndex != -1 && respuestaIndice == correctIndex) {
        puntosRonda = 100;

        DateTime? respondidoEn;
        final rawRespondido = jugadorData['respondidoEn'];
        if (rawRespondido is Timestamp) {
          respondidoEn = rawRespondido.toDate();
        } else if (rawRespondido is DateTime) {
          respondidoEn = rawRespondido;
        }

        if (abiertaEn != null &&
            respondidoEn != null &&
            segundosPorPregunta > 0) {
          final tardadoSegundos =
              respondidoEn.difference(abiertaEn).inMilliseconds / 1000.0;
          final fraccionRestante =
              (segundosPorPregunta - tardadoSegundos) / segundosPorPregunta;
          final bono = (fraccionRestante.clamp(0.0, 1.0) * 100).round();
          puntosRonda += bono;
        }
      }

      await doc.reference.update({
        'puntosRonda': puntosRonda,
        'puntos': puntosActuales + puntosRonda,
      });
    }

    await partidaRef.update({
      'estado': 'revelando',
    });

    debugPrint('Pregunta cerrada, revelando respuestas');
    return true;
  } catch (e) {
    debugPrint('Error al cerrar pregunta: $e');
    return false;
  }
}
