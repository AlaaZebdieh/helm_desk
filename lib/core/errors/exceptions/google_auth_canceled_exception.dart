import 'package:equatable/equatable.dart';

class GoogleAuthCanceledException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const GoogleAuthCanceledException({this.code, this.msg, this.data});

  @override
  List<Object?> get props => [code, msg, data];
}
