import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/models/user.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final db = FirebaseFirestore.instance;

  // Criar usuário 1 só se não existir
  final user1Doc = await db.collection('user').doc('1').get();
  if (!user1Doc.exists) {
    await db.collection('user').doc('1').set({
      'name': 'Usuario 1',
      'pet_id': '1',
      'followers': 10,
      'following': 14,
    });
  }

  // Criar usuário 2 só se não existir
  final user2Doc = await db.collection('user').doc('2').get();
  if (!user2Doc.exists) {
    await db.collection('user').doc('2').set({
      'name': 'Usuario 2',
      'pet_id': '2',
      'followers': 10,
      'following': 14,
    });
  }

  // Criar pet 1 só se não existir
  final pet1Doc = await db.collection('pet').doc('1').get();
  if (!pet1Doc.exists) {
    await db.collection('pet').doc('1').set({
      'name': 'Buddy',
      'species': 'Cachorro',
      'photo': 'assets/dog1.jpg',
    });
  }

  // Criar pet 2 só se não existir
  final pet2Doc = await db.collection('pet').doc('2').get();
  if (!pet2Doc.exists) {
    await db.collection('pet').doc('2').set({
      'name': 'Lucky',
      'species': 'Gato',
      'photo': 'assets/cat1.jpg',
    });
  }
  // Busca o usuário com ID "1" no Firestore
  final doc = await FirebaseFirestore.instance
      .collection('user') // use plural para padronizar
      .doc('1')
      .get();

  late User defaultUser;

  if (doc.exists) {
    final data = doc.data()!;
    defaultUser = User(
      id: doc.id,
      name: data['name'],
      pet_id: data['pet_id'],
      followers: data['followers'],
      following: data['following'],
    );
  } else {
    // fallback se não existir
    defaultUser = User(
      id: '1',
      name: 'Usuario Padrão',
      pet_id: '1',
      followers: 0,
      following: 0,
    );
  }

  runApp(PetTalksApp(defaultUser: defaultUser));
}
