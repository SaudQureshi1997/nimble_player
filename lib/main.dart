import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:nimble_player/models/PlayList.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/screens/MainList.dart';
import 'package:nimble_player/utils/Router.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

List<Song> parseSongInfo(List<SongInfo> songList) {
  List<Song> songs = List<Song>();
  for (SongInfo songInfo in songList) {
    Song song = Song(int.parse(songInfo.id),
        path: songInfo.filePath,
        title: songInfo.title,
        duration: int.parse(songInfo.duration),
        artistName: songInfo.artist,
        album: songInfo.album,
        albumCover: songInfo.albumArtwork);
    songs.add(song);
  }

  return songs;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlayList(),
      child: MaterialApp(
        title: 'Nimble Player',
        themeMode: ThemeMode.dark,
        theme: ThemeData(),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.grey.shade900,
            primaryColor: Color.fromRGBO(23, 29, 39, 1),
            primaryColorDark: Color.fromRGBO(14, 18, 21, 1),
            cardColor: Colors.grey.shade900,
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              color: Colors.grey.shade900,
            ),
            dividerColor: Colors.black12,
            iconTheme: IconThemeData(color: Colors.white, size: 20),
            textTheme: TextTheme(
              subhead: TextStyle(color: Colors.white70, fontSize: 17),
              caption: TextStyle(color: Colors.grey, fontSize: 14),
            )),
        onGenerateRoute: Router.generateRoutes,
        home: MainList(),
      ),
    );
  }
}
