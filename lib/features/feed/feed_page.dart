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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('post')
          .orderBy('date', descending: true)
          .get();

      List<Post> posts = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // ✅ Garantir que pet_id é string
        final petId = data['pet_id']?.toString() ?? '';

        String petName = '';
        String petPhoto = '';
        String ownerUserId = '';

        // ✅ Buscar PET com proteção total
        if (petId.isNotEmpty) {
          try {
            final petDoc = await FirebaseFirestore.instance
                .collection('pet')
                .doc(petId)
                .get();

            if (petDoc.exists) {
              petName = petDoc.data()?['name']?.toString() ?? '';
              petPhoto = petDoc.data()?['photo']?.toString() ?? '';
            }
          } catch (e) {
            print("Erro ao buscar pet: $e");
          }

          // ✅ Buscar USER dono do pet com proteção total
          try {
            final userQuery = await FirebaseFirestore.instance
                .collection('user')
                .where('pet_id', isEqualTo: petId)
                .limit(1)
                .get();

            if (userQuery.docs.isNotEmpty) {
              ownerUserId = userQuery.docs.first.id;
            }
          } catch (e) {
            print("Erro ao buscar usuário do pet: $e");
          }
        }

        // ✅ Garantir que likedBy é lista
        final likedBy = (data['likedBy'] is List)
            ? List<String>.from(data['likedBy'])
            : <String>[];

        // ✅ Garantir que likesCount é número
        final likesCount = (data['likesCount'] is int) ? data['likesCount'] : 0;

        // ✅ Garantir que a data é válida
        DateTime date;
        try {
          date = DateTime.parse(data['date']);
        } catch (_) {
          date = DateTime.now();
        }

        // ✅ Criar o Post sem risco de erro
        posts.add(
          Post(
            id: doc.id,
            userId: ownerUserId,
            petId: petId,
            text: data['text']?.toString() ?? '',
            pet_name: petName,
            image: petPhoto,
            audioUrl: data['audio_base64']?.toString(),
            date: date,
            isLiked: likedBy.contains(widget.currentUser.id),
            likes: likesCount,
          ),
        );
      }

      return posts;
    } catch (e) {
      print("Erro geral ao carregar posts: $e");
      return []; // ✅ Nunca deixa o FutureBuilder travar
    }
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

    if (result == true) {
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
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                  arguments: widget.currentUser,
                );
              } else if (value == 'perfil') {
                // Navega para tela de login
                Navigator.pushReplacementNamed(
                  context,
                  '/profile',
                  arguments: widget.currentUser,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'newUser',
                child: Text('Novo Usuário'),
              ),
              const PopupMenuItem(value: 'perfil', child: Text('Perfil')),
              const PopupMenuItem(value: 'logout', child: Text('Sair')),
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
}
