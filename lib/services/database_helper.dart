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
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      phone TEXT PRIMARY KEY,
      password TEXT NOT NULL,
      name TEXT NOT NULL,
      securityQuestion TEXT,
      securityAnswer TEXT
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
      amount REAL,
      createdBy TEXT
    )
    ''';

    await db.execute(userTable);
    await db.execute(ticketTable);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // ... (existing version 2 upgrade logic)
    }

    if (oldVersion < 3) {
      // ... (existing version 3 upgrade logic)
    }

    if (oldVersion < 4) {
      // Add createdBy column to tickets table
      final columns = await db.rawQuery('PRAGMA table_info(tickets)');
      final hasCreatedBy = columns.any((c) => c['name'] == 'createdBy');
      if (!hasCreatedBy) {
        await db.execute('ALTER TABLE tickets ADD COLUMN createdBy TEXT');
      }
    }
  }

  // User Methods

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

  Future<User?> getUserByPhone(String phone) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['phone', 'password', 'name'],
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
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

  Future<void> updatePassword(String phone, String newPassword) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'phone = ?',
      whereArgs: [phone],
    );
  }

  Future<String?> getSecurityQuestion(String phone) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['securityQuestion'],
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (maps.isNotEmpty) {
      return maps.first['securityQuestion'] as String?;
    }
    return null;
  }

  Future<bool> verifySecurityAnswer(String phone, String answer) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['securityAnswer'],
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (maps.isNotEmpty) {
      final storedAnswer = maps.first['securityAnswer'] as String?;
      return storedAnswer?.toLowerCase() == answer.toLowerCase();
    }
    return false;
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

  Future<List<Ticket>> getActiveTickets(String userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'tickets',
      where: 'checkOutTime IS NULL AND createdBy = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }

  Future<List<Ticket>> getHistoryTickets(String userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'tickets',
      where: 'checkOutTime IS NOT NULL AND createdBy = ?',
      orderBy: 'checkOutTime DESC',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }

  Future<List<Ticket>> getAllTickets(String userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'tickets',
      where: 'createdBy = ?',
      orderBy: 'checkInTime DESC',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }

  Future<void> updateTicket(Ticket ticket) async {
    final db = await instance.database;
    try {
      await db.update(
        'tickets',
        ticket.toMap(),
        where: 'id = ?',
        whereArgs: [ticket.id],
      );
    } catch (e) {
      if (e.toString().contains('no such column: createdBy')) {
        print('Adding missing createdBy column and retrying update...');
        await db.execute('ALTER TABLE tickets ADD COLUMN createdBy TEXT');
        await db.update(
          'tickets',
          ticket.toMap(),
          where: 'id = ?',
          whereArgs: [ticket.id],
        );
      } else {
        rethrow;
      }
    }
  }
}
