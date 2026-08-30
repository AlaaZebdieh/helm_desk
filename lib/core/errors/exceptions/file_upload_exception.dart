import 'package:equatable/equatable.dart';

class FileUploadException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const FileUploadException({this.code, this.msg, this.data});

  @override
  List<Object?> get props => [code, msg, data];
}
