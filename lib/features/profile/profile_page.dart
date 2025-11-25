import 'package:flutter/material.dart';
import '../../../data/mock/mock_users.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUsers.first; // mock do usuário logado

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editprofile', arguments: user);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              //backgroundImage: AssetImage(user.pet.photo),
            ),
            const SizedBox(height: 10),
           // Text(user.pet.name,
           //     style:
           //         const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            //Text(user.pet.species),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${user.followers} Seguidores"),
                const SizedBox(width: 20),
                Text("${user.following} Seguindo"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
