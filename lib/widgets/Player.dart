import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nimble_player/models/PlayList.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/widgets/RoudedImage.dart';
import 'package:provider/provider.dart';

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<PlayList>(
      builder: (context, playlist, child) {
        if (playlist.currentlyPlayingId == -1) {
          return null;
        }
        Song song = playlist.currentlyPlaying;
        var image = song.albumCover.isEmpty
            ? AssetImage(Song.defaultAlbumCover)
            : FileImage(File(song.albumCover));

        return Positioned(
            bottom: 0,
            right: 0,
            child: Card(
              child: Container(
                padding: EdgeInsets.all(5),
                height: 70,
                width: width / 1.02,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundedImage(image),
                    SizedBox(
                      width: (40/100)*width,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, 'show'),
                        child: Wrap(
                          direction: Axis.vertical,
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: <Widget>[
                            Text(
                              song.title,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                            ),
                            Wrap(
                              spacing: 6,
                              alignment: WrapAlignment.center,
                              children: <Widget>[
                                Icon(Icons.access_time, size: 12,),
                                Text(
                                  song.durationInSeconds.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        actionButton(Icons.skip_previous, playlist.playPrevious),
                        actionButton(song.playing ? Icons.pause : Icons.play_arrow,
                            playlist.toggleSong),
                        actionButton(Icons.skip_next, playlist.playNext)
                      ],
                    )
                  ],
                ),
              ),
            )
        );
      }
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