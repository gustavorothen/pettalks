import 'package:flutter/material.dart';
import '../../data/mock/mock_posts.dart';
import '../../data/models/post.dart';
import 'widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [...mockPosts];

  void goToNewTranslation() async {
    final result =
        await Navigator.pushNamed(context, '/new'); 

    if (result is String) {
      // criando novo post mock
      final newPost = Post(
        id: DateTime.now().toString(),
        userId: '1',
        text: result,
        image: 'assets/dog1.jpg',
        date: DateTime.now(),
      );

      setState(() {
        posts.insert(0, newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.mic, color: Colors.white),
        onPressed: goToNewTranslation,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, i) => PostCard(post: posts[i]),
      ),
    );
  }
}
