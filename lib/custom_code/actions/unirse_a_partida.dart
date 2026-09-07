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

/// Se une a una partida existente buscándola por su código de 4 dígitos.
///
/// Devuelve el ID del documento de la partida si todo sale bien. Si algo
/// falla, en vez de devolver siempre '' (que hacía imposible saber la causa
/// real), devuelve un texto que empieza por "ERR_" con el motivo exacto:
///   ERR_NOAUTH        -> no se pudo autenticar al usuario
///   ERR_NOTFOUND      -> no existe ninguna partida con ese código
///   ERR_NOTLOBBY      -> la partida existe pero ya empezó o terminó
///   ERR_FULL          -> la sala ya tiene el máximo de jugadores
///   ERR_EXCEPTION::xx -> excepción real de Firebase (permisos, red, etc.)
/// show_multiplayer_setup.dart interpreta estos códigos para mostrar un
/// mensaje útil y así poder diagnosticar el fallo real.
Future<String> unirseAPartida(
  String codigo,
  String nombre,
) async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // La sesión anónima a veces todavía no ha terminado de iniciarse
      // (por ejemplo si el usuario abre la app y toca muy rápido). En vez
      // de fallar directamente, intentamos iniciar sesión anónima aquí
      // mismo antes de rendirnos.
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

    final db = FirebaseFirestore.instance;

    final querySnapshot = await db
        .collection('partidas')
        .where('codigo', isEqualTo: codigo)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      debugPrint('Error: Partida no encontrada con código: $codigo');
      return 'ERR_NOTFOUND';
    }

    final docRef = querySnapshot.docs.first.reference;
    final partidaData = querySnapshot.docs.first.data();

    if (partidaData['estado'] != 'lobby') {
      debugPrint('Error: La partida no está en lobby');
      return 'ERR_NOTLOBBY';
    }

    final jugadoresSnapshot = await docRef.collection('jugadores').get();
    if (jugadoresSnapshot.docs.length >= (partidaData['maxJugadores'] ?? 8)) {
      debugPrint('Error: Máximo de jugadores alcanzado');
      return 'ERR_FULL';
    }

    await docRef.collection('jugadores').doc(user.uid).set({
      'nombre': nombre,
      'puntos': 0,
      'puntosRonda': 0,
      'esAnfitrion': false,
      'respuestaIndice': -1,
      'respuestaEnPregunta': -1,
      'respondidoEn': null,
      'activo': true,
      'salidaEn': null,
      'ultimoLatido': DateTime.now(),
    });

    debugPrint('Jugador ${user.uid} se unió a partida: ${docRef.id}');
    return docRef.id;
  } catch (e) {
    debugPrint('Error al unirse a partida: $e');
    return 'ERR_EXCEPTION::$e';
  }
}
