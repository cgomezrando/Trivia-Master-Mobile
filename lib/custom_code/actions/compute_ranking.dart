// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

Future<List<PlayerStruct>> computeRanking(
  List<PlayerStruct> players,
) async {
  final sorted = players.map((p) {
    return PlayerStruct(name: p.name, score: p.score, position: 0);
  }).toList();

  sorted.sort((a, b) => b.score.compareTo(a.score));

  int position = 0;
  int? lastScore;
  for (int i = 0; i < sorted.length; i++) {
    if (lastScore == null || sorted[i].score != lastScore) {
      position = i + 1;
      lastScore = sorted[i].score;
    }
    sorted[i].position = position;
  }

  return sorted;
}
