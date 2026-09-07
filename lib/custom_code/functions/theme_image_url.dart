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

String themeImageUrl(String theme) {
  const String base =
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/trivia-master-48ll8w/assets';

  const String iconoSecundaria =
      '$base/7cujadfehb8w/Secundaria-removebg-preview.png';
  const String iconoHistoria = '$base/72hvygvjp67v/historia.png';

  final Map<String, String> imagenes = {
    'FUTBOL': '$base/dogrcpfk5iw7/Futbol.png',
    'MUNDIALES': '$base/dyuznxqc3crw/mundiales.png',
    'REGUETON': '$base/6lzfweb9jjgf/Regueton.png',
    'MADRIDISTA': '$base/6zw26ht4tbqe/madridista.png',
    'BARCELONISTA': '$base/m0b9s4o268n0/Barcelonista.png',
    'Cuerpo humano': '$base/iprk6v0j0bwy/Esqueleto-removebg-preview.png',
    'INVENTORES': '$base/r6t8mv0ja106/Inventores-removebg-preview.png',
    'HISTORIA DE ESPAÑA': iconoHistoria,
    'ESO Matemáticas': iconoSecundaria,
    'ESO Lengua': iconoSecundaria,
    'ESO Geografía e Historia': iconoHistoria,
    'ESO Física y Química': iconoSecundaria,
    'ESO Biología y Geología': iconoSecundaria,
  };

  return imagenes[theme.trim()] ?? iconoSecundaria;
}
