import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nimble_player/main.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/utils/AudioQuery.dart';

class PlayList extends ChangeNotifier {
  final AudioQuery audioQuery = AudioQuery();
  AudioPlayer player;
  List<int> songIds = List<int>();
  List<Song> songs = List<Song>();
  bool isLoading = true;
  Song currentlyPlaying;
  int currentlyPlayingId = -1;

  PlayList() {
    player = AudioPlayer();
    player.onPlayerCompletion.listen((_) {
      sleep(Duration(seconds: 2));
      playNext();
    });
    loadSongs();
  }

  Song findById(int id) {
    return songs.firstWhere((song) => song.id == id);
  }

  void findByNameAsStream(String name, Sink sink) async {
    name = name.toLowerCase();
    List<Song> matchedSongs = List<Song>();
    for (var song in songs) {
      bool matched = song.title.toLowerCase().contains(name) ||
          song.albumName.toLowerCase().contains(name) ||
          song.artistName.toLowerCase().contains(name);
      if (matched){
        matchedSongs.add(song);
        sink.add(matchedSongs);
      }
    }
  }

  Future<void> loadSongs() async {
    List<Song> songs = await audioQuery.loadSongs();
    for (var song in songs) {
      addSong(song);
    }
    if (songs.length > 0 && currentlyPlayingId == -1) {
      setCurrentSong(songs.first.id);
    }
    loading = false;
  }

  Future<void> switchSong(int id) async {
    if ((currentlyPlaying?.playing ?? false) && currentlyPlayingId == id) {
      await pauseSong();
      return;
    }
    await playSong(id);
  }

  get loading => isLoading;

  set loading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setCurrentSong(int id) {
    currentlyPlayingId = id;
    currentlyPlaying = findById(id);
    notifyListeners();
  }

  void addSong(Song song) {
    if (songIds.contains(song.id) == true) {
      return;
    }
    songIds.add(song.id);
    songs.add(song);
    notifyListeners();
  }

  Future<void> playSong(int id, [bool silent = true]) async {
    if (currentlyPlaying?.playing ?? false) {
      currentlyPlaying.stop();
    }
    currentlyPlayingId = id;
    currentlyPlaying = findById(id);
    player.onAudioPositionChanged.listen((Duration duration) {
      currentlyPlaying.playingAt(duration.inMilliseconds);
      notifyListeners();
    });
    currentlyPlaying.play();
    await player.play(currentlyPlaying.path, isLocal: true);
    if (!silent) {
      notifyListeners();
    }
  }

  Future<void> pauseSong() async {
    currentlyPlaying.pause();
    await player.pause();
    notifyListeners();
  }

  Future<void> stopSong() async {
    currentlyPlaying.playingAt(0);
    currentlyPlaying.stop();
    await player.stop();
    notifyListeners();
  }

  Future<void> toggleSong() async {
    if (currentlyPlaying == null) {
      return;
    }

    if (currentlyPlaying.paused) {
      currentlyPlaying.play();
      await player.resume();
      notifyListeners();
      return;
    }
    if (currentlyPlaying.stopped) {
      playSong(currentlyPlayingId);
      notifyListeners();
      return;
    }

    pauseSong();
    notifyListeners();
  }

  Future<void> playNext() async {
    stopSong();
    int currentIndex = songIds.indexOf(currentlyPlayingId);
    if (currentIndex == songs.length - 1) {
      await playSong(songs.elementAt(0).id);
      notifyListeners();
      return;
    }

    currentlyPlayingId = songIds.elementAt(currentIndex + 1);
    currentlyPlaying = findById(currentlyPlayingId);
    currentlyPlaying.play();
    await player.play(currentlyPlaying.path);
    notifyListeners();
  }

  Future<void> playPrevious() async {
    stopSong();
    int currentIndex = songIds.indexOf(currentlyPlayingId);
    if (currentIndex == 0 || currentlyPlaying.playedDuration > 5000) {
      restart();
      return;
    }

    currentlyPlayingId = songIds.elementAt(currentIndex - 1);
    currentlyPlaying = findById(currentlyPlayingId);
    currentlyPlaying.play();
    await player.play(currentlyPlaying.path);
    notifyListeners();
  }

  Future<void> restart() async {
    stopSong();
    await player.seek(Duration(seconds: 0));
    await player.play(currentlyPlaying.path);
    currentlyPlaying.play();
    return;
  }

  Future<void> playFrom(int duration) async {
    await player.seek(Duration(milliseconds: duration));
    currentlyPlaying.playingAt(duration.floor().toInt());
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
