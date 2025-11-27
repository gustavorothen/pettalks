import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/models/post.dart';
import '../../../data/mock/mock_users.dart';
import '../../../data/models/user.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

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

  /// ✅ Converte Base64 em arquivo temporário para tocar
  Future<String> _createTempAudioFile(String base64Audio, String postId) async {
    final bytes = base64Decode(base64Audio);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/audio_$postId.m4a");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Decide qual usuário mostrar
    late final User user;
    if (currentUser != null && currentUser!.id == post.userId) {
      user = currentUser!;
    } else {
      user = mockUsers.firstWhere(
        (u) => u.id == post.userId,
        orElse: () => mockUsers.first,
      );
    }

    // ✅ Decide se a imagem é asset ou Base64
    final bool isAsset = post.image.startsWith('assets/');
    final Widget imageWidget = isAsset
        ? Image.asset(post.image, width: 90, height: 90, fit: BoxFit.cover)
        : Image.memory(
            base64Decode(post.image),
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

          // ✅ Conteúdo do post
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

                // ✅ Ícones sem overflow
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
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

                    IconButton(
                      onPressed: () => _openComments(context),
                      icon: const Icon(Icons.chat_bubble_outline, size: 22),
                    ),

                    // ✅ Botão de áudio (Base64)
                    if (post.audioUrl != null)
                      IconButton(
                        onPressed: () async {
                          try {
                            final tempPath = await _createTempAudioFile(
                              post.audioUrl!,
                              post.id,
                            );

                            final player = AudioPlayer();
                            await player.play(DeviceFileSource(tempPath));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Erro ao tocar áudio: $e"),
                              ),
                            );
                          }
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
