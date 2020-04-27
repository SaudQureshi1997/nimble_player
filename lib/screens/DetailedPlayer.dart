import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nimble_player/models/PlayList.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:provider/provider.dart';

class DetailedPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark
            ])),
        child: Consumer<PlayList>(builder: (context, playList, child) {
          Song song = playList.currentlyPlaying;
          return Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: cover(context, song),
              ),
              Expanded(
                  flex: 2,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: details(context, song),
                      ),
                      controls(context, playList)
                    ],
                  ))
            ],
          );
        }),
      ),
    );
  }

  Widget cover(BuildContext context, Song song) {
    ImageProvider image = song.albumCover.isEmpty
        ? AssetImage(Song.defaultAlbumCover)
        : FileImage(File(song.albumCover));
    return Hero(
      tag: 'SONG_IMAGE',
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
      ),
    );
  }

  Widget details(BuildContext context, Song song) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Wrap(
            spacing: 10,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                song.title,
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                song.albumName,
                style: Theme.of(context).textTheme.subhead,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget controls(BuildContext context, PlayList playList) {
    Song song = playList.currentlyPlaying;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.white70,
            min: 0.0,
            max: song.duration.toDouble(),
            value: song.playedDuration.toDouble(),
            onChangeEnd: (double duration) async {
              await playList.resumeSong();
            },
            onChangeStart: (double duration) async {
              await playList.pauseSong();
            },
            onChanged: (double duration) {
              playList.playFrom(duration.ceil());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(song.playedDurationInSeconds.toStringAsFixed(2)),
              Text(song.durationInSeconds.toStringAsFixed(2)),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    size: 35,
                  ),
                  onPressed: playList.playPrevious),
              IconButton(
                  icon: Icon(
                    song.playing ? Icons.pause : Icons.play_arrow,
                    size: 35,
                  ),
                  onPressed: playList.toggleSong),
              IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    size: 35,
                  ),
                  onPressed: playList.playNext)
            ],
          )
        ],
      ),
    );
  }
}
