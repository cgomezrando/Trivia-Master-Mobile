import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<String> _selectedThemes = [];
  List<String> get selectedThemes => _selectedThemes;
  set selectedThemes(List<String> value) {
    _selectedThemes = value;
  }

  void addToSelectedThemes(String value) {
    selectedThemes.add(value);
  }

  void removeFromSelectedThemes(String value) {
    selectedThemes.remove(value);
  }

  void removeAtIndexFromSelectedThemes(int index) {
    selectedThemes.removeAt(index);
  }

  void updateSelectedThemesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedThemes[index] = updateFn(_selectedThemes[index]);
  }

  void insertAtIndexInSelectedThemes(int index, String value) {
    selectedThemes.insert(index, value);
  }

  String _gameMode = '';
  String get gameMode => _gameMode;
  set gameMode(String value) {
    _gameMode = value;
  }

  int _numberOfQuestions = 10;
  int get numberOfQuestions => _numberOfQuestions;
  set numberOfQuestions(int value) {
    _numberOfQuestions = value;
  }

  List<TriviaQuestionStruct> _questions = [];
  List<TriviaQuestionStruct> get questions => _questions;
  set questions(List<TriviaQuestionStruct> value) {
    _questions = value;
  }

  void addToQuestions(TriviaQuestionStruct value) {
    questions.add(value);
  }

  void removeFromQuestions(TriviaQuestionStruct value) {
    questions.remove(value);
  }

  void removeAtIndexFromQuestions(int index) {
    questions.removeAt(index);
  }

  void updateQuestionsAtIndex(
    int index,
    TriviaQuestionStruct Function(TriviaQuestionStruct) updateFn,
  ) {
    questions[index] = updateFn(_questions[index]);
  }

  void insertAtIndexInQuestions(int index, TriviaQuestionStruct value) {
    questions.insert(index, value);
  }

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;
  set currentQuestionIndex(int value) {
    _currentQuestionIndex = value;
  }

  List<PlayerStruct> _players = [];
  List<PlayerStruct> get players => _players;
  set players(List<PlayerStruct> value) {
    _players = value;
  }

  void addToPlayers(PlayerStruct value) {
    players.add(value);
  }

  void removeFromPlayers(PlayerStruct value) {
    players.remove(value);
  }

  void removeAtIndexFromPlayers(int index) {
    players.removeAt(index);
  }

  void updatePlayersAtIndex(
    int index,
    PlayerStruct Function(PlayerStruct) updateFn,
  ) {
    players[index] = updateFn(_players[index]);
  }

  void insertAtIndexInPlayers(int index, PlayerStruct value) {
    players.insert(index, value);
  }

  int _currentPlayerIndex = 0;
  int get currentPlayerIndex => _currentPlayerIndex;
  set currentPlayerIndex(int value) {
    _currentPlayerIndex = value;
  }

  List<PlayerStruct> _ranking = [];
  List<PlayerStruct> get ranking => _ranking;
  set ranking(List<PlayerStruct> value) {
    _ranking = value;
  }

  void addToRanking(PlayerStruct value) {
    ranking.add(value);
  }

  void removeFromRanking(PlayerStruct value) {
    ranking.remove(value);
  }

  void removeAtIndexFromRanking(int index) {
    ranking.removeAt(index);
  }

  void updateRankingAtIndex(
    int index,
    PlayerStruct Function(PlayerStruct) updateFn,
  ) {
    ranking[index] = updateFn(_ranking[index]);
  }

  void insertAtIndexInRanking(int index, PlayerStruct value) {
    ranking.insert(index, value);
  }

  int _numPlayers = 0;
  int get numPlayers => _numPlayers;
  set numPlayers(int value) {
    _numPlayers = value;
  }

  bool _isAuthenticating = true;
  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating(bool value) {
    _isAuthenticating = value;
  }

  String _partidaId = '';
  String get partidaId => _partidaId;
  set partidaId(String value) {
    _partidaId = value;
  }

  bool _isOnlineMode = false;
  bool get isOnlineMode => _isOnlineMode;
  set isOnlineMode(bool value) {
    _isOnlineMode = value;
  }
}
