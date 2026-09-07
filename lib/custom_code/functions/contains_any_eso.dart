import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';

bool containsAnyEso(List<String> selected) {
  const eso = [
    'ESO Matemáticas',
    'ESO Lengua',
    'ESO Geografía e Historia',
    'ESO Física y Química',
    'ESO Biología y Geología',
  ];
  return selected.any((t) => eso.contains(t));
}
