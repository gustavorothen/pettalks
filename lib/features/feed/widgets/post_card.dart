import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/models/post.dart';
import '../../../data/mock/mock_users.dart';
import '../../../data/models/user.dart';
import 'package:audioplayers/audioplayers.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User? currentUser;
  final VoidCallback onToggleLike;

  const PostCard({
    super.key,
    required this.post,
    this.currentUser,
    required this.onToggleLike,
  });

  void _openComments(BuildContext context) {
    final commentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Comentários (mock)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentCtrl,
                decoration: const InputDecoration(
                  hintText: "Escreva um comentário...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Comentário enviado (mock)!")),
                  );
                },
                child: const Text("Enviar"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decide qual usuário mostrar
    late final User user;
    if (currentUser != null && currentUser!.id == post.userId) {
      user = currentUser!;
    } else {
      user = mockUsers.firstWhere(
        (u) => u.id == post.userId,
        orElse: () => mockUsers.first,
      );
    }

    // Decide se a imagem é asset ou arquivo local
    final bool isAsset = post.image.startsWith('assets/');
    final Widget imageWidget = isAsset
        ? Image.asset(post.image, width: 90, height: 90, fit: BoxFit.cover)
        : Image.file(
            File(post.image),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.pet_name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(post.text, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: onToggleLike,
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.red : Colors.black,
                        size: 22,
                      ),
                    ),
                    Text('${post.likes}'),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _openComments(context),
                      icon: const Icon(Icons.chat_bubble_outline, size: 22),
                    ),
                    const SizedBox(width: 8),
                    if (post.audioUrl != null) // só mostra se tiver áudio
                      IconButton(
                        onPressed: () async {
                          final player = AudioPlayer();
                          await player.play(DeviceFileSource(post.audioUrl!));
                        },
                        icon: const Icon(
                          Icons.headphones,
                          size: 28,
                          color: Colors.blueGrey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
