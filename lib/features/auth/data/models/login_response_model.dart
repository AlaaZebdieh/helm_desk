import 'package:equatable/equatable.dart';

import 'agent_model.dart';

class LoginResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final AgentModel agent;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.agent,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      agent: AgentModel.fromJson(json['agent'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, agent];
}
