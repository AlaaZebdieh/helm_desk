import 'package:equatable/equatable.dart';

import '../../domain/entities/agent.dart';

class AgentModel extends Equatable {
  final String id;
  final String name;
  final String email;

  const AgentModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Agent toEntity() => Agent(id: id, name: name, email: email);

  @override
  List<Object?> get props => [id, name, email];
}
