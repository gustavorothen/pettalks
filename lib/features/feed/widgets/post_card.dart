import 'package:flutter/material.dart';
import '../../../data/models/post.dart';
import '../../../data/mock/mock_users.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = mockUsers.firstWhere((u) => u.id == post.userId);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              post.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.pet.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  post.text,
                  style: const TextStyle(fontSize: 14),
                ),
                Row(
                  children: const [
                    Icon(Icons.favorite_border),
                    SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
