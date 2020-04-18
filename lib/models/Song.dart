enum SongState { PLAYING, PAUSED, STOPPED }

class Song {
  static const String defaultAlbumCover = 'assets/images/record.png';

  int _id;
  String _title;
  String _path;
  int _duration;
  String _album;
  String _albumCover;
  String _artistName;
  SongState _state = SongState.STOPPED;
  int _playedDuration = 0;

  Song(int id,
      {String path,
      String title,
      int duration,
      String artistName,
      String album,
      String albumCover}) {
    this._id = id;
    this._path = path ?? '';
    this._title = title ?? '';
    this._duration = duration ?? 0;
    this._album = album ?? '';
    this._albumCover = albumCover ?? '';
    this._artistName = artistName ?? '';
  }

  void play() {
    _state = SongState.PLAYING;
  }

  void pause() {
    _state = SongState.PAUSED;
  }

  void stop() {
    playingAt(0);
    _state = SongState.STOPPED;
  }

  void playingAt(int milliseconds) {
    _playedDuration = milliseconds;
  }

  int get id {
    return _id;
  }

  bool get playing {
    return _state == SongState.PLAYING;
  }

  bool get stopped {
    return _state == SongState.STOPPED;
  }

  bool get paused {
    return _state == SongState.PAUSED;
  }

  String get albumName {
    if (_album.isNotEmpty) {
      return _album.length > 30 ? _album.substring(0, 30) + '...' : _album;
    }

    return _artistName.length > 30
        ? _artistName.substring(0, 30) + '...'
        : _artistName;
  }

  double get durationInSeconds {
    return (_duration / 1000) / 60;
  }

  int get duration {
    return _duration;
  }

  String get albumCover {
    return _albumCover;
  }

  String get title {
    return _title;
  }

  String get shortTitle {
    return _title.length > 40 ? _title.substring(0, 40) + '...' : _title;
  }

  String get shorterTitle {
    return _title.length > 20 ? _title.substring(0, 20) + '...' : _title;
  }

  int get playedDuration {
    return _playedDuration;
  }

  double get playedDurationInSeconds {
    return (_playedDuration / 1000) / 60;
  }

  String get path {
    return _path;
  }

  String get artistName {
    return _artistName;
  }
}
