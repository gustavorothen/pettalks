import 'dart:convert';

import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../data/models/pet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final User currentUser;

  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Pet?> _Pets() async {
    final petDoc = await FirebaseFirestore.instance
        .collection('pet')
        .doc(widget.currentUser.pet_id)
        .get();

    if (petDoc.exists) {
      final data = petDoc.data()!;
      return Pet(
        //id: petDoc.id,
        name: data['name'],
        species: data['species'],
        photo: data['photo'],
      );
    }
    return null;
  }

  ImageProvider _buildPetImage(Pet petData) {
    final photo = petData.photo;

    // ✅ Se for Base64
    if (photo != null && photo.toString().startsWith('/9j') ||
        photo.toString().contains('base64')) {
      try {
        return MemoryImage(base64Decode(photo));
      } catch (_) {
        return const AssetImage('assets/dog1.jpg');
      }
    }

    // ✅ Se for um asset salvo no Firestore (ex: 'assets/dog2.jpg')
    if (photo.toString().startsWith('assets/')) {
      return AssetImage(photo);
    }

    // ✅ fallback final
    return const AssetImage('assets/dog1.jpg');
  }

  @override
  Widget build(BuildContext context) {
    //final user = mockUsers.first; // mock do usuário logado

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(
            context,
            '/feed',
            arguments: widget.currentUser,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/editprofile',
                arguments: widget.currentUser,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Pet?>(
        future: _Pets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final pet = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: pet != null
                      ? _buildPetImage(
                          pet,
                        ) // se você salvou como caminho em assets
                      : null,
                  child: pet == null ? const Icon(Icons.pets, size: 40) : null,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.currentUser.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (pet != null) ...[
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    pet.species,
                    style: const TextStyle(fontSize: 22, color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "${widget.currentUser.followers}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Seguidores",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        Text(
                          "${widget.currentUser.following}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Seguindo",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
