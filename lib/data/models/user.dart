import 'pet.dart';

class User {
  final String id;
  final String name; // Nome do dono
  final int pet_id; // Pet do usuário
  final int followers;
  final int following;

  User({
    required this.id,
    required this.name,
    required this.pet_id,
    this.followers = 0,
    this.following = 0,
  });
}
