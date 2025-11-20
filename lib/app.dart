import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/feed/feed_page.dart';
import 'features/profile/profile_page.dart';
import 'features/create_post/new_translation_page.dart';
import 'features/explore/explore_page.dart';
import 'features/messages/chat_list_page.dart';

class PetTalksApp extends StatelessWidget {
  const PetTalksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetTalks',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/feed': (_) => const FeedPage(),
        '/new': (_) => const NewTranslationPage(),
        '/explore': (_) => const ExplorePage(),
        '/messages': (_) => const ChatListPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
