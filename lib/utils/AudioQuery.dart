
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:nimble_player/main.dart';
import 'package:nimble_player/models/Song.dart';

class AudioQuery {
  final FlutterAudioQuery query = FlutterAudioQuery();

  Future<List<Song>> loadSongs() async {
    List<SongInfo> songList = await query.getSongs(sortType: SongSortType.DISPLAY_NAME);
    songList = songList
        .where((song) => song.isMusic == true)
        .where((song) => int.parse(song.duration) > 1000 * 30)
        .toList();

    return compute(parseSongInfo, songList);
  }
}