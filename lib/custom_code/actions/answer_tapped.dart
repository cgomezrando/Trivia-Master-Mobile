// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

bool _respondiendo = false;

/// Gestiona el toque en una respuesta.
///
/// Primero muestra el feedback de acierto/fallo y DESPUÉS aplica el punto,
/// el turno y el avance en un solo update().
///
/// En la última pregunta NO avanza el índice: antes lo dejaba en 10 con 10
/// preguntas y la pantalla mostraba "Pregunta 11 de 10", el enunciado
/// "Question" y las respuestas "Answer A".."Answer D" detrás del diálogo
/// de resultados.
///
/// FlutterFlow: Custom Action con BuildContext (context) activado y el
/// argumento selectedIndex (Integer). En cada botón: answerTapped(context, 0/1/2/3).
Future answerTapped(
  BuildContext context,
  int selectedIndex,
) async {
  if (_respondiendo) return; // dos toques seguidos no cuentan dos veces

  final preguntas = FFAppState().questions;
  final idx = FFAppState().currentQuestionIndex;
  if (idx < 0 || idx >= preguntas.length) return;

  _respondiendo = true;

  final acierto = preguntas[idx].correctIndex == selectedIndex;

  // 1) Feedback primero: la pantalla de detrás no cambia todavía.
  await showAnswerFeedback(context, acierto);

  if (!context.mounted) {
    _respondiendo = false;
    return;
  }

  final esUltima = idx + 1 >= preguntas.length;

  // 2) Punto, turno y avance, todo junto y avisando a la pantalla.
  FFAppState().update(() {
    if (acierto) {
      final jugadores = FFAppState().players.toList();
      final pi = FFAppState().currentPlayerIndex;
      if (pi >= 0 && pi < jugadores.length) {
        jugadores[pi].score = jugadores[pi].score + 1;
        FFAppState().players = jugadores;
      }
    }
    if (!esUltima) {
      if (FFAppState().players.isNotEmpty) {
        FFAppState().currentPlayerIndex =
            (FFAppState().currentPlayerIndex + 1) % FFAppState().players.length;
      }
      FFAppState().currentQuestionIndex = idx + 1;
    }
  });

  _respondiendo = false;

  // 3) Fin de partida.
  if (esUltima) {
    final clasificacion = await computeRanking(FFAppState().players.toList());
    FFAppState().update(() {
      FFAppState().ranking = clasificacion;
    });
    if (!context.mounted) return;
    await showResultsDialog(context);
  }
}
