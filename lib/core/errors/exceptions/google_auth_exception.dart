import 'package:equatable/equatable.dart';

class GoogleAuthException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const GoogleAuthException({this.code, this.msg, this.data});

  @override
  List<Object?> get props => [code, msg, data];
}
