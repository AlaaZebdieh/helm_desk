import 'package:equatable/equatable.dart';

/// استثناء عند مصادقة خاطئة
class UnauthorizedException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const UnauthorizedException([this.code, this.msg, this.data]);

  @override
  List<Object?> get props => [code, msg, data];
}
