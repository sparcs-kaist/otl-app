import 'package:equatable/equatable.dart';

abstract class Time extends Equatable {
  final int day;
  final int begin;
  final int end;

  Time({this.day, this.begin, this.end});

  @override
  List<Object> get props => [day, begin, end];
}
