import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class NewTranslationPage extends StatefulWidget {
  const NewTranslationPage({super.key});

  @override
  State<NewTranslationPage> createState() => _NewTranslationPageState();
}

class _NewTranslationPageState extends State<NewTranslationPage> {
  final _record = AudioRecorder();
  bool isRecording = false;
  String? recordedPath;
  final textCtrl = TextEditingController();

  Future<String> _getAudioPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a";
    return filePath;
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

    // MOCK de tradução
    textCtrl.text = "Eu sou o dono do sofá agora. Aceite.";
  }

  void publish() {
    Navigator.pop(context, {
      "text": textCtrl.text,
      "audio": recordedPath,
    });
  }

  @override
  void dispose() {
    _record.dispose();
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
            const SizedBox(height: 20),

            // BOTÃO LARANJA DE GRAVAÇÃO
            GestureDetector(
              onTap: () {
                if (isRecording) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
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
                hintText: "Tradução gerada...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: publish,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Publicar"),
            )
          ],
        ),
      ),
    );
  }
}
