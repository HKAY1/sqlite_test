import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test_app/db/db.dart';
import 'package:test_app/models/synced_notes_model.dart';

class InternetConnectivity {
  InternetConnectivity._();
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
    _showDialog(result);
    _connectivity.onConnectivityChanged.listen(_showDialog);
  }

  void _showDialog(List<ConnectivityResult> result) async {
    if (_isConnected(result)) {
      if (_previousConnectivity == null) return;
      if (_isConnected(_previousConnectivity!)) return;

      await syncData();
    } else {}

    _previousConnectivity = result;
  }

  bool _isConnected(List<ConnectivityResult> result) {
    isConnected = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
    return isConnected;
  }

  Future<void> syncData() async {
    print("syncing data");
    AppDatabase noteDatabase = AppDatabase.instance;
    final notes = await noteDatabase.readAll1(true);
    for (int i = 0; i < notes.length; i++) {
      final SyncedNotesModel note = SyncedNotesModel(
          title: notes[i].title,
          content: notes[i].content,
          isFavorite: notes[i].isFavorite,
          createdTime: DateTime.now(),
          number: i);
      await noteDatabase.syncCreate(note);
      final newNote = notes[i].copyWith(isSynced: true);
      await noteDatabase.update(newNote);
    }
  }
}
