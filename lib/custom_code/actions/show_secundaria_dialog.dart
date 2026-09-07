// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/app_state.dart';

/// Abre una ventana para elegir de 1 a 5 asignaturas de SECUNDARIA (ESO).
///
/// Marca/desmarca cada una en FFAppState().selectedThemes usando las MISMAS
/// claves que el mapa de loadTriviaQuestions.
///
/// En FlutterFlow: crea esta Custom Action, activa el argumento BuildContext
/// (Add Argument -> "context", tipo BuildContext) y llámala en el On Tap del
/// contenedor SECUNDARIA.
Future showSecundariaDialog(BuildContext context) async {
  // Paleta acorde a tu app (oscuro + dorado)
  const Color cardBg = Color(0xFF050C18);
  const Color borderDark = Color(0xFF182544);
  const Color gold = Color(0xFFC9A961);
  const Color white = Colors.white;

  // Las 5 asignaturas: el texto DEBE coincidir con las claves del mapa.
  const List<String> temas = [
    'ESO Matemáticas',
    'ESO Lengua',
    'ESO Geografía e Historia',
    'ESO Física y Química',
    'ESO Biología y Geología',
  ];

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          bool isSel(String t) => FFAppState().selectedThemes.contains(t);

          void toggle(String t) {
            final lista = FFAppState().selectedThemes.toList();
            if (lista.contains(t)) {
              lista.remove(t);
            } else {
              lista.add(t);
            }
            // update() avisa a la HomePage (context.watch) para que el borde
            // de SECUNDARIA se refresque al cerrar la ventana.
            FFAppState().update(() {
              FFAppState().selectedThemes = lista;
            });
            setState(() {});
          }

          return Dialog(
            backgroundColor: cardBg,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: borderDark, width: 3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  const Text(
                    'SECUNDARIA (ESO)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Elige de 1 a 5 asignaturas',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Lista de asignaturas
                  ...temas.map((t) {
                    final sel = isSel(t);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () => toggle(t),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: sel
                                ? gold.withOpacity(0.15)
                                : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel ? gold : borderDark,
                              width: sel ? 2.5 : 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                sel
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: sel ? gold : Colors.white38,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 16,
                                    fontWeight:
                                        sel ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 8),

                  // Botón LISTO
                  InkWell(
                    onTap: () => Navigator.of(ctx).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'LISTO',
                        style: TextStyle(
                          color: Color(0xFF050C18),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
