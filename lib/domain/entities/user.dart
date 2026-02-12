import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, name, email, profileImageUrl];
}
