import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user.dart';
import '../../../data/models/pet.dart';

class EditProfilePage extends StatefulWidget {
  final User currentUser;

  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController speciesCtrl;
  Pet? pet;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    final petDoc = await FirebaseFirestore.instance
        .collection('pet')
        .doc(widget.currentUser.pet_id)
        .get();

    if (petDoc.exists) {
      final data = petDoc.data()!;
      setState(() {
        pet = Pet(
          //id: petDoc.id,
          name: data['name'],
          species: data['species'],
          photo: data['photo'],
        );
        nameCtrl = TextEditingController(text: pet!.name);
        speciesCtrl = TextEditingController(text: pet!.species);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (pet != null) {
      await FirebaseFirestore.instance
          .collection('pet')
          .doc(widget.currentUser.pet_id)
          .update({'name': nameCtrl.text, 'species': speciesCtrl.text});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: pet == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: "Nome do Pet",
                      labelStyle: const TextStyle(
                        fontSize: 24, // label maior
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.orange[50], // fundo pastel laranja
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 243, 224, 1),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 243, 224, 1),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(252, 234, 205, 1),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: speciesCtrl,
                    decoration: InputDecoration(
                      labelText: "Espécie",
                      labelStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.orange[50], // fundo pastel laranja
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 243, 224, 1),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 243, 224, 1),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(252, 234, 205, 1),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            ),
    );
  }
}
