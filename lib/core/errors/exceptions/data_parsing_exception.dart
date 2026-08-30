import 'package:equatable/equatable.dart';

class DataParsingException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const DataParsingException({this.code, this.msg, this.data});

  @override
  List<Object?> get props => [code, msg, data];
}
