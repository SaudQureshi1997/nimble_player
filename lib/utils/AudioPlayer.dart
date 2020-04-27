import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart' as ExoPlayer;
import 'package:nimble_player/models/Song.dart';

class AudioPlayer {
  ExoPlayer.AudioPlayer player;
  AudioPlayer() {
    player = ExoPlayer.AudioPlayer();
    player.onPlayerError.listen((message) => print("Error: $message"));
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

  Stream<NotificationActionName> get onNotificationActionCallback {
    return player.onNotificationActionCallback;
  }

  Future<ExoPlayer.Result> play(Song song, {Duration position}) async {
    return player.play(song.path,
        respectAudioFocus: true,
        playerMode: ExoPlayer.PlayerMode.FOREGROUND,
        position: position,
        audioNotification: AudioNotification(
          smallIconFileName: '@mipmap/ic_launcher',
          title: song.title,
          subTitle: song.albumName,
          largeIconUrl: song.albumCover,
          isLocal: true,
          notificationActionCallbackMode: NotificationActionCallbackMode.CUSTOM,
          notificationDefaultActions: NotificationDefaultActions.ALL,
        ));
  }

  Future<ExoPlayer.Result> pause() {
    return player.pause();
  }

  Future<ExoPlayer.Result> seek(Duration duration) {
    return player.seekPosition(duration);
  }

  Future<ExoPlayer.Result> stop() {
    return player.release();
  }

  Future<ExoPlayer.Result> resume() {
    return player.resume();
  }

  Future<void> dispose() {
    return player.dispose();
  }
}
