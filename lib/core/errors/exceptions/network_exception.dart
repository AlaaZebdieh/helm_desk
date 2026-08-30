import 'package:equatable/equatable.dart';

/// استثناء عند انعدام الاتصال بالانترنت
class NetworkException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const NetworkException([this.code, this.msg, this.data]);

  @override
  List<Object?> get props => [code, msg, data];
}
