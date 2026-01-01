import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalNotesDb {
  LocalNotesDb._();
  static final LocalNotesDb instance = LocalNotesDb._();
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final path = join(documentsDir.path, 'local_notes.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async => _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTables(db);
        }
      },
      onOpen: (db) async {
        await _createTables(db); // ensure exists if DB dibuat tanpa tabel
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quick_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = await database;
    return db.query('quick_notes', orderBy: 'updated_at DESC');
  }

  Future<int> insertNote({required String title, required String content}) async {
    final db = await database;
    return db.insert('quick_notes', {
      'title': title,
      'content': content,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<int> updateNote({required int id, required String title, required String content}) async {
    final db = await database;
    return db.update(
      'quick_notes',
      {
        'title': title,
        'content': content,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('quick_notes', where: 'id = ?', whereArgs: [id]);
  }
}
