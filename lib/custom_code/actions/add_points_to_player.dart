// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<PlayerStruct>> addPointsToPlayer(
  List<PlayerStruct> players,
  int playerIndex,
  int points,
) async {
  final updated = players.map((p) {
    return PlayerStruct(name: p.name, score: p.score, position: p.position);
  }).toList();

  if (playerIndex >= 0 && playerIndex < updated.length) {
    updated[playerIndex].score = updated[playerIndex].score + points;
  }
  return updated;
}
