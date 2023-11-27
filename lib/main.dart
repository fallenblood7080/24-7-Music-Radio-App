import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp_radio/radio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    await windowManager.setSize(const Size(430, 932));
    await windowManager.setResizable(false);
    await windowManager.setAspectRatio(9/16);
    await windowManager.setMaximizable(false);
    await windowManager.setTitle("");
  }

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
