import 'package:equatable/equatable.dart';

/// استثناء عام للـ API
class ServerException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const ServerException([this.code, this.msg, this.data]);

  @override
  List<Object?> get props => [code, msg, data];
}
