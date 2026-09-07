// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OnlineGameView extends StatefulWidget {
  const OnlineGameView({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OnlineGameView> createState() => _OnlineGameViewState();
}

class _OnlineGameViewState extends State<OnlineGameView> {
  Timer? _timer;
  int _indiceAutoCerrado = -1;
  int _indiceDialogoMostrado = -1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partidaId = FFAppState().partidaId;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (partidaId.isEmpty) {
      return _mensajeCentrado('No hay ninguna partida activa.');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('partidas')
          .doc(partidaId)
          .snapshots(),
      builder: (context, partidaSnap) {
        if (!partidaSnap.hasData || !partidaSnap.data!.exists) {
          return _mensajeCentrado('Cargando partida...');
        }
        final partidaData = partidaSnap.data!.data() as Map<String, dynamic>;
        final estado = (partidaData['estado'] ?? 'lobby') as String;
        final esAnfitrion = partidaData['anfitrionUid'] == uid;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('partidas')
              .doc(partidaId)
              .collection('jugadores')
              .orderBy('puntos', descending: true)
              .snapshots(),
          builder: (context, jugadoresSnap) {
            final jugadores = jugadoresSnap.data?.docs ?? [];

            switch (estado) {
              case 'lobby':
                return _buildLobby(
                    context, partidaId, partidaData, jugadores, esAnfitrion);
              case 'jugando':
              case 'revelando':
                final indiceActual = (partidaData['indiceActual'] ?? 0) as int;
                if (estado == 'revelando' &&
                    indiceActual != _indiceDialogoMostrado) {
                  _indiceDialogoMostrado = indiceActual;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _mostrarDialogoRevelacion(
                          context, partidaId, indiceActual);
                    }
                  });
                }
                return _buildJugando(context, partidaId, partidaData, jugadores,
                    esAnfitrion, uid, estado);
              case 'terminada':
                return _buildTerminada(context, partidaId, jugadores);
              default:
                return _mensajeCentrado('Estado desconocido: $estado');
            }
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // LOBBY
  // ---------------------------------------------------------------------
  Widget _buildLobby(
    BuildContext context,
    String partidaId,
    Map<String, dynamic> partidaData,
    List<QueryDocumentSnapshot> jugadores,
    bool esAnfitrion,
  ) {
    final codigo = (partidaData['codigo'] ?? '----') as String;
    final maxJugadores = (partidaData['maxJugadores'] ?? 8) as int;

    return Container(
      color: Color(0xFF020818),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Color(0xFF00A3FF),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        await _salirDePartida(partidaId, uid: uid);
                        if (context.mounted) {
                          FFAppState().update(() {
                            FFAppState().isOnlineMode = false;
                            FFAppState().partidaId = '';
                          });
                          context.goNamed('HomePage');
                        }
                      },
                      child:
                          Icon(Icons.arrow_back, color: Colors.white, size: 40),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'SALA DE ESPERA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFD54F),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Código para compartir',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Color(0xFF10233D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFFFD54F), width: 2),
                ),
                child: Text(
                  codigo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Jugadores (${jugadores.length}/$maxJugadores)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: jugadores.length,
                  itemBuilder: (context, index) {
                    final data =
                        jugadores[index].data() as Map<String, dynamic>;
                    final esAnfitrionFila =
                        (data['esAnfitrion'] ?? false) as bool;
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF10233D),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Color(0xFF5E6F87), width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            esAnfitrionFila ? Icons.star : Icons.person,
                            color: esAnfitrionFila
                                ? Color(0xFFFFD54F)
                                : Colors.white70,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              (data['nombre'] ?? 'Jugador') as String,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (esAnfitrion)
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: jugadores.isEmpty
                      ? null
                      : () async {
                          await iniciarPartida(partidaId);
                        },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'INICIAR PARTIDA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF020818),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  'Esperando a que el anfitrión inicie la partida…',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // JUGANDO / REVELANDO — misma pantalla; en 'revelando' se congela y se
  // muestra encima la ventana con la respuesta correcta y los puntos.
  // ---------------------------------------------------------------------
  Widget _buildJugando(
    BuildContext context,
    String partidaId,
    Map<String, dynamic> partidaData,
    List<QueryDocumentSnapshot> jugadores,
    bool esAnfitrion,
    String uid,
    String estado,
  ) {
    final revelando = estado == 'revelando';
    final preguntas = (partidaData['preguntas'] ?? []) as List<dynamic>;
    final indiceActual = (partidaData['indiceActual'] ?? 0) as int;
    final numeroPreguntaActual =
        (partidaData['numeroPreguntaActual'] ?? 1) as int;
    final totalPreguntas = preguntas.length;
    final pregunta = (indiceActual >= 0 && indiceActual < preguntas.length)
        ? preguntas[indiceActual] as Map<String, dynamic>
        : <String, dynamic>{};
    final correctIndex = (pregunta['correctIndex'] ?? -1) as int;

    final restantes = _segundosRestantes(partidaData);

    Map<String, dynamic>? miData;
    for (final doc in jugadores) {
      if (doc.id == uid) {
        miData = doc.data() as Map<String, dynamic>;
        break;
      }
    }
    final yaRespondio =
        miData != null && ((miData['respuestaIndice'] ?? -1) as int) != -1;
    final miRespuesta =
        miData != null ? (miData['respuestaIndice'] ?? -1) as int : -1;

    final totalJugadores = jugadores.length;
    final respondieron = jugadores.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return ((data['respuestaIndice'] ?? -1) as int) != -1;
    }).length;

    // Cierre automático: se acabó el tiempo o respondieron todos (solo en 'jugando').
    if (!revelando && esAnfitrion && indiceActual != _indiceAutoCerrado) {
      final debeCerrar = restantes <= 0 ||
          (totalJugadores > 0 && respondieron >= totalJugadores);
      if (debeCerrar) {
        _indiceAutoCerrado = indiceActual;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cerrarPregunta(partidaId);
        });
      }
    }

    final letras = ['A', 'B', 'C', 'D'];
    final respuestas = (pregunta['answers'] ?? []) as List<dynamic>;

    return Container(
      color: Color(0xFF020818),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Color(0xFF00A3FF),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () async {
                          await _salirDePartida(partidaId, uid: uid);
                          if (context.mounted) {
                            FFAppState().update(() {
                              FFAppState().isOnlineMode = false;
                              FFAppState().partidaId = '';
                            });
                            context.goNamed('HomePage');
                          }
                        },
                        child: Icon(Icons.home, color: Colors.white, size: 50),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: revelando
                            ? Color(0xFF10233D)
                            : (restantes <= 5
                                ? Color(0xFF4A1414)
                                : Color(0xFF10233D)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: revelando
                              ? Color(0xFF5E6F87)
                              : (restantes <= 5
                                  ? Colors.redAccent
                                  : Color(0xFF5E6F87)),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        revelando ? 'Revelando…' : '$restantes s',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: jugadores.map((doc) {
                      final jd = doc.data() as Map<String, dynamic>;
                      final esYo = doc.id == uid;
                      return Container(
                        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: esYo ? Color(0xFF10233D) : Color(0xFF0B1730),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: esYo ? Color(0xFFFFD54F) : Color(0xFF5E6F87),
                            width: esYo ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${jd['nombre'] ?? ''}: ${jd['puntos'] ?? 0}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:
                                esYo ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                child: LinearPercentIndicator(
                  percent: totalPreguntas == 0
                      ? 0.0
                      : (numeroPreguntaActual / totalPreguntas).clamp(0.0, 1.0),
                  lineHeight: 25,
                  animation: true,
                  animateFromLastPercent: true,
                  progressColor: Color(0xFF00A3FF),
                  backgroundColor: Color(0xFF263142),
                  center: Text(
                    'Pregunta $numeroPreguntaActual de $totalPreguntas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 5),
                  ),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    (pregunta['question'] ?? '') as String,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              ...List.generate(4, (i) {
                final texto =
                    i < respuestas.length ? respuestas[i].toString() : '';
                final seleccionada = miRespuesta == i;

                Color borde;
                double anchoBorde;
                if (revelando) {
                  final esCorrecta = i == correctIndex;
                  final esMiFallida = miRespuesta == i && !esCorrecta;
                  borde = esCorrecta
                      ? Color(0xFF00FF06)
                      : (esMiFallida ? Colors.redAccent : Color(0xFF5E6F87));
                  anchoBorde = (esCorrecta || esMiFallida) ? 4 : 3;
                } else {
                  borde = seleccionada ? Color(0xFFFFD54F) : Color(0xFF5E6F87);
                  anchoBorde = seleccionada ? 4 : 3;
                }

                final tapHabilitado =
                    !revelando && !yaRespondio && restantes > 0;

                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: tapHabilitado
                        ? () async {
                            await enviarRespuesta(partidaId, i);
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Color(0xFF10233D),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borde, width: anchoBorde),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFFEDEDED),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                letras[i],
                                style: TextStyle(
                                  color: Color(0xFF1C2D47),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(14, 5, 10, 5),
                              child: Text(
                                texto,
                                style: TextStyle(
                                  color: Color(0xFFD3D3D6),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 24),
                child: Text(
                  (!revelando && yaRespondio)
                      ? 'Respuesta enviada. Esperando al resto…'
                      : ' ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Ventana de revelación (correcta + puntos por jugador)
  // ---------------------------------------------------------------------
  void _mostrarDialogoRevelacion(
    BuildContext context,
    String partidaId,
    int indiceOriginal,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('partidas')
              .doc(partidaId)
              .snapshots(),
          builder: (context, partidaSnap) {
            if (!partidaSnap.hasData || !partidaSnap.data!.exists) {
              return const SizedBox.shrink();
            }
            final data = partidaSnap.data!.data() as Map<String, dynamic>;
            final estadoActual = (data['estado'] ?? '') as String;
            final indiceActualAhora = (data['indiceActual'] ?? 0) as int;

            if (estadoActual != 'revelando' ||
                indiceActualAhora != indiceOriginal) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.of(dialogCtx).canPop()) {
                  Navigator.of(dialogCtx).pop();
                }
              });
              return const SizedBox.shrink();
            }

            final preguntas = (data['preguntas'] ?? []) as List<dynamic>;
            final pregunta =
                (indiceActualAhora >= 0 && indiceActualAhora < preguntas.length)
                    ? preguntas[indiceActualAhora] as Map<String, dynamic>
                    : <String, dynamic>{};
            final correctIndex = (pregunta['correctIndex'] ?? -1) as int;
            final respuestas = (pregunta['answers'] ?? []) as List<dynamic>;
            final textoCorrecta =
                (correctIndex >= 0 && correctIndex < respuestas.length)
                    ? respuestas[correctIndex].toString()
                    : '';
            final esUltima = indiceActualAhora + 1 >= preguntas.length;
            final uidPropio = FirebaseAuth.instance.currentUser?.uid ?? '';
            final esAnfitrion = data['anfitrionUid'] == uidPropio;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('partidas')
                  .doc(partidaId)
                  .collection('jugadores')
                  .orderBy('puntos', descending: true)
                  .snapshots(),
              builder: (context, jugadoresSnap) {
                final jugadores = jugadoresSnap.data?.docs ?? [];

                return Dialog(
                  backgroundColor: Color(0xFF050C18),
                  insetPadding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Color(0xFFFFD54F), width: 2),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 340),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'RESPUESTA CORRECTA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFF10233D),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Color(0xFF00FF06), width: 2),
                            ),
                            child: Text(
                              textoCorrecta,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Puntos de esta ronda',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView(
                              shrinkWrap: true,
                              children: jugadores.map((doc) {
                                final jd = doc.data() as Map<String, dynamic>;
                                final ganados = (jd['puntosRonda'] ?? 0) as int;
                                final total = (jd['puntos'] ?? 0) as int;
                                final acerto = ganados > 0;
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        acerto
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: acerto
                                            ? Color(0xFF00FF06)
                                            : Colors.redAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          (jd['nombre'] ?? '') as String,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        '+$ganados',
                                        style: TextStyle(
                                          color: acerto
                                              ? Color(0xFF00FF06)
                                              : Colors.white38,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '($total)',
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (esAnfitrion)
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                await avanzarPregunta(partidaId);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFD54F),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  esUltima
                                      ? 'VER RESULTADOS FINALES'
                                      : 'SIGUIENTE PREGUNTA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF020818),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          else
                            Text(
                              'Esperando al anfitrión…',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // TERMINADA
  // ---------------------------------------------------------------------
  Widget _buildTerminada(
    BuildContext context,
    String partidaId,
    List<QueryDocumentSnapshot> jugadores,
  ) {
    final ordenados = [...jugadores]..sort((a, b) {
        final pa = ((a.data() as Map<String, dynamic>)['puntos'] ?? 0) as int;
        final pb = ((b.data() as Map<String, dynamic>)['puntos'] ?? 0) as int;
        return pb.compareTo(pa);
      });

    return Container(
      color: Color(0xFF020818),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PARTIDA TERMINADA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFD54F),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: ordenados.length,
                  itemBuilder: (context, index) {
                    final data =
                        ordenados[index].data() as Map<String, dynamic>;
                    final esGanador = index == 0;
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFF10233D),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              esGanador ? Color(0xFFFFD54F) : Color(0xFF5E6F87),
                          width: esGanador ? 3 : 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (esGanador)
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                              child: Icon(Icons.emoji_events,
                                  color: Color(0xFFFFD54F), size: 22),
                            ),
                          Text('${index + 1}.',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 15)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              (data['nombre'] ?? '') as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${data['puntos'] ?? 0} pts',
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  FFAppState().update(() {
                    FFAppState().isOnlineMode = false;
                    FFAppState().partidaId = '';
                  });
                  context.goNamed('HomePage');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'VOLVER AL INICIO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF020818),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------
  Widget _mensajeCentrado(String mensaje) {
    return Container(
      color: Color(0xFF020818),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          mensaje,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  int _segundosRestantes(Map<String, dynamic> partidaData) {
    final total = (partidaData['segundosPorPregunta'] ?? 20) as int;
    final abiertaEn = partidaData['preguntaAbiertaEn'];
    DateTime? inicio;
    if (abiertaEn is Timestamp) {
      inicio = abiertaEn.toDate();
    } else if (abiertaEn is DateTime) {
      inicio = abiertaEn;
    }
    if (inicio == null) return total;
    final transcurrido = DateTime.now().difference(inicio).inSeconds;
    final restante = total - transcurrido;
    return restante < 0 ? 0 : restante;
  }

  Future<void> _salirDePartida(String partidaId, {String? uid}) async {
    final miUid = uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (partidaId.isEmpty || miUid == null || miUid.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('partidas')
          .doc(partidaId)
          .collection('jugadores')
          .doc(miUid)
          .update({'activo': false, 'salidaEn': DateTime.now()});
    } catch (_) {}
  }
}
