class RadioData {
  final String nowplayingTitle;
  final String nowPlayingArtist;
  final String nowPlayingCoverSrc;
  final String totalListeners;
  final int totalDur;
  final int elapsed;
  final String nextplayingTitle;
  final String nextPlayingArtist;
  final String nextPlayingCoverSrc;

  RadioData(
      {required this.nowplayingTitle,
      required this.nowPlayingArtist,
      required this.nowPlayingCoverSrc,
      required this.totalListeners,
      required this.totalDur,
      required this.elapsed,
      required this.nextplayingTitle,
      required this.nextPlayingArtist,
      required this.nextPlayingCoverSrc});
}
