import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/database/database.dart';
import '../../data/models/user.dart';

class NewTranslationPage extends StatefulWidget {
  final User currentUser;

  const NewTranslationPage({super.key, required this.currentUser});

  @override
  State<NewTranslationPage> createState() => _NewTranslationPageState();
}

class _NewTranslationPageState extends State<NewTranslationPage> {
  final _record = AudioRecorder();
  bool isRecording = false;
  String? recordedPath;
  final textCtrl = TextEditingController();
  Map<String, dynamic>? petData;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    try {
      final petDoc = await FirebaseFirestore.instance
          .collection('pet')
          .doc(
            widget.currentUser.pet_id,
          ) // aqui o pet_id deve ser o ID do documento no Firestore
          .get();

      if (petDoc.exists) {
        setState(() {
          petData = petDoc.data(); // retorna Map<String, dynamic>
        });
      } else {
        setState(() {
          petData = null;
        });
      }
    } catch (e) {
      print('Erro ao carregar pet: $e');
      setState(() {
        petData = null;
      });
    }
  }

  // lista de frases
  final List<String> funnyPhrases = [
    "Eu sou o dono do sofá agora. Aceite.",
    "Encha meu potinho e ninguém se machuca.",
    "Quem foi que saiu sem mim? Vou latir por 3 horas.",
    "Se caiu no chão, é meu. Regras da casa.",
    "Eu não estraguei o sofá, só personalizei.",
    "Dormir 18 horas por dia é um trabalho sério.",
    "Eu lati pro nada? Talvez. Mas nunca saberemos.",
    "Se você sentar no meu lugar, eu te julgo em silêncio.",
  ];

  String _randomPhrase() {
    final rand = Random();
    return funnyPhrases[rand.nextInt(funnyPhrases.length)];
  }

  Future<String> _getAudioPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/audio__${widget.currentUser.pet_id}${DateTime.now().millisecondsSinceEpoch}.m4a";
  }

  Future<String> convertAudioToBase64(String audioPath) async {
    final bytes = await File(audioPath).readAsBytes();
    return base64Encode(bytes);
  }

  Future startRecording() async {
    if (await _record.hasPermission()) {
      final path = await _getAudioPath();
      await _record.start(const RecordConfig(), path: path);

      setState(() {
        isRecording = true;
        recordedPath = path;
      });
    }
  }

  Future stopRecording() async {
    await _record.stop();

    setState(() {
      isRecording = false;
    });

    // Quando para de gravar, gera uma frase aleatória
    textCtrl.text = _randomPhrase();
  }

  Future<void> publish() async {
    if (textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Grave algo ou escreva uma frase.")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('post').add({
      'text': textCtrl.text,
      'date': DateTime.now().toIso8601String(),
      'isLiked': false,
      'likes': 0,
      'audio_base64': await convertAudioToBase64(recordedPath!),
      'pet_id': widget.currentUser.pet_id,
    });

    Navigator.pop(context, true); // ✅ apenas sinaliza sucesso
  }

  ImageProvider _buildPetImage(Map<String, dynamic>? petData) {
    if (petData == null) {
      return const AssetImage('assets/dog1.jpg');
    }

    final photo = petData['photo'];

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
  void dispose() {
    _record.dispose();
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tradução')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Perfil logado + pet
            Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: _buildPetImage(petData),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.currentUser.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      petData?['name'] ?? 'Carregando...',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botão laranja de gravação
            GestureDetector(
              onTap: () {
                if (isRecording) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (recordedPath != null)
              const Text(
                "Áudio gravado com sucesso!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20),

            TextField(
              controller: textCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Tradução gerada (edite se quiser)...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: publish,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Publicar"),
            ),
          ],
        ),
      ),
    );
  }
}
