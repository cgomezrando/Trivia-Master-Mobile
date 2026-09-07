// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Crea una partida nueva y devuelve el ID del documento.
///
/// Igual que en unirseAPartida, si algo falla se devuelve un texto que
/// empieza por "ERR_" con el motivo exacto en vez de siempre '', para poder
/// saber qué ha pasado realmente (antes cualquier fallo -incluido un
/// permiso denegado de Firestore- se veía igual que "no se pudo crear").
///   ERR_NOAUTH        -> no se pudo autenticar al usuario
///   ERR_SINPREGUNTAS  -> no hay preguntas para los temas elegidos
///   ERR_EXCEPTION::xx -> excepción real de Firebase (permisos, red, etc.)
Future<String> crearPartida(
  List<String> selectedThemes,
  int questionCount,
  bool shuffleAnswers,
  int segundosPorPregunta,
  int maxJugadores,
  String hostName,
) async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        final credential = await FirebaseAuth.instance.signInAnonymously();
        user = credential.user;
      } catch (e) {
        debugPrint('Error al reintentar login anónimo: $e');
      }
    }
    if (user == null) {
      debugPrint('Error: No hay usuario autenticado');
      return 'ERR_NOAUTH';
    }

    final preguntas = await loadTriviaQuestions(
        selectedThemes, questionCount, shuffleAnswers);
    if (preguntas.isEmpty) {
      debugPrint('Error: No se cargaron preguntas');
      return 'ERR_SINPREGUNTAS';
    }

    final db = FirebaseFirestore.instance;
    final docRef = db.collection('partidas').doc();
    final codigo = await _generarCodigoSala();

    await docRef.set({
      'codigo': codigo,
      'anfitrionUid': user.uid,
      'estado': 'lobby',
      'temas': selectedThemes,
      'preguntas': preguntas
          .map((q) => {
                'question': q.question,
                'answers': q.answers,
                'correctIndex': q.correctIndex,
                'theme': q.theme,
              })
          .toList(),
      'indiceActual': 0,
      'numeroPreguntaActual': 1,
      'preguntaAbiertaEn': null,
      'segundosPorPregunta': segundosPorPregunta,
      'maxJugadores': maxJugadores,
      'creadaEn': DateTime.now(),
    });

    await docRef.collection('jugadores').doc(user.uid).set({
      'nombre': hostName.trim().isEmpty ? 'Anfitrión' : hostName.trim(),
      'puntos': 0,
      'puntosRonda': 0,
      'esAnfitrion': true,
      'respuestaIndice': -1,
      'respuestaEnPregunta': -1,
      'respondidoEn': null,
      'activo': true,
      'salidaEn': null,
      'ultimoLatido': DateTime.now(),
    });

    debugPrint('Partida creada: ${docRef.id} con código $codigo');
    return docRef.id;
  } catch (e) {
    debugPrint('Error al crear partida: $e');
    return 'ERR_EXCEPTION::$e';
  }
}

Future<String> _generarCodigoSala() async {
  final db = FirebaseFirestore.instance;
  final rnd = Random();
  for (int intento = 0; intento < 10; intento++) {
    final codigo = (1000 + rnd.nextInt(9000)).toString();
    final existe = await db
        .collection('partidas')
        .where('codigo', isEqualTo: codigo)
        .where('estado', whereIn: ['lobby', 'jugando', 'revelando'])
        .limit(1)
        .get();
    if (existe.docs.isEmpty) return codigo;
  }
  return (1000 + rnd.nextInt(9000)).toString();
}
