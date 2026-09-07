// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<PlayerStruct>> buildPlayers(
  List<String> playerNames,
) async {
  final cleaned =
      playerNames.map((n) => n.trim()).where((n) => n.isNotEmpty).toList();

  if (cleaned.isEmpty) {
    return [PlayerStruct(name: 'Jugador 1', score: 0, position: 0)];
  }

  return cleaned
      .map((name) => PlayerStruct(name: name, score: 0, position: 0))
      .toList();
}
