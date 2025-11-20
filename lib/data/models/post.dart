class Post {
  final String id;
  final String userId;
  final String text;       // Tradução engraçada
  final String image;      // Foto do pet
  final String? audioUrl;  // Caminho do áudio gravado
  final DateTime date;

  Post({
    required this.id,
    required this.userId,
    required this.text,
    required this.image,
    this.audioUrl,
    required this.date,
  });
}
