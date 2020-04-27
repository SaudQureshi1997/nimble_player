import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart' as ExoPlayer;
import 'package:nimble_player/models/Song.dart';

class AudioPlayer {
  ExoPlayer.AudioPlayer player;
  AudioPlayer() {
    player = ExoPlayer.AudioPlayer();
  }

  Stream<void> get onPlayerCompletion {
    return player.onPlayerCompletion;
  }

  Stream<Duration> get onAudioPositionChanged {
    return player.onAudioPositionChanged;
  }

  Stream<ExoPlayer.PlayerState> get onPlayerStateChanged {
    return player.onPlayerStateChanged;
  }

  Future<ExoPlayer.Result> play(Song song) {
    song.play();
    return player.play(
      song.path,
      respectAudioFocus: true,
      playerMode: ExoPlayer.PlayerMode.BACKGROUND,
    );
  }

  Future<ExoPlayer.Result> moveToBackGround(Song song) {
    song.pause();
    player.release();
    player.seekPosition(Duration(milliseconds: song.duration));
    return player.play(song.path,
        playerMode: ExoPlayer.PlayerMode.FOREGROUND,
        audioNotification: AudioNotification(
          smallIconFileName: "assets/images/thumder_64.png",
          title: song.title,
          subTitle: song.albumName,
          largeIconUrl: song.albumCover,
          isLocal: true,
        ));
  }

  Future<ExoPlayer.Result> pause(Song song) {
    song.pause();
    return player.pause();
  }

  Future<ExoPlayer.Result> seek(Duration duration) {
    return player.seekPosition(duration);
  }

  Future<ExoPlayer.Result> stop(Song song) {
    song.stop();
    return player.release();
  }

  Future<ExoPlayer.Result> resume(Song song) {
    song.play();
    return player.resume();
  }

  Future<void> dispose() {
    return player.dispose();
  }
}
