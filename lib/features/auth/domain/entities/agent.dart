import 'package:equatable/equatable.dart';

class Agent extends Equatable {
  final String id;
  final String name;
  final String email;

  const Agent({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];
}
