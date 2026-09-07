import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isAuthenticating = true;
      safeSetState(() {});
      await actions.loginAnonimoFirebase();
      FFAppState().isAuthenticating = false;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF646467),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Background.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment(0.0, -1.0),
                ),
              ),
              if (MediaQuery.of(context).orientation == Orientation.portrait)
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 180.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().numPlayers = 1;
                                FFAppState().isOnlineMode = false;
                                FFAppState().gameMode = '\'individual\'';
                                safeSetState(() {});
                              },
                              child: Container(
                                width: 100.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF050C18),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 30.0,
                                      color: Colors.black,
                                      offset: Offset(
                                        0.0,
                                        8.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                  border: Border.all(
                                    color: valueOrDefault<Color>(
                                      (FFAppState().numPlayers == 1) &&
                                              (FFAppState().isOnlineMode ==
                                                  false)
                                          ? Color(0xFFFFD54F)
                                          : Color(0xFF182544),
                                      Color(0xFF182544),
                                    ),
                                    width: valueOrDefault<double>(
                                      (FFAppState().numPlayers == 1) &&
                                              (FFAppState().isOnlineMode ==
                                                  false)
                                          ? 6.0
                                          : 4.0,
                                      4.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/1jugador.png',
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      'INDIVIDUAL',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  FFAppState().isOnlineMode = true;
                                  FFAppState().gameMode = '\'online\'';
                                  safeSetState(() {});
                                  await actions.showMultiplayerSetup(
                                    context,
                                  );
                                },
                                child: Container(
                                  width: 100.0,
                                  height: 75.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF050C18),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 30.0,
                                        color: Colors.black,
                                        offset: Offset(
                                          0.0,
                                          8.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    border: Border.all(
                                      color: valueOrDefault<Color>(
                                        FFAppState().isOnlineMode == true
                                            ? Color(0xFFFFD54F)
                                            : Color(0xFF182544),
                                        Color(0xFF182544),
                                      ),
                                      width: valueOrDefault<double>(
                                        FFAppState().isOnlineMode == true
                                            ? 6.0
                                            : 4.0,
                                        4.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/multijugador.png',
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        'MULTIJUGADOR',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50.0,
                                height: 3.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 10.0, 0.0),
                                  child: Text(
                                    'ELIGE UNA CATEGORÍA',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFFDCE4FF),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 0.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 50.0,
                                height: 3.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (functions.listContains(
                                      FFAppState().selectedThemes.toList(),
                                      'FUTBOL')) {
                                    FFAppState()
                                        .removeFromSelectedThemes('FUTBOL');
                                    safeSetState(() {});
                                  } else {
                                    FFAppState().addToSelectedThemes('FUTBOL');
                                    safeSetState(() {});
                                  }
                                },
                                child: Container(
                                  width: 100.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF050C18),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 30.0,
                                        color: Colors.black,
                                        offset: Offset(
                                          0.0,
                                          8.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    border: Border.all(
                                      color: valueOrDefault<Color>(
                                        functions.listContains(
                                                FFAppState()
                                                    .selectedThemes
                                                    .toList(),
                                                'FUTBOL')
                                            ? Color(0xFFFFD54F)
                                            : Color(0xFF182544),
                                        Color(0xFF182544),
                                      ),
                                      width: valueOrDefault<double>(
                                        functions.listContains(
                                                FFAppState()
                                                    .selectedThemes
                                                    .toList(),
                                                'FUTBOL')
                                            ? 6.0
                                            : 4.0,
                                        4.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Futbol.png',
                                          width: 75.0,
                                          height: 75.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        'FÚTBOL',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions.listContains(
                                        FFAppState().selectedThemes.toList(),
                                        'MUNDIALES')) {
                                      FFAppState().removeFromSelectedThemes(
                                          'MUNDIALES');
                                      safeSetState(() {});
                                    } else {
                                      FFAppState()
                                          .addToSelectedThemes('MUNDIALES');
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF050C18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 30.0,
                                          color: Colors.black,
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      border: Border.all(
                                        color: valueOrDefault<Color>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'MUNDIALES')
                                              ? Color(0xFFFFD54F)
                                              : Color(0xFF182544),
                                          Color(0xFF182544),
                                        ),
                                        width: valueOrDefault<double>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'MUNDIALES')
                                              ? 6.0
                                              : 4.0,
                                          4.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/mundiales.png',
                                            width: 75.0,
                                            height: 75.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          'HISTORIA MUNDIALES',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions.listContains(
                                        FFAppState().selectedThemes.toList(),
                                        'HISTORIA DE ESPAÑA')) {
                                      FFAppState().removeFromSelectedThemes(
                                          'HISTORIA DE ESPAÑA');
                                      safeSetState(() {});
                                    } else {
                                      FFAppState().addToSelectedThemes(
                                          'HISTORIA DE ESPAÑA');
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF050C18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 30.0,
                                          color: Colors.black,
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      border: Border.all(
                                        color: valueOrDefault<Color>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'HISTORIA DE ESPAÑA')
                                              ? Color(0xFFFFD54F)
                                              : Color(0xFF182544),
                                          Color(0xFF182544),
                                        ),
                                        width: valueOrDefault<double>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'HISTORIA DE ESPAÑA')
                                              ? 6.0
                                              : 4.0,
                                          4.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/espaa_1.png',
                                            width: 75.0,
                                            height: 75.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          'HISTORIA DE ESPAÑA',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await actions.showSecundariaDialog(
                                    context,
                                  );
                                },
                                child: Container(
                                  width: 100.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF050C18),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 30.0,
                                        color: Colors.black,
                                        offset: Offset(
                                          0.0,
                                          8.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    border: Border.all(
                                      color: valueOrDefault<Color>(
                                        functions.containsAnyEso(FFAppState()
                                                .selectedThemes
                                                .toList())
                                            ? Color(0xFFFFD54F)
                                            : Color(0xFF182544),
                                        Color(0xFF182544),
                                      ),
                                      width: valueOrDefault<double>(
                                        functions.containsAnyEso(FFAppState()
                                                .selectedThemes
                                                .toList())
                                            ? 6.0
                                            : 4.0,
                                        4.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Secundaria-removebg-preview.png',
                                          width: 75.0,
                                          height: 75.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        'SECUNDARIA',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions.listContains(
                                        FFAppState().selectedThemes.toList(),
                                        'Cuerpo humano')) {
                                      FFAppState().removeFromSelectedThemes(
                                          'Cuerpo humano');
                                      safeSetState(() {});
                                    } else {
                                      FFAppState()
                                          .addToSelectedThemes('Cuerpo humano');
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF050C18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 30.0,
                                          color: Colors.black,
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      border: Border.all(
                                        color: valueOrDefault<Color>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'Cuerpo humano')
                                              ? Color(0xFFFFD54F)
                                              : Color(0xFF182544),
                                          Color(0xFF182544),
                                        ),
                                        width: valueOrDefault<double>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'Cuerpo humano')
                                              ? 6.0
                                              : 4.0,
                                          4.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/Esqueleto-removebg-preview.png',
                                            width: 75.0,
                                            height: 75.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          'CUERPO HUMANO',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions.listContains(
                                        FFAppState().selectedThemes.toList(),
                                        'INVENTORES')) {
                                      FFAppState().removeFromSelectedThemes(
                                          'INVENTORES');
                                      safeSetState(() {});
                                    } else {
                                      FFAppState()
                                          .addToSelectedThemes('INVENTORES');
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF050C18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 30.0,
                                          color: Colors.black,
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      border: Border.all(
                                        color: valueOrDefault<Color>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'INVENTORES')
                                              ? Color(0xFFFFD54F)
                                              : Color(0xFF182544),
                                          Color(0xFF182544),
                                        ),
                                        width: valueOrDefault<double>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'INVENTORES')
                                              ? 6.0
                                              : 4.0,
                                          4.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/Inventores-removebg-preview.png',
                                            width: 75.0,
                                            height: 75.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          'INVENTORES',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (functions.listContains(
                                      FFAppState().selectedThemes.toList(),
                                      'MADRIDISTA')) {
                                    FFAppState()
                                        .removeFromSelectedThemes('MADRIDISTA');
                                    safeSetState(() {});
                                  } else {
                                    FFAppState()
                                        .addToSelectedThemes('MADRIDISTA');
                                    safeSetState(() {});
                                  }
                                },
                                child: Container(
                                  width: 100.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF050C18),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 30.0,
                                        color: Colors.black,
                                        offset: Offset(
                                          0.0,
                                          8.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    border: Border.all(
                                      color: valueOrDefault<Color>(
                                        functions.listContains(
                                                FFAppState()
                                                    .selectedThemes
                                                    .toList(),
                                                'MADRIDISTA')
                                            ? Color(0xFFFFD54F)
                                            : Color(0xFF182544),
                                        Color(0xFF182544),
                                      ),
                                      width: valueOrDefault<double>(
                                        functions.listContains(
                                                FFAppState()
                                                    .selectedThemes
                                                    .toList(),
                                                'MADRIDISTA')
                                            ? 6.0
                                            : 4.0,
                                        4.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/realmadrid.png',
                                          width: 75.0,
                                          height: 75.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        'EL MÁS MADRIDISTA',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions.listContains(
                                        FFAppState().selectedThemes.toList(),
                                        'BARCELONISTA')) {
                                      FFAppState().removeFromSelectedThemes(
                                          'BARCELONISTA');
                                      safeSetState(() {});
                                    } else {
                                      FFAppState()
                                          .addToSelectedThemes('BARCELONISTA');
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF050C18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 30.0,
                                          color: Colors.black,
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      border: Border.all(
                                        color: valueOrDefault<Color>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'BARCELONISTA')
                                              ? Color(0xFFFFD54F)
                                              : Color(0xFF182544),
                                          Color(0xFF182544),
                                        ),
                                        width: valueOrDefault<double>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'BARCELONISTA')
                                              ? 6.0
                                              : 4.0,
                                          4.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 8.0, 0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/barcelona.png',
                                              width: 65.0,
                                              height: 65.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'EL MÁS CULÉ',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions.listContains(
                                        FFAppState().selectedThemes.toList(),
                                        'REGUETON')) {
                                      FFAppState()
                                          .removeFromSelectedThemes('REGUETON');
                                      safeSetState(() {});
                                    } else {
                                      FFAppState()
                                          .addToSelectedThemes('REGUETON');
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF050C18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 30.0,
                                          color: Colors.black,
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      border: Border.all(
                                        color: valueOrDefault<Color>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'REGUETON')
                                              ? Color(0xFFFFD54F)
                                              : Color(0xFF182544),
                                          Color(0xFF182544),
                                        ),
                                        width: valueOrDefault<double>(
                                          functions.listContains(
                                                  FFAppState()
                                                      .selectedThemes
                                                      .toList(),
                                                  'REGUETON')
                                              ? 6.0
                                              : 4.0,
                                          4.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/Regueton.png',
                                            width: 75.0,
                                            height: 75.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          'EL SABIO DE REGGAETON',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (FFAppState().gameMode == '\'online\'') {
                                    await actions.showMultiplayerSetup(
                                      context,
                                    );
                                  } else {
                                    if (FFAppState().gameMode ==
                                        '\'individual\'') {
                                      await actions.startGame(
                                        context,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Elige un modo: individual o multijugador.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 2000),
                                          backgroundColor: Color(0xFF182544),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  width: 200.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0D1F47),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 22.0,
                                        color: Color(0xFF4D7CFF),
                                        offset: Offset(
                                          0.0,
                                          4.0,
                                        ),
                                        spreadRadius: 2.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    border: Border.all(
                                      color: Color(0xFF4D7CFF),
                                      width: 4.0,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'JUGAR',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            fontSize: 32.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
