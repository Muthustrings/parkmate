import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:parkmate/models/user_model.dart';
import 'package:parkmate/models/ticket.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('parkmate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      phone TEXT PRIMARY KEY,
      password TEXT NOT NULL,
      name TEXT NOT NULL
    )
    ''';

    const ticketTable = '''
    CREATE TABLE tickets (
      id TEXT PRIMARY KEY,
      vehicleNumber TEXT NOT NULL,
      vehicleType TEXT NOT NULL,
      phoneNumber TEXT,
      slotNumber TEXT,
      checkInTime TEXT NOT NULL,
      checkOutTime TEXT,
      amount REAL
    )
    ''';

    await db.execute(userTable);
    await db.execute(ticketTable);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Check if tickets table exists
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tickets'",
      );

      if (tables.isEmpty) {
        // Create tickets table if it doesn't exist
        await db.execute('''
          CREATE TABLE tickets (
            id TEXT PRIMARY KEY,
            vehicleNumber TEXT NOT NULL,
            vehicleType TEXT NOT NULL,
            phoneNumber TEXT,
            slotNumber TEXT,
            checkInTime TEXT NOT NULL,
            checkOutTime TEXT,
            amount REAL
          )
        ''');
      } else {
        // Check if amount column exists
        final columns = await db.rawQuery('PRAGMA table_info(tickets)');
        final hasAmount = columns.any((c) => c['name'] == 'amount');
        if (!hasAmount) {
          await db.execute('ALTER TABLE tickets ADD COLUMN amount REAL');
        }
      }
    }
  }

  Future<void> createUser(User user) async {
    final db = await instance.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String phone, String password) async {
    final db = await instance.database;
    print('Checking user: $phone'); // Debug print
    final maps = await db.query(
      'users',
      columns: ['phone', 'password', 'name'],
      where: 'phone = ? AND password = ?',
      whereArgs: [phone, password],
    );

    if (maps.isNotEmpty) {
      print('User found: ${maps.first}'); // Debug print
      return User.fromMap(maps.first);
    } else {
      print('User not found'); // Debug print
      return null;
    }
  }

  Future<bool> checkUserExists(String phone) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['phone'],
      where: 'phone = ?',
      whereArgs: [phone],
    );

    return maps.isNotEmpty;
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'phone = ?',
      whereArgs: [user.phone],
    );
  }

  // Ticket Methods

  Future<void> createTicket(Ticket ticket) async {
    final db = await instance.database;
    await db.insert(
      'tickets',
      ticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ticket>> getActiveTickets() async {
    final db = await instance.database;
    final maps = await db.query('tickets', where: 'checkOutTime IS NULL');

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }

  Future<List<Ticket>> getHistoryTickets() async {
    final db = await instance.database;
    final maps = await db.query(
      'tickets',
      where: 'checkOutTime IS NOT NULL',
      orderBy: 'checkOutTime DESC',
    );

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }

  Future<List<Ticket>> getAllTickets() async {
    final db = await instance.database;
    final maps = await db.query('tickets', orderBy: 'checkInTime DESC');

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }

  Future<void> updateTicket(Ticket ticket) async {
    final db = await instance.database;
    await db.update(
      'tickets',
      ticket.toMap(),
      where: 'id = ?',
      whereArgs: [ticket.id],
    );
  }
}
