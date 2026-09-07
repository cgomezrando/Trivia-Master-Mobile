// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Resetea todo el estado de la partida para volver a la HomePage limpia.
///
/// Úsala en el On Tap del icono de casa, ANTES de "Navigate To -> HomePage"
/// (con Replace Route marcado), y también en el On Page Load de la HomePage
/// para que la limpieza ocurra aunque se salga con el gesto de atrás.
///
/// En FlutterFlow: Custom Action sin argumentos y sin return.
Future resetGame() async {
  FFAppState().update(() {
    FFAppState().selectedThemes = <String>[];
    FFAppState().questions = <TriviaQuestionStruct>[];
    FFAppState().players = <PlayerStruct>[];
    FFAppState().ranking = <PlayerStruct>[];
    FFAppState().currentQuestionIndex = 0;
    FFAppState().currentPlayerIndex = 0;
    // 0 y no 1: con 1, al volver del juego la tarjeta INDIVIDUAL aparecía
    // ya seleccionada, mientras que en un arranque en frío no había nada
    // marcado. Dos estados iniciales distintos para la misma pantalla.
    FFAppState().numPlayers = 0;
  });
}
