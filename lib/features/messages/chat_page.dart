import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msgCtrl = TextEditingController();
  List<String> msgs = ["Olá!", "Como está seu pet hoje?"];

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Map?;

    return Scaffold(
      appBar: AppBar(
        title: Text(user?['name'] ?? "Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: msgs.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(msgs[i]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: const InputDecoration(
                        hintText: "Mensagem..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    setState(() {
                      msgs.add(msgCtrl.text);
                    });
                    msgCtrl.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
