import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await deleteDatabase(join(await getDatabasesPath(), 'pettalks.db'));
  runApp(const PetTalksApp());
}
