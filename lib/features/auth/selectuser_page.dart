import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user.dart';

class UserSelectionPage extends StatefulWidget {
  const UserSelectionPage({super.key});
  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  User? selectedUser;
  String? selectedUserId;
  Future<List<User>> _fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('user').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return User(
        id: doc.id,
        name: data['name'],
        pet_id: data['pet_id'],
        followers: data['followers'],
        following: data['following'],
      );
    }).toList();
  }

  void _goToFeed(List<User> users) {
    if (selectedUserId != null) {
      final user = users.firstWhere((u) => u.id == selectedUserId);
      Navigator.pushReplacementNamed(context, '/feed', arguments: user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um usuário primeiro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu usuário')),
      body: FutureBuilder<List<User>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedUserId,
                  hint: const Text('Selecione um usuário'),
                  isExpanded: true,
                  items: users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(user.name),
                    );
                  }).toList(),
                  onChanged: (userId) {
                    setState(() {
                      selectedUserId = userId;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _goToFeed(users),
                  child: const Text('Entrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
