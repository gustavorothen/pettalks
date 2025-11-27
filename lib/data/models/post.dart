class Post {
  final String id;
  final String userId;
  final String petId;
  final String text; // tradução engraçada
  final String pet_name; // nome animal
  final String
  image; // pode ser asset ("assets/dog1.jpg") ou arquivo local ("/data/...")
  final String? audioUrl; // caminho do áudio gravado
  final DateTime date;

  bool isLiked;
  int likes;

  Post({
    required this.id,
    required this.userId,
    required this.petId,
    required this.text,
    required this.pet_name,
    required this.image,
    this.audioUrl,
    required this.date,
    this.isLiked = false,
    this.likes = 0,
  });
}
