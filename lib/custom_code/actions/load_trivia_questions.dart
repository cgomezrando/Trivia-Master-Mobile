// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert' show json, utf8;
import 'dart:math' show Random;
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────
//  MAPA TEMA -> URL DEL JSON
//  La CLAVE es la etiqueta EXACTA que el contenedor guarda en
//  FFAppState().selectedThemes. Si cambias el texto en un contenedor,
//  cámbialo también aquí.
// ─────────────────────────────────────────────────────────────────────────
const Map<String, String> _themeToUrl = {
  'FUTBOL':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/yu036vkksib1/futbol.json',
  'MUNDIALES':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/zto81csj21mj/mundiales.json',
  'REGUETON':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/9wq1nkrcr41w/regueton.json',
  'MADRIDISTA':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/35xkrgdqqxpl/Madridista.json',
  'BARCELONISTA':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/7ufzdqb63k2q/barcelonista.json',
  'Cuerpo humano':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/8wiod49wrzr4/cuerpohumano.json',
  'INVENTORES':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/0x3gny9puzli/inventores.json',
  'HISTORIA DE ESPAÑA':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/7c73w5722kqo/historia_de_espana.json',

  // ── Temas de ESO (se seleccionan desde la ventana de SECUNDARIA) ──
  'ESO Matemáticas':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/3akrih5uz4f4/eso_matematicas.json',
  'ESO Lengua':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/igg9akgc6sx8/eso_lengua.json',
  'ESO Geografía e Historia':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/uwnp5z8pvx3u/eso_geografiaehistoria.json',
  'ESO Física y Química':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/qjmyh347z0gi/eso_fisicaquimica.json',
  'ESO Biología y Geología':
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets/xihfiat0wg6p/eso_biologiageologia.json',
};

/// Descarga las preguntas de los temas seleccionados, las une, elimina
/// duplicados, mezcla y devuelve como máximo [questionCount] preguntas.
///
/// Acepta DOS formatos de `correctAnswer`:
///   - TEXTO: el texto de la opción correcta (tolera formas cortas, p.ej.
///     correcta "Sergio Ramos" y opción "Ramos").
///   - LETRA: "A" / "B" / "C" / "D".
/// Campos extra ("Subject", "id", "front", "block") se ignoran.
///
/// [selectedThemes] -> temas elegidos (claves del mapa). Si viene VACÍA
///                     devuelve una lista vacía; ya no carga todos los temas.
/// [questionCount]  -> nº de preguntas de la partida (0 = todas).
/// [shuffleAnswers] -> si true, baraja las opciones de cada pregunta.
Future<List<TriviaQuestionStruct>> loadTriviaQuestions(
  List<String> selectedThemes,
  int questionCount,
  bool shuffleAnswers,
) async {
  // Sin categorías elegidas no hay partida. Antes se cargaban TODOS los
  // temas, lo que mezclaba preguntas que el jugador no había pedido.
  if (selectedThemes.isEmpty) return <TriviaQuestionStruct>[];

  final rng = Random();
  final result = <TriviaQuestionStruct>[];
  final vistas = <String>{}; // para descartar preguntas repetidas
  int descartadas = 0;

  // Temas válidos, sin repetir y en el orden en que se eligieron.
  final temas = <String>[];
  for (final t in selectedThemes) {
    final clave = t.trim();
    final url = _themeToUrl[clave];
    if (url != null && url.isNotEmpty && !temas.contains(clave)) {
      temas.add(clave);
    }
  }
  if (temas.isEmpty) return <TriviaQuestionStruct>[];

  // Descarga en paralelo: con 5 asignaturas de ESO esto pasa de 5 esperas
  // encadenadas a una sola.
  final cuerpos = await Future.wait(
    temas.map((tema) => _descargar(_themeToUrl[tema]!)),
  );

  for (int t = 0; t < temas.length; t++) {
    final tema = temas[t];
    final bodyText = cuerpos[t];
    if (bodyText == null) continue;

    dynamic decoded;
    try {
      decoded = json.decode(bodyText);
    } catch (_) {
      continue;
    }

    final List<dynamic> rawList = decoded is Map<String, dynamic>
        ? (decoded['questions'] as List<dynamic>? ?? <dynamic>[])
        : (decoded is List ? decoded : <dynamic>[]);

    for (final item in rawList) {
      if (item is! Map) continue;
      final m = item.cast<String, dynamic>();

      final enunciado = (m['question'] ?? '').toString().trim();
      if (enunciado.isEmpty) continue;

      // Duplicados: mismo enunciado, aunque venga de otro tema.
      final clave = _normalizar(enunciado);
      if (!vistas.add(clave)) continue;

      // Las CUATRO opciones tal cual vienen. El índice correcto se resuelve
      // sobre estas cuatro, ANTES de descartar las vacías: si se filtran
      // primero, una "correctAnswer" por letra apunta a la opción de al lado.
      final crudas = <String>[
        (m['optionA'] ?? '').toString().trim(),
        (m['optionB'] ?? '').toString().trim(),
        (m['optionC'] ?? '').toString().trim(),
        (m['optionD'] ?? '').toString().trim(),
      ];

      final correcta = (m['correctAnswer'] ?? '').toString().trim();
      final idxCrudo = _resolveCorrectIndex(correcta, crudas);

      // Si no se puede saber cuál es la buena, se descarta la pregunta.
      // Antes se devolvía 0, es decir, se daba por correcta la opción A.
      if (idxCrudo < 0) {
        descartadas++;
        continue;
      }

      // Se emparejan texto y marca de "es la correcta", así el barajado no
      // puede perder el índice aunque haya dos opciones con el mismo texto.
      final pares = <MapEntry<String, bool>>[];
      for (int i = 0; i < crudas.length; i++) {
        if (crudas[i].isEmpty) continue;
        pares.add(MapEntry(crudas[i], i == idxCrudo));
      }
      if (pares.length < 2 || !pares.any((p) => p.value)) {
        descartadas++;
        continue;
      }

      if (shuffleAnswers) pares.shuffle(rng);

      result.add(
        TriviaQuestionStruct(
          question: enunciado,
          answers: pares.map((p) => p.key).toList(),
          correctIndex: pares.indexWhere((p) => p.value),
          theme: tema,
        ),
      );
    }
  }

  if (descartadas > 0) {
    debugPrint('loadTriviaQuestions: $descartadas preguntas descartadas por no '
        'poder identificar la respuesta correcta.');
  }

  result.shuffle(rng);

  if (questionCount > 0 && result.length > questionCount) {
    return result.sublist(0, questionCount);
  }
  return result;
}

/// Descarga una URL y devuelve el texto, o null si falla.
Future<String?> _descargar(String url) async {
  try {
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) return null;
    return utf8.decode(resp.bodyBytes); // acentos y ñ correctos
  } catch (_) {
    return null;
  }
}

/// Minúsculas, sin signos y sin espacios de más.
String _normalizar(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^0-9a-záéíóúüñ ]'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

/// Palabras de un texto, descartando las de una sola letra.
Set<String> _palabras(String s) =>
    _normalizar(s).split(' ').where((p) => p.length > 1).toSet();

/// Convierte `correctAnswer` en un índice 0..3 sobre las CUATRO opciones
/// originales. Devuelve -1 si no puede determinarlo con seguridad.
int _resolveCorrectIndex(String correct, List<String> crudas) {
  if (correct.isEmpty) return -1;

  // 1) Formato letra: "A" / "B" / "C" / "D".
  final up = correct.toUpperCase();
  const letras = {'A': 0, 'B': 1, 'C': 2, 'D': 3};
  if (up.length == 1 && letras.containsKey(up)) {
    final i = letras[up]!;
    return (i < crudas.length && crudas[i].isNotEmpty) ? i : -1;
  }

  // 2) Formato texto: coincidencia exacta.
  final c = _normalizar(correct);
  for (int i = 0; i < crudas.length; i++) {
    if (crudas[i].isNotEmpty && _normalizar(crudas[i]) == c) return i;
  }

  // 3) Coincidencia por palabras completas, para casos como
  //    correcta "Sergio Ramos" y opción "Ramos". Solo vale si UNA sola
  //    opción encaja; si encajan dos, es ambiguo y se descarta.
  //    (El "contains" de la versión anterior daba por buena la opción "1"
  //    cuando la correcta era "1985".)
  final palabrasCorrecta = _palabras(correct);
  if (palabrasCorrecta.isEmpty) return -1;

  int candidato = -1;
  for (int i = 0; i < crudas.length; i++) {
    if (crudas[i].isEmpty) continue;
    final po = _palabras(crudas[i]);
    if (po.isEmpty) continue;
    if (po.every(palabrasCorrecta.contains)) {
      if (candidato >= 0) return -1; // ambiguo
      candidato = i;
    }
  }
  return candidato;
}
