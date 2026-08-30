import 'package:equatable/equatable.dart';

class FileDownloadException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const FileDownloadException({this.code, this.msg, this.data});

  @override
  List<Object?> get props => [code, msg, data];
}
