part of 'radio_bloc.dart';

@immutable
sealed class RadioState {}

abstract class RadioActionState extends RadioState{}

final class RadioInitial extends RadioState {}

class RadioFetchSuccessfulState extends RadioState{
  final RadioData data;

  RadioFetchSuccessfulState({required this.data});
}
