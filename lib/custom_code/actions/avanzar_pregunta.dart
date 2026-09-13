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

      // IMPORTANTE: se usa la hora del SERVIDOR de Firestore, no la del
      // dispositivo (DateTime.now()). Antes se guardaba la hora local de la
      // tablet del anfitrión y luego se comparaba con la hora local de cada
      // jugador al responder (respondidoEn, en enviar_respuesta.dart): si
      // los relojes de los dispositivos no estaban perfectamente
      // sincronizados, o si el anfitrión veía la pregunta nueva antes que
      // el resto (su propio Firestore local se actualiza al instante,
      // mientras que a los demás les llega tras el viaje de ida y vuelta al
      // servidor), el anfitrión salía beneficiado en la puntuación por
      // tiempo. Con FieldValue.serverTimestamp() todos los tiempos se miden
      // con el mismo reloj (el del servidor), así que deja de depender de
      // qué dispositivo es más rápido en ver o guardar la hora.
      await partidaRef.update({
        'estado': 'jugando',
        'indiceActual': nuevoIdx,
        'numeroPreguntaActual': nuevoIdx + 1,
        'preguntaAbiertaEn': FieldValue.serverTimestamp(),
      });

      debugPrint('Avanzando a pregunta ${nuevoIdx + 1}');
    }

    return true;
  } catch (e) {
    debugPrint('Error al avanzar pregunta: $e');
    return false;
  }
}
