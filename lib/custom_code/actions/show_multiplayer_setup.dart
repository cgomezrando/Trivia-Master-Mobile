// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Ventana de Multijugador: Crear Sala / Unirse a Sala.
///
/// IMPORTANTE (fix pedido por el usuario): elegir categorías solo hace
/// falta para CREAR una sala (las preguntas salen de ahí). Para UNIRSE no
/// hace falta ninguna categoría, porque las preguntas ya las trae la sala
/// a la que te unes. Por eso la comprobación de "elige una categoría" ya
/// no bloquea la apertura de esta ventana: solo se comprueba cuando se
/// pulsa "Crear" con el modo "Crear Sala" seleccionado.
Future showMultiplayerSetup(BuildContext context) async {
  String nombre = '';
  String modo = 'crear';
  String codigoUnirse = '';
  bool procesando = false;
  String? error;

  const cardBg = Color(0xFF050C18);
  const gold = Color(0xFFFFD54F);
  const borderInactivo = Color(0xFF182544);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: cardBg,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: gold, width: 2),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'MULTIJUGADOR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: gold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      const SizedBox(height: 16),
                      if (error != null) ...[
                        Text(error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 13)),
                        const SizedBox(height: 10),
                      ],
                      TextField(
                        enabled: !procesando,
                        onChanged: (v) => nombre = v,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: 'Tu nombre',
                          labelStyle: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          counterStyle: const TextStyle(
                              color: Colors.white38, fontSize: 11),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: borderInactivo, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: gold, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: procesando
                                  ? null
                                  : () => setState(() {
                                        modo = 'crear';
                                        error = null;
                                      }),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10233D),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: modo == 'crear'
                                          ? gold
                                          : borderInactivo,
                                      width: modo == 'crear' ? 3 : 2),
                                ),
                                child: const Text('Crear Sala',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: procesando
                                  ? null
                                  : () => setState(() {
                                        modo = 'unirse';
                                        error = null;
                                      }),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10233D),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: modo == 'unirse'
                                          ? gold
                                          : borderInactivo,
                                      width: modo == 'unirse' ? 3 : 2),
                                ),
                                child: const Text('Unirse a Sala',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (modo == 'unirse') ...[
                        const SizedBox(height: 16),
                        TextField(
                          enabled: !procesando,
                          onChanged: (v) => codigoUnirse = v,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'Código de 4 dígitos',
                            labelStyle: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: borderInactivo, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: gold, width: 2)),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        if (FFAppState().selectedThemes.isEmpty)
                          Text(
                            'No has elegido ninguna categoría todavía. Ciérra esta ventana y elige al menos una en la pantalla principal.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          )
                        else
                          Text(
                            'Categorías elegidas: ${FFAppState().selectedThemes.join(', ')}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  procesando ? null : () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: borderInactivo, width: 2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                              ),
                              child: const Text('Cancelar',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: procesando
                                  ? null
                                  : () async {
                                      if (nombre.trim().isEmpty) {
                                        setState(
                                            () => error = 'Escribe tu nombre.');
                                        return;
                                      }
                                      if (modo == 'unirse' &&
                                          codigoUnirse.trim().length != 4) {
                                        setState(() => error =
                                            'El código tiene 4 dígitos.');
                                        return;
                                      }
                                      if (modo == 'crear' &&
                                          FFAppState().selectedThemes.isEmpty) {
                                        setState(() => error =
                                            'Elige al menos una categoría en la pantalla principal antes de crear la sala.');
                                        return;
                                      }
                                      setState(() {
                                        procesando = true;
                                        error = null;
                                      });

                                      String resultado = '';
                                      try {
                                        if (modo == 'crear') {
                                          final temas = FFAppState()
                                              .selectedThemes
                                              .toList();
                                          final cuantas =
                                              FFAppState().numberOfQuestions > 0
                                                  ? FFAppState()
                                                      .numberOfQuestions
                                                  : 10;
                                          resultado = await crearPartida(
                                              temas,
                                              cuantas,
                                              true,
                                              20,
                                              8,
                                              nombre.trim());
                                        } else {
                                          resultado = await unirseAPartida(
                                              codigoUnirse.trim(),
                                              nombre.trim());
                                        }
                                      } catch (e) {
                                        resultado = 'ERR_EXCEPTION::$e';
                                      }

                                      if (!resultado.startsWith('ERR_')) {
                                        FFAppState().update(() {
                                          FFAppState().partidaId = resultado;
                                          FFAppState().isOnlineMode = true;
                                        });
                                        Navigator.pop(ctx);
                                        return;
                                      }

                                      setState(() {
                                        procesando = false;
                                        error = _mensajeError(modo, resultado);
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gold,
                                foregroundColor: cardBg,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                              ),
                              child: procesando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: cardBg))
                                  : Text(modo == 'crear' ? 'Crear' : 'Unirse',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  if (context.mounted &&
      FFAppState().isOnlineMode &&
      FFAppState().partidaId.isNotEmpty) {
    context.goNamed('GamePage');
  }
}

/// Traduce los códigos ERR_ de crearPartida/unirseAPartida a un mensaje
/// legible. Para ERR_EXCEPTION se muestra el error real de Firebase (por
/// ejemplo "PERMISSION_DENIED: Missing or insufficient permissions") para
/// poder identificar el problema exacto si vuelve a fallar.
String _mensajeError(String modo, String codigo) {
  if (codigo == 'ERR_NOAUTH') {
    return 'No se pudo verificar tu sesión. Cierra la app y vuelve a abrirla.';
  }
  if (codigo == 'ERR_NOTFOUND') {
    return 'No se ha encontrado esa sala. Comprueba el código.';
  }
  if (codigo == 'ERR_NOTLOBBY') {
    return 'Esa partida ya ha empezado o ha terminado.';
  }
  if (codigo == 'ERR_FULL') {
    return 'Esa sala ya está completa.';
  }
  if (codigo == 'ERR_SINPREGUNTAS') {
    return 'No hay preguntas para las categorías elegidas.';
  }
  if (codigo.startsWith('ERR_EXCEPTION::')) {
    final detalle = codigo.substring('ERR_EXCEPTION::'.length);
    return modo == 'crear'
        ? 'No se ha podido crear la sala:\n$detalle'
        : 'No se ha podido unir a la sala:\n$detalle';
  }
  return modo == 'crear'
      ? 'No se ha podido crear la sala. Inténtalo de nuevo.'
      : 'No se ha encontrado esa sala. Comprueba el código.';
}
