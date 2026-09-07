// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

bool _cargandoPartida = false;

/// Arranca la partida desde el botón JUGAR.
///
/// Sustituye a la cadena de acciones que había en el On Tap del contenedor.
/// Se encarga de todo: valida que haya categorías, muestra el indicador de
/// carga, descarga las preguntas, crea los jugadores, pone los índices a
/// cero y solo entonces navega a GamePage.
///
/// En FlutterFlow: Custom Action con el argumento BuildContext (context)
/// activado y sin valor de retorno.
Future startGame(BuildContext context) async {
  // Evita que dos toques seguidos lancen dos cargas y dos navegaciones.
  if (_cargandoPartida) return;

  final temas = FFAppState().selectedThemes.toList();

  if (temas.isEmpty) {
    _aviso(context, 'Elige al menos una categoría para jugar.');
    return;
  }

  _cargandoPartida = true;

  // Indicador de carga: con varias categorías la descarga tarda unos
  // segundos y antes la pantalla se quedaba congelada sin explicación.
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: SizedBox(
        width: 64,
        height: 64,
        child: CircularProgressIndicator(
          color: Color(0xFFFFD54F),
          strokeWidth: 5,
        ),
      ),
    ),
  );

  List<TriviaQuestionStruct> preguntas = <TriviaQuestionStruct>[];
  List<PlayerStruct> jugadores = <PlayerStruct>[];

  try {
    final cuantas = FFAppState().numberOfQuestions > 0
        ? FFAppState().numberOfQuestions
        : 10;

    preguntas = await loadTriviaQuestions(temas, cuantas, true);

    final cuantosJugadores =
        FFAppState().numPlayers > 0 ? FFAppState().numPlayers : 1;
    jugadores = await buildPlayers(generatePlayerNames(cuantosJugadores));
  } catch (_) {
    preguntas = <TriviaQuestionStruct>[];
  }

  _cargandoPartida = false;

  // Cerrar el indicador de carga.
  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  if (!context.mounted) return;

  // Sin preguntas no se navega. Antes se entraba igual y la pantalla de
  // juego mostraba "Question", "Answer A" y botones que no hacían nada.
  if (preguntas.isEmpty) {
    _aviso(
      context,
      'No se han podido cargar las preguntas. Comprueba tu conexión e '
      'inténtalo de nuevo.',
    );
    return;
  }

  FFAppState().update(() {
    FFAppState().questions = preguntas;
    FFAppState().players = jugadores;
    FFAppState().ranking = <PlayerStruct>[];
    FFAppState().currentQuestionIndex = 0;
    FFAppState().currentPlayerIndex = 0;
  });

  // 'GamePage' es el valor de GamePageWidget.routeName.
  //
  // goNamed y NO pushNamed: reemplaza la HomePage en vez de apilar la
  // GamePage encima. Así el gesto de atrás no puede devolverte a una home
  // con el estado de la partida anterior, y la única salida es el icono de
  // la casa, que sí ejecuta resetGame. De paso, la pila deja de crecer
  // dos rutas por cada partida.
  context.goNamed('GamePage');
}

void _aviso(BuildContext context, String mensaje) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: const Color(0xFF10233D),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(24),
    ),
  );
}
