// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' show Random;

/// Ventana de resultados al terminar la partida.
///
/// - 1 jugador: aciertos sobre el total y porcentaje. - Varios: ranking con
/// el ganador arriba.
///
/// Ahora tiene salida: "Jugar otra vez" reinicia marcadores y vuelve a
/// barajar las mismas preguntas, y "Volver al inicio" limpia la partida y
/// lleva a la HomePage. Antes solo cerraba el diálogo y dejaba al jugador en
/// una pantalla de juego ya terminada.
///
/// En FlutterFlow: Custom Action con BuildContext (context) activado.
Future showResultsDialog(BuildContext context) async {
  const Color cardBg = Color(0xFF050C18);
  const Color gold = Color(0xFFC9A961);
  const Color white = Colors.white;

  final ranking = FFAppState().ranking;
  final total = FFAppState().questions.length;
  final soloUno = ranking.length <= 1;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      return Dialog(
        backgroundColor: cardBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: gold, width: 2),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.emoji_events, color: gold, size: 64),
                const SizedBox(height: 8),
                Text(
                  soloUno
                      ? '¡Partida terminada!'
                      : '🏆 Ganador: ${ranking.isNotEmpty ? ranking.first.name : ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: gold, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (soloUno) ...[
                  Text(
                    '${ranking.isNotEmpty ? ranking.first.score : 0} / $total',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    total == 0
                        ? '0% de aciertos'
                        : '${(((ranking.isNotEmpty ? ranking.first.score : 0) / total) * 100).round()}% de aciertos',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ] else ...[
                  ...ranking.asMap().entries.map((e) {
                    final i = e.key;
                    final p = e.value;
                    final medalla = i == 0
                        ? '🥇'
                        : i == 1
                            ? '🥈'
                            : i == 2
                                ? '🥉'
                                : '${p.position}.';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 36,
                            child: Text(medalla,
                                style: const TextStyle(
                                    color: white, fontSize: 20)),
                          ),
                          Expanded(
                            child: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: i == 0 ? gold : white,
                                fontSize: 18,
                                fontWeight:
                                    i == 0 ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                          Text('${p.score} pts',
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 22),

                // Jugar otra vez
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _reiniciarPartida();
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: cardBg,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('JUGAR OTRA VEZ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),

                // Volver al inicio
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await resetGame();
                      if (context.mounted) {
                        context.goNamed('HomePage');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side:
                          const BorderSide(color: Color(0xFF182544), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('VOLVER AL INICIO',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Deja la partida lista para repetirse: marcadores a cero, índices a cero
/// y las mismas preguntas en otro orden.
void _reiniciarPartida() {
  final preguntas = FFAppState().questions.toList()..shuffle(Random());
  final jugadores = FFAppState()
      .players
      .map((p) => PlayerStruct(name: p.name, score: 0, position: 0))
      .toList();

  FFAppState().update(() {
    FFAppState().questions = preguntas;
    FFAppState().players = jugadores;
    FFAppState().ranking = <PlayerStruct>[];
    FFAppState().currentQuestionIndex = 0;
    FFAppState().currentPlayerIndex = 0;
  });
}
