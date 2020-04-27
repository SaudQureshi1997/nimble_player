import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nimble_player/models/PlayList.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/widgets/RoudedImage.dart';
import 'package:provider/provider.dart';

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<PlayList>(
      builder: (context, playList, child) {
        if (playList.currentlyPlayingId == -1) {
          return null;
        }

        return Positioned(
            bottom: 0,
            right: 0,
            child: Card(
              child: Container(
                width: width * 0.98,
                color: Colors.grey.shade900,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        splashColor: Colors.white,
                        highlightColor: Colors.white,
                        onTap: () => Navigator.pushNamed(context, 'show'),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: songDetails(playList),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: controls(playList),
                      ),
                    )
                  ],
                ),
              ),
            ),
        );
      });
  }

  Widget songDetails(PlayList playList) {
    ImageProvider image;
    Song song = playList.currentlyPlaying;
    if (song.albumCover.isNotEmpty) {
      image = FileImage(File(song.albumCover));
    } else {
      image = AssetImage(Song.defaultAlbumCover);
    }

    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Hero(
              tag: 'SONG_IMAGE',
              child: RoundedImage(
                image,
                heroTag: 'SONG_IMAGE',
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 3,
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: <Widget>[
              Text(song.title, overflow: TextOverflow.fade,),
              Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(song.albumName, overflow: TextOverflow.fade,),
                  Icon(Icons.brightness_1, color: Colors.white, size: 5,),
                  Text(song.durationInSeconds.toStringAsFixed(2), overflow: TextOverflow.fade,),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget controls(PlayList playList) {
    Song song = playList.currentlyPlaying;
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        actionButton(Icons.skip_previous, playList.playPrevious),
        actionButton(song.playing ? Icons.pause : Icons.play_arrow,
            playList.toggleSong),
        actionButton(Icons.skip_next, playList.playNext)
      ],
    );
  }

  Widget actionButton(IconData icon, Function callback, [double size = 20]) {
    return IconButton(
        onPressed: callback,
        icon: Icon(
          icon,
          size: size,
          color: Colors.white,
        ));
  }
}