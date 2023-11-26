import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freecodecamp_radio/api_data.dart';
import 'package:meta/meta.dart';

part 'radio_event.dart';
part 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  RadioBloc() : super(RadioInitial()) {
    on<RadioFetchEvent>(radioFetchEvent);
  }

  FutureOr<void> radioFetchEvent(RadioFetchEvent event, Emitter<RadioState> emit) async {
    RadioData data;
    try {
      final response = await Dio(BaseOptions(headers: {
        "Access-Control-Allow-Origin":"*"
      })).get("https://coderadio-admin.freecodecamp.org/api/nowplaying");
      List<Map<String, dynamic>> radioData = List<Map<String, dynamic>>.from(response.data);
      data = RadioData(
        nowplayingTitle: radioData[0]['now_playing']['song']['title'].toString(),
        nowPlayingArtist: radioData[0]['now_playing']['song']['artist'].toString(),
        nowPlayingCoverSrc: radioData[0]['now_playing']['song']['art'].toString(),
        totalListeners: radioData[0]['listeners']['total'].toString(),
        totalDur: radioData[0]['now_playing']['duration'],
        elapsed: radioData[0]['now_playing']['elapsed'],
        nextplayingTitle: radioData[0]['playing_next']['song']['title'].toString(),
        nextPlayingArtist: radioData[0]['playing_next']['song']['artist'].toString(),
        nextPlayingCoverSrc: radioData[0]['playing_next']['song']['art'].toString(),
      );
      emit(RadioFetchSuccessfulState(data: data));
    } catch (e) {
      log(e.toString());
    }
  }
}
