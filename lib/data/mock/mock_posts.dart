import '../models/post.dart';

final mockPosts = [
  Post(
    id: 'post1',
    userId: '1',
    petId: '1',
    text: 'Eu sou o dono do sofá agora.',
    pet_name: 'Buddy.',
    image: 'assets/dog1.jpg',
    audioUrl: 'assets/audio/bark1.mp3',
    date: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Post(
    id: 'post2',
    userId: '2',
    petId: '2',
    text: 'Você me serve. Não se esqueça disso.',
    pet_name: 'Lucky.',
    image: 'assets/cat1.jpg',
    audioUrl: 'assets/audio/meow1.mp3',
    date: DateTime.now().subtract(const Duration(hours: 1)),
  ),
];
