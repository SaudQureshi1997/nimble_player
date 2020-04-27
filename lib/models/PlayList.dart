import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart' as ExoPlayer;
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/utils/AudioPlayer.dart';
import 'package:nimble_player/utils/AudioQuery.dart';

class PlayList extends ChangeNotifier {
  final AudioQuery audioQuery = AudioQuery();
  final AudioPlayer player = AudioPlayer();
  List<int> songIds = List<int>();
  List<Song> songs = List<Song>();
  bool isLoading = true;
  Song currentlyPlaying;
  int currentlyPlayingId = -1;

  PlayList() {
    player.onPlayerCompletion.listen((_) {
      sleep(Duration(seconds: 2));
      playNext();
    });
    player.onAudioPositionChanged.listen((Duration duration) {
      currentlyPlaying.playingAt(duration.inMilliseconds);
      notifyListeners();
    });
    player.onNotificationActionCallback.listen((notificationActionName) {
      switch (notificationActionName) {
        case NotificationActionName.NEXT:
          playNext();
          break;
        case NotificationActionName.PREVIOUS:
          playPrevious();
          break;
        case NotificationActionName.PAUSE:
          pauseSong();
          break;
        case NotificationActionName.PLAY:
          resumeSong();
          break;
        default:
      }
    });

    player.onPlayerStateChanged.listen((state) {
      switch (state) {
        case ExoPlayer.PlayerState.PAUSED:
          currentlyPlaying.pause();
          break;
        case ExoPlayer.PlayerState.PLAYING:
          currentlyPlaying.play();
          break;
        case ExoPlayer.PlayerState.RELEASED:
        case ExoPlayer.PlayerState.STOPPED:
          currentlyPlaying.stop();
          break;
        case ExoPlayer.PlayerState.BUFFERING:
        case ExoPlayer.PlayerState.COMPLETED:
      }
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
      if (matched) {
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
    if (currentlyPlayingId == id) {
      await toggleSong();
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
    await stopSong();
    currentlyPlayingId = id;
    currentlyPlaying = findById(id);
    await player.play(currentlyPlaying);
    if (!silent) {
      notifyListeners();
    }
  }

  Future<void> resumeSong() async {
    await player.resume();
    return;
  }

  Future<void> pauseSong() async {
    await player.pause();
    notifyListeners();
  }

  Future<void> stopSong() async {
    currentlyPlaying?.playingAt(0);
    if (currentlyPlaying?.playing == true) {
      await player.stop();
    }
    notifyListeners();
  }

  Future<void> toggleSong() async {
    if (currentlyPlaying == null) {
      return;
    }

    if (currentlyPlaying.paused) {
      await player.resume();
      notifyListeners();
      return;
    }
    if (currentlyPlaying.stopped) {
      await playSong(currentlyPlayingId);
      notifyListeners();
      return;
    }

    await pauseSong();
    notifyListeners();
  }

  Future<void> playNext() async {
    int currentIndex = songIds.indexOf(currentlyPlayingId);
    if (currentIndex == songs.length - 1) {
      await playSong(songs.elementAt(0).id);
      notifyListeners();
      return;
    }

    currentlyPlayingId = songIds.elementAt(currentIndex + 1);
    currentlyPlaying = findById(currentlyPlayingId);
    await player.play(currentlyPlaying);
    notifyListeners();
  }

  Future<void> playPrevious() async {
    int currentIndex = songIds.indexOf(currentlyPlayingId);
    if (currentIndex == 0 || currentlyPlaying.playedDuration > 5000) {
      await restart();
      return;
    }

    currentlyPlayingId = songIds.elementAt(currentIndex - 1);
    currentlyPlaying = findById(currentlyPlayingId);
    await player.play(currentlyPlaying);
    notifyListeners();
  }

  Future<void> restart() async {
    await pauseSong();
    await player.seek(Duration(seconds: 0));
    toggleSong();
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
