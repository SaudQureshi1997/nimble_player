import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nimble_player/models/Song.dart';

class MainListItem extends StatelessWidget {
  final Song song;
  final bool isActive;
  final Function onTap;
  final TextStyle boldWhite = TextStyle(color: Colors.white);

  MainListItem(this.song, this.isActive, this.onTap);

  @override
  Widget build(BuildContext context) {
    var image = song.albumCover.isEmpty
        ? AssetImage(Song.defaultAlbumCover)
        : FileImage(File(song.albumCover));

    var actionIcon = song.playing
        ? Icon(
            Icons.pause_circle_outline,
            color: isActive ? Colors.white: Colors.white54,
          )
        : Icon(
            Icons.play_circle_outline,
            color: isActive ? Colors.white: Colors.white54,
          );

    return ListTile(
        selected: isActive,
        key: ValueKey(song.id),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: image,
                  fit:
                      song.albumCover.isEmpty ? BoxFit.fitWidth : BoxFit.cover),
              borderRadius: BorderRadius.circular(10)),
        ),
        title: Text(
          song.shortTitle,
          style: isActive ? boldWhite : Theme.of(context).textTheme.subhead,
        ),
        subtitle: Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              song.albumName,
              style: isActive ? boldWhite.copyWith(fontSize: 14) : Theme.of(context).textTheme.caption,
            ),
            Icon(
              Icons.brightness_1,
              size: 6,
            ),
            Text(
              song.durationInSeconds.toStringAsFixed(2),
              style: isActive ? boldWhite.copyWith(fontSize: 14) : Theme.of(context).textTheme.caption,
            )
          ],
        ),
        trailing: actionIcon,
        onTap: onTap);
  }
}
