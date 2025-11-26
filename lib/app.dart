import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/auth/selectuser_page.dart';
import 'features/feed/feed_page.dart';
import 'features/create_post/new_translation_page.dart';
import 'features/explore/explore_page.dart';
import 'features/messages/chat_list_page.dart';
import 'features/profile/profile_page.dart';
import 'data/models/user.dart';

class PetTalksApp extends StatelessWidget {
  final User defaultUser;
  const PetTalksApp({super.key, required this.defaultUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetTalks',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: '/selectUser',
      routes: {
        '/selectUser': (_) => const UserSelectionPage(),
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
    );
  }
}
