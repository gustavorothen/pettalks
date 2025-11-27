import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

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
  String base64Image = '';
  Future pickPetPhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      final bytes = await File(photo.path).readAsBytes();
      final base64 = base64Encode(bytes);

      setState(() {
        petImage = photo;
        base64Image = base64; // ✅ agora atualiza imediatamente
      });
    }
  }

  // Future<String> convertImageToBase64(XFile image) async {
  //   final bytes = await File(image.path).readAsBytes();
  //   return base64Encode(bytes);
  // }

  Future<String> saveImagePermanently(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();

    final String newPath =
        "${directory.path}/pet_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final File newImage = await File(image.path).copy(newPath);

    return newImage.path; // ✅ caminho permanente
  }

  /// ✅ Envia a foto para o Firebase Storage e retorna a URL pública
  // Future<String> uploadPetPhoto(File file) async {
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final fileRef = storageRef.child(
  //     "pets/${DateTime.now().millisecondsSinceEpoch}.jpg",
  //   );

  //   await fileRef.putFile(file);

  //   return await fileRef.getDownloadURL();
  // }

  void continueToApp() async {
    if (ownerController.text.isEmpty ||
        petController.text.isEmpty ||
        speciesController.text.isEmpty ||
        petImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Complete tudo!')));
      return;
    }

    try {
      final db = FirebaseFirestore.instance;

      // ✅ 1. Faz upload da foto e pega a URL
      //final photoUrl = await uploadPetPhoto(File(petImage!.path));
      //base64Image = await convertImageToBase64(petImage!);

      // ✅ 2. Cria o pet com a URL da foto
      final petDoc = await db.collection('pet').add({
        'name': petController.text,
        'species': speciesController.text,
        'photo': base64Image, // ✅ agora salva a URL do Storage
      });

      // ✅ 3. Cria o usuário vinculado ao pet
      final userDoc = await db.collection('user').add({
        'name': ownerController.text,
        'pet_id': petDoc.id,
        'followers': 0,
        'following': 0,
      });

      // ✅ 4. Cria objeto User para passar ao Feed
      final user = User(
        id: userDoc.id,
        name: ownerController.text,
        pet_id: petDoc.id,
        followers: 0,
        following: 0,
      );

      Navigator.pushReplacementNamed(context, '/feed', arguments: user);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar no banco: $e')));
    }

    //Navigator.pushReplacementNamed(context, '/feed', arguments: user);
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
                    ? MemoryImage(base64Decode(base64Image))
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
