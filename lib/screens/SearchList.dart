import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nimble_player/models/PlayList.dart';
import 'package:nimble_player/models/Song.dart';
import 'package:nimble_player/widgets/MainListItem.dart';
import 'package:provider/provider.dart';

class SearchList extends StatefulWidget {
  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController;
  AnimationController motionController;
  CurvedAnimation animation;
  double iconSize = 30;
  String searchText;
  StreamController streamController;
  var _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    searchText = '';
    searchController = TextEditingController();
    motionController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800), lowerBound: 0.8);
    animation =
        CurvedAnimation(parent: motionController, curve: Curves.bounceInOut);
    motionController.forward();
    motionController.addStatusListener((status) {
      if (AnimationStatus.completed == status) {
        setState(() {
          motionController.reverse();
        });
      }
      if (AnimationStatus.dismissed == status) {
        setState(() {
          motionController.forward();
        });
      }
    });
    motionController.addListener(() {
      setState(() {
        iconSize = motionController.value * 40;
      });
    });
  }

  Future<void> search(String text) async {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      searchText = text;
    });
    Provider.of<PlayList>(_key.currentContext, listen: false).findByNameAsStream(text, streamController.sink);
  }

  @override
  void dispose() {
    searchController.dispose();
    motionController.dispose();
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayList>(
        key: _key,
        builder: (context, playlist, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme
                    .of(context)
                    .primaryColorDark,
                leading: IconButton(icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)),
                title: searchBar(playlist),
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme
                              .of(context)
                              .accentColor,
                          Theme
                              .of(context)
                              .primaryColor,
                          Theme
                              .of(context)
                              .primaryColorDark
                        ])),
                child: StreamBuilder(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData ? list(snapshot.data, playlist) : emptyBody();
                  },
                ),
              )
          );
        }
    );
  }

  Widget emptyBody() {
    return Container(
      child: Center(
          child: Icon(
        Icons.music_note,
        color: Colors.white,
        size: iconSize,
      )),
    );
  }

  Widget searchBar(playlist) {
    return TextField(
      controller: searchController,
      onSubmitted: search,
      cursorColor: Colors.white,
      cursorWidth: 1.5,
      cursorRadius: Radius.circular(1),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: "Enter song name to search",
          hintStyle: TextStyle(color: Colors.white70),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  WidgetsBinding.instance.addPostFrameCallback( (_) => searchController.clear());
                });
              })),
    );
  }

  Widget list(List<Song>songs, PlayList playlist) {
    motionController.stop();
    return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (BuildContext context, index) {
          Song song = songs.elementAt(index);
          print('rebuilding');
      return MainListItem(
        song, playlist.currentlyPlayingId == song.id, () {
          playlist.playSong(song.id);
          Navigator.pop(context);
      }
      );
    });
  }
}
