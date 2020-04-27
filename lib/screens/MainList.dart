import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:nimble_player/models/PlayList.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/widgets/MainListItem.dart';
import 'package:nimble_player/widgets/Player.dart';
import 'package:nimble_player/widgets/SearchButton.dart';
import 'package:provider/provider.dart';

class MainList extends StatelessWidget {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PlayList>(builder: (context, playlist, child) {
          if (playlist.isLoading) {
            return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ])),
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent)));
          }
          if (playlist.songs.length == 0) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark
                  ])),
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                    Text(
                      "No music found",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
              color: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 70),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                          Theme.of(context).accentColor,
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark
                        ])),
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return Divider(
                            indent: 10,
                            endIndent: 10,
                          );
                        },
                        itemCount: playlist.songs.length,
                        itemBuilder: (context, index) {
                          Song song = playlist.songs.elementAt(index);
                          return MainListItem(
                              song,
                              playlist.currentlyPlayingId == song.id,
                              () async => await playlist.switchSong(song.id));
                        }),
                  ),
                  SearchButton(),
                  Player()
                ],
              ),
              onRefresh: playlist.loadSongs);
        }),
      ),
//      bottomNavigationBar: BottomNavigationBar(
//          selectedItemColor: Colors.white,
//          unselectedItemColor: Colors.white54,
//          showUnselectedLabels: false,
//          backgroundColor: Color.fromRGBO(14, 18, 21, 1),
//          currentIndex: 0,
//          items: [
//            BottomNavigationBarItem(
//                icon: Icon(Icons.music_note), title: Text("Music")),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.library_music), title: Text("PlayList")),
//          ]),
    );
  }
}
