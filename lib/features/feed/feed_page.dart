import '../../data/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/mock/mock_posts.dart';
import '../../data/models/post.dart';
import '../../data/models/user.dart';
import 'widgets/post_card.dart';
import '../create_post/new_translation_page.dart';

class FeedPage extends StatefulWidget {
  final User currentUser;

  const FeedPage({super.key, required this.currentUser});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Post>> futurePosts;
  int _selectedIndex = 0;
  String filtro = '';

  void _onItemTapped(int index) {
    if (index == 0) {
      // já está na tela Feed
    } else if (index == 1) {
      goToNewTranslation();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePosts = _loadPosts();
  }

  Future<List<Post>> _loadPosts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('post')
        .orderBy('date', descending: true)
        .get();

    List<Post> posts = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // busca o pet relacionado
      final petId = data['pet_id'];
      String petName = '';
      String petPhoto = '';

      if (petId != null) {
        final petDoc = await FirebaseFirestore.instance
            .collection('pet')
            .doc(petId.toString())
            .get();
        if (petDoc.exists) {
          petName = petDoc['name'] ?? '';
          petPhoto = petDoc['photo'] ?? '';
        }
      }

      posts.add(
        Post(
          id: doc.id,
          userId: widget.currentUser.id,
          text: data['text'] ?? '',
          pet_name: petName,
          image: petPhoto,
          audioUrl: data['audio_url'],
          date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
          isLiked:
              (data['likedBy'] as List<dynamic>?)?.contains(
                widget.currentUser.id,
              ) ??
              false,
          likes: data['likesCount'] ?? 0,
        ),
      );
    }

    return posts;
  }

  // Future<void> goToNewTranslation() async {
  //   await Navigator.pushNamed(context, '/new');

  //   setState(() {
  //     futurePosts = _loadPosts(); // recarrega lista
  //   });
  // }

  Future<void> goToNewTranslation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewTranslationPage(currentUser: widget.currentUser),
      ),
    );

    if (result != null) {
      setState(() {
        futurePosts = _loadPosts();
      });
    }
  }

  // void _toggleLikeFor(Post post) async {
  //   setState(() {
  //     post.isLiked = !post.isLiked;
  //     post.likes += post.isLiked ? 1 : -1;
  //   });

  //   await FirebaseFirestore.instance.collection('post').doc(post.id).update({
  //     'isLiked': post.isLiked,
  //     'likes': post.likes,
  //   });
  // }
  void _toggleLikeFor(Post post) async {
    final postRef = FirebaseFirestore.instance.collection('post').doc(post.id);

    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });

    if (post.isLiked) {
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([widget.currentUser.id]),
        'likesCount': post.likes,
      });
    } else {
      await postRef.update({
        'likedBy': FieldValue.arrayRemove([widget.currentUser.id]),
        'likesCount': post.likes,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'logout') {
                // Navega para tela de seleção de usuário
                Navigator.pushReplacementNamed(context, '/selectUser');
              } else if (value == 'newUser') {
                // Navega para tela de login
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Sair')),
              const PopupMenuItem(
                value: 'newUser',
                child: Text('Novo Usuário'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar pets ou frases...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  filtro = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: futurePosts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final traducoes = snapshot.data!;
          final filtradas = traducoes.where((item) {
            final texto = '${item.pet_name} ${item.text}'.toLowerCase();
            return texto.contains(filtro);
          }).toList();
          return ListView.builder(
            itemCount: filtradas.length,
            itemBuilder: (_, i) {
              final post = filtradas[i];
              return PostCard(
                key: ValueKey(post.id),
                post: post,
                currentUser: widget.currentUser,
                onToggleLike: () => _toggleLikeFor(post),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Nova Tradução',
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Feed'),
  //       bottom: PreferredSize(
  //         preferredSize: const Size.fromHeight(70),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           child: TextField(
  //             decoration: InputDecoration(
  //               hintText: 'Pesquisar pets ou frases...',
  //               prefixIcon: const Icon(Icons.search),
  //               filled: true,
  //               fillColor: Colors.white,
  //               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(30),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //             onChanged: (value) {
  //               setState(() {
  //                 filtro = value.toLowerCase();
  //               });
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //     body: FutureBuilder(
  //       future: futurePosts,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         final traducoes = snapshot.data!;
  //         final filtradas = traducoes.where((item) {
  //           final texto = '${item.pet_name} ${item.text}'.toLowerCase();
  //           return texto.contains(filtro);
  //         }).toList();
  //         return ListView.builder(
  //           itemCount: filtradas.length,
  //           itemBuilder: (_, i) {
  //             final post = filtradas[i];
  //             return PostCard(
  //               key: ValueKey(post.id),
  //               post: post,
  //               currentUser: widget.currentUser,
  //               onToggleLike: () => _toggleLikeFor(post),
  //             );
  //           },
  //         );
  //         // return ListView.builder(
  //         //   itemCount: filtradas.length,
  //         //   itemBuilder: (context, index) {
  //         //     final item = filtradas[index];
  //         //     return Card(
  //         //       margin: const EdgeInsets.all(10),
  //         //       child: ListTile(
  //         //         leading: const Icon(Icons.pets, color: Colors.orange),
  //         //         title: Text('${item['animal_nome']}: ${item['frase']}'),
  //         //         subtitle: Text(item['data']),
  //         //       ),
  //         //     );
  //         //   },
  //         // );
  //       },
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: _selectedIndex,
  //       onTap: _onItemTapped,
  //       selectedItemColor: Colors.orange,
  //       items: const [
  //         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.mic),
  //           label: 'Nova Tradução',
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
