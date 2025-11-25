import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/pet.dart';
import '../../data/models/user.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController petController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();

  XFile? petImage;

  Future pickPetPhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        petImage = photo;
      });
    }
  }

  void continueToApp() {
    if (ownerController.text.isEmpty ||
        petController.text.isEmpty ||
        speciesController.text.isEmpty ||
        petImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Complete tudo!')));
      return;
    }

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: ownerController.text,
      pet_id: 1,      
      followers: 0,
      following: 0,
    );

    Navigator.pushReplacementNamed(context, '/feed', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PetTalks - Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickPetPhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: petImage != null
                    ? FileImage(File(petImage!.path))
                    : null,
                child: petImage == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(labelText: 'Seu nome'),
            ),
            TextField(
              controller: petController,
              decoration: const InputDecoration(labelText: 'Nome do Pet'),
            ),
            TextField(
              controller: speciesController,
              decoration: const InputDecoration(labelText: 'Espécie do Pet'),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: continueToApp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
