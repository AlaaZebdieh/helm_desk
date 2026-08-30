import 'package:equatable/equatable.dart';

/// استثناء عند خطأ غير متوقع
class UnknownException extends Equatable implements Exception {
  final int? code;
  final String? msg;
  final dynamic data;

  const UnknownException([this.code, this.msg, this.data]);

  @override
  List<Object?> get props => [code, msg, data];
}
