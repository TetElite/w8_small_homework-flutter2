import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;

  bool isLoading = false;
  Object? error;
  List<Song>? songs;

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    //loading state
    isLoading = true;
    error = null;
    songs = null;
    notifyListeners();

    try {
      // 1 - Fetch songs
      songs = await songRepository.fetchSongs();
      error = null;
    } catch (e) {
      // Handle error state
      error = e;
      songs = null;
    } finally {
      isLoading = false;
    }

    // 2 - notify listeners
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
