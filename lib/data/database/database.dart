import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'pettalks.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        // Cria tabela de pet
        await db.execute('''
          CREATE TABLE pet(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            species TEXT,
            photo TEXT
          )
        ''');

        // Cria tabela de posts
        await db.execute('''
          CREATE TABLE post(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            date TEXT,
            isLiked INTEGER,
            likes INTEGER,
            audio_url TEXT,
            pet_id INTEGER,
            FOREIGN KEY(pet_id) REFERENCES pet(id)
          )
        ''');
        // Cria tabela de user
        await db.execute('''
          CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            pet_id INTEGER NOT NULL,
            followers INTEGER DEFAULT 0,
            following INTEGER DEFAULT 0,
            FOREIGN KEY (pet_id) REFERENCES pet(id)
            )
        ''');

        // Insere 1 usuario inicial
        await db.insert('pet', {
          'name': 'Buddy',
          'species': 'Cachorro',
          'photo': 'assets/dog1.jpg',
        });
        await db.insert('user', {
          'name': 'Usuario Padrão',
          'pet_id': 1,
          'followers': 10,
          'following': 14,
        });
        //await db.insert('animais', {'nome': 'Thor', 'tipo': 'Cachorro', 'idade': 5});
      },
      version: 1,
    );
  }

  // Inserir post
  static Future<void> insertPost(Map<String, dynamic> post) async {
    final db = await initDB();
    await db.insert('post', post);
  }

  static Future<Map<String, dynamic>?> getPetById(int petId) async {
    final db = await initDB();
    final result = await db.query(
      'pet',
      where: 'id = ?',
      whereArgs: [petId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Listar posts com join para trazer dados do pet
  static Future<List<Map<String, dynamic>>> listarPosts() async {
    final db = await initDB();
    return db.rawQuery('''
      SELECT p.id, p.text, p.date, p.isLiked, p.likes, p.audio_url,
             pet.name AS pet_name, pet.photo AS pet_photo
      FROM post p
      JOIN pet ON p.pet_id = pet.id
      ORDER BY p.date DESC
    ''');
  }

  // Listar posts com join para trazer dados do pet
  static Future<List<Map<String, dynamic>>> listarUser() async {
    final db = await initDB();
    return db.rawQuery('''
      SELECT u.id, u.name, u.pet_id, u.followers, u.following
      FROM user u
    ''');
  }

  // Listar pets
  static Future<List<Map<String, dynamic>>> listarPets() async {
    final db = await initDB();
    return db.query('pet');
  }
  // Salvar tradução vinculada a um animal
  //static Future<void> salvarTraducao(String frase, String tipo, int animalId) async {
  //final db = await initDB();
  // await db.insert('post', {
  // 'text': frase,
  //'date': DateTime.now().toIso8601String(),
  //'species': tipo,
  //'pet_id': animalId,
  //});
  //}

  // Listar traduções com join para trazer nome do animal
  //static Future<List<Map<String, dynamic>>> listarTraducoes() async {
  // final db = await initDB();
  // return db.rawQuery('''
  //  SELECT t.id, t.frase, t.data, t.tipo, a.nome AS animal_nome
  //  FROM traducoes t
  //  JOIN animais a ON t.animal_id = a.id
  //  ORDER BY t.data DESC
  //''');
  //}

  // Listar animais
  //static Future<List<Map<String, dynamic>>> listarAnimais() async {
  // final db = await initDB();
  //return db.query('animais');
  //}
}
