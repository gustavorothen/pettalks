import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Mary', 'photo': 'assets/cat1.jpg', 'msg': 'Oi, tudo bem?'},
      {'name': 'Jake', 'photo': 'assets/dog1.jpg', 'msg': '🐶 Woof!'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Mensagens")),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(chats[i]['photo']!),
          ),
          title: Text(chats[i]['name']!),
          subtitle: Text(chats[i]['msg']!),
          onTap: () => Navigator.pushNamed(context, '/chat',
              arguments: chats[i]),
        ),
      ),
    );
  }
}
