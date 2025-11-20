import '../models/user.dart';
import '../models/pet.dart';

final mockUsers = [
  User(
    id: '1',
    name: 'Jake',
    pet: Pet(
      name: 'Buddy',
      species: 'Golden Retriever',
      photo: 'assets/dog1.jpg',
    ),
    followers: 24,
    following: 24,
  ),
  User(
    id: '2',
    name: 'Mary',
    pet: Pet(
      name: 'Whiskers',
      species: 'Gato',
      photo: 'assets/cat1.jpg',
    ),
    followers: 18,
    following: 30,
  ),
];
