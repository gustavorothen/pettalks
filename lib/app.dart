import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/feed/feed_page.dart';
import 'features/create_post/new_translation_page.dart';
import 'features/explore/explore_page.dart';
import 'features/messages/chat_list_page.dart';
import 'features/profile/profile_page.dart';
import 'data/models/user.dart';

class PetTalksApp extends StatelessWidget {
  const PetTalksApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usuário padrão para testes
    final defaultUser = User(
      id: '1',
      name: 'Usuario Padrão',
      pet_id: 1,
      followers: 10,
      following: 14,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetTalks',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: '/feed',
      routes: {
        '/login': (_) => const LoginPage(),
        '/feed': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final user = args is User ? args : defaultUser;
          return FeedPage(currentUser: user);
        },
        '/new': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final user = args is User ? args : defaultUser;
          return NewTranslationPage(currentUser: user);
        },
        '/explore': (_) => const ExplorePage(),
        '/messages': (_) => const ChatListPage(),
        '/profile': (_) => const ProfilePage(),
      },
      // aqui você injeta o argumento inicial
      onGenerateInitialRoutes: (initialRoute) {
        if (initialRoute == '/feed') {
          return [
            MaterialPageRoute(
              builder: (context) => FeedPage(currentUser: defaultUser),
              settings: const RouteSettings(name: '/feed'),
            ),
          ];
        }
        return [];
      },
    );
  }
}
