import 'package:flutter/material.dart';
import '../../data/mock/mock_posts.dart';
import '../../data/models/post.dart';
import '../../data/models/user.dart';
import 'widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  final User? currentUser;

  const FeedPage({super.key, this.currentUser});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    posts = [...mockPosts];
  }

  Future<void> goToNewTranslation() async {
    final result = await Navigator.pushNamed(context, '/new');

    if (result is Map && result['text'] != null) {
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.currentUser?.id ?? '1',
        text: result['text'] as String,
        image: widget.currentUser?.pet.photo ?? 'assets/dog1.jpg',
        audioUrl: result['audio'] as String?,
        date: DateTime.now(),
      );

      setState(() {
        posts.insert(0, newPost);
      });
    }
  }

  void _toggleLikeFor(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNewTranslation,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, i) {
          final post = posts[i];
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            currentUser: widget.currentUser,
            onToggleLike: () => _toggleLikeFor(post),
          );
        },
      ),
    );
  }
}
