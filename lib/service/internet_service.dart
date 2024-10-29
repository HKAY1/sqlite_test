import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/db/db.dart';
import 'package:test_app/provider/notes_provider.dart';

class InternetConnectivity extends StateNotifier<bool> {
  InternetConnectivity._() : super(false);
  static final InternetConnectivity instance = InternetConnectivity._();
  bool isConnected = false;

  void initialize() {
    startListeningForInternetConnectivity();
  }

  final Connectivity _connectivity = Connectivity();

  List<ConnectivityResult>? _previousConnectivity;

  Future<void> startListeningForInternetConnectivity() async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    state = _isConnected(result);
    if (state) syncData();
    _showDialog(result);
    _connectivity.onConnectivityChanged.listen(_showDialog);
  }

  void _showDialog(List<ConnectivityResult> result) async {
    if (_isConnected(result)) {
      if (_previousConnectivity == null) return;
      if (_isConnected(_previousConnectivity!)) return;
      state = true;
      await syncData();
    } else {
      state = false;
    }

    _previousConnectivity = result;
  }

  bool _isConnected(List<ConnectivityResult> result) {
    isConnected = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);

    return isConnected;
  }

  bool connectionState() {
    return state;
  }

  Future<void> syncData() async {
    print("syncing data");
    AppDatabase noteDatabase = AppDatabase.instance;
    final notes = await noteDatabase.readAll1(true);
    for (int i = 0; i < notes.length; i++) {
      NotesProvider.instance.syncNote(notes[i]);
    }
  }
}

final internetProvider =
    StateNotifierProvider((ref) => InternetConnectivity._());
