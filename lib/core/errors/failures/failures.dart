import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// فئة أب أساسية لجميع الأخطاء
abstract class Failure extends Equatable {
  final int? code;
  final String? msg;
  final dynamic data;

  Failure({this.code, this.msg, this.data}) {
    debugPrint("Failure: $msg");
  }

  @override
  List<Object?> get props => [code, msg, data];
}
