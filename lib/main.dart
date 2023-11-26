import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp_radio/radio.dart';
import 'package:just_audio/just_audio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final player = AudioPlayer();
  await player.setUrl("https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3");
  runApp(MainApp(
    player: player,
  ));
}

class MainApp extends StatelessWidget {
  final AudioPlayer player;
  const MainApp({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RadioPage(
        player: player,
      ),
    );
  }
}
