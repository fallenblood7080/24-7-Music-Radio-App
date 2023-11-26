import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freecodecamp_radio/api_data.dart';
import 'package:freecodecamp_radio/bloc/radio_bloc.dart';
import 'package:freecodecamp_radio/colorpalette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class RadioPage extends StatefulWidget {
  final AudioPlayer player;
  const RadioPage({super.key, required this.player});
  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  late List<Color> currentPalette = ColorPalette.freecodecamp;
  final RadioBloc radioBloc = RadioBloc();

  @override
  void initState() {
    super.initState();
    radioBloc.add(RadioFetchEvent());
    setNewPalette();
  }

  void setNewPalette() {
    setState(() {
      currentPalette = ColorPalette.getNextColorpalette(currentPalette);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: currentPalette[1],
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "${ColorPalette.currentPaletteName(currentPalette)} Theme",
        style: GoogleFonts.poppins(fontSize: 16, color: currentPalette[3], fontWeight: FontWeight.w500),
        softWrap: true,
        overflow: TextOverflow.fade,
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: currentPalette[2],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      width: 200,
      margin: const EdgeInsets.all(0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RadioBloc, RadioState>(
      bloc: radioBloc,
      listenWhen: (prev, current) => current is RadioActionState,
      buildWhen: (prev, current) => current is! RadioActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case RadioFetchSuccessfulState:
            final success = state as RadioFetchSuccessfulState;
            return RadioUI(
              currentPalette: currentPalette,
              data: success.data,
              player: widget.player,
              radioBloc: radioBloc,
              setNewPalette: () {
                setNewPalette();
              },
            );
          default:
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [currentPalette[0], currentPalette[1]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.95],
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(color: currentPalette[2]),
              ),
            );
        }
      },
    );
  }
}

class RadioUI extends StatelessWidget {
  const RadioUI({
    super.key,
    required this.currentPalette,
    required this.data,
    required this.player,
    required this.radioBloc,
    required this.setNewPalette,
  });

  final List<Color> currentPalette;
  final RadioData data;
  final AudioPlayer player;
  final RadioBloc radioBloc;
  final Function setNewPalette;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(50, 0, 0, 0),
        elevation: 0,
        title: const Text("Radio"),
        titleTextStyle: GoogleFonts.poppins(color: currentPalette[2], fontSize: 24, fontWeight: FontWeight.w600),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setNewPalette();
            },
            icon: Icon(
              Icons.color_lens_rounded,
              size: 24,
              color: currentPalette[2],
            ),
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [currentPalette[0], currentPalette[1]], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [0, 0.95]),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: CoverImage(
                  data: data,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Expanded(
                flex: 1,
                child: PlayingNow(
                  currentPalette: currentPalette,
                  data: data,
                ),
              ),
              Expanded(
                flex: 1,
                child: CurrentPlayProgress(
                  currentPalette: currentPalette,
                  data: data,
                  player: player,
                  radioBloc: radioBloc,
                ),
              ),
              Expanded(
                flex: 1,
                child: NextPlaying(
                  currentPalette: currentPalette,
                  data: data,
                ),
              ),
              const SizedBox(
                height: 16,
              )
            ],
          )),
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.data,
  });

  final RadioData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data.nowPlayingCoverSrc)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 10,
            blurStyle: BlurStyle.normal,
            offset: Offset(0, 5),
          )
        ],
      ),
    );
  }
}

class NextPlaying extends StatelessWidget {
  const NextPlaying({
    super.key,
    required this.currentPalette,
    required this.data,
  });
  final RadioData data;
  final List<Color> currentPalette;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: currentPalette[1],
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 1,
                  blurRadius: 10,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(5, 5),
                )
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    data.nextPlayingCoverSrc,
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Playing Next",
                      style: GoogleFonts.poppins(fontSize: 20, color: currentPalette[2], fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      child: Text(
                        "\t\t${data.nextplayingTitle}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: currentPalette[3],
                        ),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        "\t\t${data.nextPlayingArtist}",
                        style: GoogleFonts.poppins(fontSize: 14, color: currentPalette[3]),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}

class PlayingNow extends StatelessWidget {
  const PlayingNow({
    super.key,
    required this.currentPalette,
    required this.data,
  });

  final List<Color> currentPalette;
  final RadioData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentPalette[1],
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 1,
              blurRadius: 10,
              blurStyle: BlurStyle.normal,
              offset: Offset(5, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\tNow Playing",
              style: GoogleFonts.poppins(fontSize: 24, color: currentPalette[2], fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              child: Text(
                "\t\t\t${data.nowplayingTitle}",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: currentPalette[3],
                ),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              child: Text(
                "\t\t\t${data.nowPlayingArtist}",
                style: GoogleFonts.poppins(fontSize: 16, color: currentPalette[3]),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentPlayProgress extends StatefulWidget {
  const CurrentPlayProgress({
    super.key,
    required this.currentPalette,
    required this.data,
    required this.player,
    required this.radioBloc,
  });

  final List<Color> currentPalette;
  final RadioData data;
  final AudioPlayer player;
  final RadioBloc radioBloc;

  @override
  State<CurrentPlayProgress> createState() => _CurrentPlayProgressState();
}

class _CurrentPlayProgressState extends State<CurrentPlayProgress> {
  double progressValue = 0.0;
  int elapsedSeconds = 0;
  int endDurationInSeconds = 0; // Adjust this based on your requirement
  late Timer timer;

  late IconData playIconData;
  late String playText;
  @override
  void initState() {
    super.initState();
    startTimer();
    playRadio();
  }

  void playRadio() {
    widget.player.play();
    setState(() {
      widget.radioBloc.add(RadioFetchEvent());
      playIconData = Icons.pause;
      playText = "Pause";
    });
    // AudioSource.uri(
    //   Uri.parse("https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3"),
    //   tag: MediaItem(
    //     id: '1',
    //     title: widget.data.nextplayingTitle,
    //     artist: widget.data.nowPlayingArtist,
    //     duration: Duration(seconds: widget.data.totalDur),
    //     artUri: Uri.parse(widget.data.nowPlayingCoverSrc),
    //   ),
    // );
  }

  void pauseRadio() {
    widget.player.pause();
    setState(() {
      playIconData = Icons.play_arrow_rounded;
      playText = "Play";
    });
  }

  void startTimer() {
    elapsedSeconds = widget.data.elapsed;
    endDurationInSeconds = widget.data.totalDur;
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        setState(() {
          widget.radioBloc.add(RadioFetchEvent());
          if (elapsedSeconds == endDurationInSeconds) {
            timer.cancel(); // Stop the timer when the elapsed time reaches the end duration
            startTimer();
          } else {
            elapsedSeconds++;
            progressValue = elapsedSeconds / endDurationInSeconds;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.currentPalette[1],
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 1,
              blurRadius: 10,
              blurStyle: BlurStyle.normal,
              offset: Offset(5, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            LinearProgressIndicator(
              value: progressValue,
              color: widget.currentPalette[2],
              borderRadius: BorderRadius.circular(8),
              minHeight: 8,
              backgroundColor: widget.currentPalette[0],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      if (widget.player.playing) {
                        pauseRadio();
                      } else {
                        playRadio();
                      }
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(widget.currentPalette[1])),
                    icon: Icon(
                      playIconData,
                      color: widget.currentPalette[2],
                      size: 36,
                    ),
                    label: Text(
                      playText,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 28, color: widget.currentPalette[3]),
                    )),
                Container(
                  width: 1,
                  height: 28,
                  decoration: const BoxDecoration(color: Colors.white24),
                ),
                ElevatedButton.icon(
                  onPressed: null,
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                  icon: Icon(
                    Icons.headphones_rounded,
                    color: widget.currentPalette[2],
                    size: 28,
                  ),
                  label: Text(
                    widget.data.totalListeners.toString(),
                    style: GoogleFonts.poppins(
                      color: widget.currentPalette[3],
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
