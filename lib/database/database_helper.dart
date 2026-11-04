import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWebNoWebWorker;
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = kIsWeb
        ? 'mysilma_web.db'
        : join(await getDatabasesPath(), 'mysilma.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUsers(db);
    await _createAdmin(db);
    await _createVenues(db);
    await _createSlots(db);
    await _createBookings(db);
    await _createPayments(db);
    await _createCommunities(db);
    await _createCommunityParticipants(db);
    await _createSchedule(db);
    await _insertSeedData(db);
  }

  // ─────────────────────────────────────────────────────────
  // CREATE TABLES
  // ─────────────────────────────────────────────────────────

  Future<void> _createUsers(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id        CHAR(8)       PRIMARY KEY,
        name      VARCHAR(100)  NOT NULL,
        email     VARCHAR(100)  NOT NULL UNIQUE,
        password  VARCHAR(500)  NOT NULL,
        phone     VARCHAR(20),
        created_at DATETIME     DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _createAdmin(Database db) async {
    await db.execute('''
      CREATE TABLE admin (
        id         CHAR(8)      PRIMARY KEY,
        name       VARCHAR(100) NOT NULL,
        email      VARCHAR(100) NOT NULL UNIQUE,
        password   VARCHAR(255) NOT NULL,
        phone      VARCHAR(20),
        role       VARCHAR(20)  NOT NULL DEFAULT 'admin'
                   CHECK(role IN ('superadmin','admin','operator')),
        is_active  INTEGER      NOT NULL DEFAULT 1,
        created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _createVenues(Database db) async {
    await db.execute('''
      CREATE TABLE venues (
        id           CHAR(8)      PRIMARY KEY,
        name         VARCHAR(150) NOT NULL,
        location     VARCHAR(150) NOT NULL,
        type         VARCHAR(50),
        price        NUMERIC      NOT NULL DEFAULT 0,
        rating       NUMERIC(2,1) DEFAULT 0.0,
        image        VARCHAR(255),
        is_available INTEGER      NOT NULL DEFAULT 1,
        created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _createSlots(Database db) async {
    await db.execute('''
      CREATE TABLE slots (
        id           INTEGER      PRIMARY KEY AUTOINCREMENT,
        venue_id     VARCHAR(8)   NOT NULL,
        slot_date    DATE         NOT NULL,
        start_time   TIME         NOT NULL,
        end_time     TIME         NOT NULL,
        price        NUMERIC      NOT NULL DEFAULT 0,
        is_available INTEGER      NOT NULL DEFAULT 1,
        FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createBookings(Database db) async {
    await db.execute('''
      CREATE TABLE bookings (
        id          INTEGER      PRIMARY KEY AUTOINCREMENT,
        user_id     VARCHAR(8)   NOT NULL,
        venue_id    VARCHAR(8)   NOT NULL,
        slot_id     INTEGER      NOT NULL,
        status      VARCHAR(20)  NOT NULL DEFAULT 'pending'
                    CHECK(status IN ('pending','confirmed','cancelled','completed')),
        total_price INTEGER      NOT NULL DEFAULT 0,
        notes       TEXT,
        created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
        FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE CASCADE,
        FOREIGN KEY (slot_id)  REFERENCES slots(id)  ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createPayments(Database db) async {
    await db.execute('''
      CREATE TABLE payments (
        id           INTEGER      PRIMARY KEY AUTOINCREMENT,
        booking_id   INTEGER      NOT NULL,
        method       VARCHAR(30)  NOT NULL
                     CHECK(method IN ('transfer','qris','silmapay','cash')),
        amount       INTEGER      NOT NULL DEFAULT 0,
        status       VARCHAR(20)  NOT NULL DEFAULT 'unpaid'
                     CHECK(status IN ('unpaid','paid','refunded','failed')),
        reference_no VARCHAR(100),
        paid_at      TIMESTAMP,
        created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createCommunities(Database db) async {
    await db.execute('''
      CREATE TABLE communities (
        id               VARCHAR(8)   PRIMARY KEY,
        title            VARCHAR(150) NOT NULL,
        sport            VARCHAR(150),
        venue_id         VARCHAR(50),
        event_date       DATE,
        start_time       TIME,
        end_time         TIME,
        max_participants INTEGER      DEFAULT 0,
        organizer_id     VARCHAR(8),
        booking_id       INTEGER,
        created_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (venue_id)    REFERENCES venues(id),
        FOREIGN KEY (organizer_id) REFERENCES users(id),
        FOREIGN KEY (booking_id)  REFERENCES bookings(id)
      )
    ''');
  }

  Future<void> _createCommunityParticipants(Database db) async {
    await db.execute('''
      CREATE TABLE community_participants (
        community_id VARCHAR(10)  NOT NULL,
        user_id      VARCHAR(8)   NOT NULL,
        joined_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (community_id, user_id),
        FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id)      REFERENCES users(id)       ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createSchedule(Database db) async {
    await db.execute('''
      CREATE TABLE schedule (
        id           INTEGER      PRIMARY KEY AUTOINCREMENT,
        user_id      VARCHAR(8)   NOT NULL,
        community_id VARCHAR(150),
        booking_id   INTEGER,
        title        VARCHAR(255) NOT NULL,
        start_at     TIMESTAMP    NOT NULL,
        end_at       TIMESTAMP    NOT NULL,
        notes        TEXT,
        FOREIGN KEY (user_id)      REFERENCES users(id)       ON DELETE CASCADE,
        FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE SET NULL,
        FOREIGN KEY (booking_id)   REFERENCES bookings(id)    ON DELETE SET NULL
      )
    ''');
  }

  // ─────────────────────────────────────────────────────────
  // SEED DATA
  // ─────────────────────────────────────────────────────────

  Future<void> _insertSeedData(Database db) async {
    // Seed admin
    await db.insert('admin', {
      'id': 'ADM00001',
      'name': 'Super Admin',
      'email': 'admin@mysilma.id',
      'password': _hashPassword('Admin@123'),
      'phone': '081200000001',
      'role': 'superadmin',
      'is_active': 1,
    });

    // Seed user demo
    await db.insert('users', {
      'id': 'USR00001',
      'name': 'Fajar Pratama',
      'email': 'fajar@gmail.com',
      'password': _hashPassword('Fajar@123'),
      'phone': '08123456789',
    });

    // Seed venues
    await db.insert('venues', {
      'id': 'VEN00001',
      'name': 'GOR Silma Hall A Sport Center',
      'location': 'Jl. Bintara 11 No. 18, Kota Bekasi',
      'type': 'Karpet Vinyl',
      'price': 65000,
      'rating': 4.9,
      'image': 'assets/images/Lapangan1.png',
      'is_available': 1,
    });

    await db.insert('venues', {
      'id': 'VEN00002',
      'name': 'GOR Silma Hall B Sport Center',
      'location': 'Jl. Bintara 11 No. 18, Kota Bekasi',
      'type': 'Parquet Kayu BWF',
      'price': 80000,
      'rating': 4.8,
      'image': 'assets/images/Lapangan2.png',
      'is_available': 1,
    });

    // Seed slots untuk VEN00001
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowStr =
        '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';

    final slots = [
      ['07:00', '08:00'],
      ['08:00', '09:00'],
      ['09:00', '10:00'],
      ['16:00', '17:00'],
      ['17:00', '18:00'],
      ['19:00', '20:00'],
      ['20:00', '21:00'],
      ['21:00', '22:00'],
    ];

    for (final slot in slots) {
      await db.insert('slots', {
        'venue_id': 'VEN00001',
        'slot_date': tomorrowStr,
        'start_time': slot[0],
        'end_time': slot[1],
        'price': 65000,
        'is_available': 1,
      });
    }

    // Seed booking demo
    await db.insert('bookings', {
      'user_id': 'USR00001',
      'venue_id': 'VEN00001',
      'slot_id': 6,
      'status': 'confirmed',
      'total_price': 65000,
      'notes': 'Main bareng teman',
    });

    // Seed payment
    await db.insert('payments', {
      'booking_id': 1,
      'method': 'silmapay',
      'amount': 65000,
      'status': 'paid',
      'reference_no': 'SLP-${DateTime.now().millisecondsSinceEpoch}',
      'paid_at': DateTime.now().toIso8601String(),
    });

    // Seed schedule
    await db.insert('schedule', {
      'user_id': 'USR00001',
      'booking_id': 1,
      'title': 'Main Badminton - GOR Silma Hall A',
      'start_at': '${tomorrowStr}T19:00:00',
      'end_at': '${tomorrowStr}T20:00:00',
      'notes': 'Bawa raket sendiri',
    });
  }

  // ─────────────────────────────────────────────────────────
  // HELPER: hash password sederhana (MD5-like via crypto)
  // ─────────────────────────────────────────────────────────
  String _hashPassword(String password) {
    // Simpan plain untuk demo — di production gunakan bcrypt
    return password;
  }

  // ─────────────────────────────────────────────────────────
  // CRUD USERS
  // ─────────────────────────────────────────────────────────

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Login: cek email/WA dan password
  Future<Map<String, dynamic>?> loginUser(
    String contact,
    String password,
  ) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: '(email = ? OR phone = ?) AND password = ?',
      whereArgs: [contact, contact, password],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users', orderBy: 'created_at DESC');
  }

  Future<int> updateUser(String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────────────────────
  // CRUD VENUES
  // ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAllVenues() async {
    final db = await database;
    return await db.query(
      'venues',
      where: 'is_available = 1',
      orderBy: 'rating DESC',
    );
  }

  Future<Map<String, dynamic>?> getVenueById(String id) async {
    final db = await database;
    final result = await db.query(
      'venues',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertVenue(Map<String, dynamic> venue) async {
    final db = await database;
    return await db.insert('venues', venue);
  }

  Future<int> updateVenue(String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('venues', data, where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────────────────────
  // CRUD SLOTS
  // ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAvailableSlots(
    String venueId,
    String date,
  ) async {
    final db = await database;
    return await db.query(
      'slots',
      where: 'venue_id = ? AND slot_date = ? AND is_available = 1',
      whereArgs: [venueId, date],
      orderBy: 'start_time ASC',
    );
  }

  Future<int> insertSlot(Map<String, dynamic> slot) async {
    final db = await database;
    return await db.insert('slots', slot);
  }

  Future<int> updateSlotAvailability(int slotId, bool isAvailable) async {
    final db = await database;
    return await db.update(
      'slots',
      {'is_available': isAvailable ? 1 : 0},
      where: 'id = ?',
      whereArgs: [slotId],
    );
  }

  // ─────────────────────────────────────────────────────────
  // CRUD BOOKINGS
  // ─────────────────────────────────────────────────────────

  Future<int> insertBooking(Map<String, dynamic> booking) async {
    final db = await database;
    final id = await db.insert('bookings', booking);
    // Tandai slot tidak tersedia
    await updateSlotAvailability(booking['slot_id'], false);
    return id;
  }

  Future<List<Map<String, dynamic>>> getBookingsByUser(String userId) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT b.*, v.name AS venue_name, v.image AS venue_image,
             s.slot_date, s.start_time, s.end_time
      FROM bookings b
      JOIN venues v ON b.venue_id = v.id
      JOIN slots  s ON b.slot_id  = s.id
      WHERE b.user_id = ?
      ORDER BY b.created_at DESC
    ''',
      [userId],
    );
  }

  Future<int> updateBookingStatus(int bookingId, String status) async {
    final db = await database;
    return await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future<Map<String, dynamic>?> getBookingById(int id) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT b.*, v.name AS venue_name, v.location AS venue_location,
             v.image AS venue_image, s.slot_date, s.start_time, s.end_time
      FROM bookings b
      JOIN venues v ON b.venue_id = v.id
      JOIN slots  s ON b.slot_id  = s.id
      WHERE b.id = ?
    ''',
      [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ─────────────────────────────────────────────────────────
  // CRUD PAYMENTS
  // ─────────────────────────────────────────────────────────

  Future<int> insertPayment(Map<String, dynamic> payment) async {
    final db = await database;
    final id = await db.insert('payments', payment);
    // Update status booking jadi confirmed
    await updateBookingStatus(payment['booking_id'], 'confirmed');
    return id;
  }

  Future<Map<String, dynamic>?> getPaymentByBooking(int bookingId) async {
    final db = await database;
    final result = await db.query(
      'payments',
      where: 'booking_id = ?',
      whereArgs: [bookingId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ─────────────────────────────────────────────────────────
  // CRUD COMMUNITIES
  // ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAllCommunities() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.*, v.name AS venue_name, u.name AS organizer_name
      FROM communities c
      LEFT JOIN venues v ON c.venue_id = v.id
      LEFT JOIN users  u ON c.organizer_id = u.id
      ORDER BY c.event_date ASC
    ''');
  }

  Future<int> insertCommunity(Map<String, dynamic> community) async {
    final db = await database;
    return await db.insert('communities', community);
  }

  Future<int> joinCommunity(String communityId, String userId) async {
    final db = await database;
    return await db.insert('community_participants', {
      'community_id': communityId,
      'user_id': userId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // ─────────────────────────────────────────────────────────
  // CRUD SCHEDULE
  // ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getScheduleByUser(String userId) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT s.*, v.name AS venue_name, v.image AS venue_image
      FROM schedule s
      LEFT JOIN bookings b ON s.booking_id = b.id
      LEFT JOIN venues   v ON b.venue_id   = v.id
      WHERE s.user_id = ?
      ORDER BY s.start_at ASC
    ''',
      [userId],
    );
  }

  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    final db = await database;
    return await db.insert('schedule', schedule);
  }

  // ─────────────────────────────────────────────────────────
  // ADMIN
  // ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> loginAdmin(
    String email,
    String password,
  ) async {
    final db = await database;
    final result = await db.query(
      'admin',
      where: 'email = ? AND password = ? AND is_active = 1',
      whereArgs: [email, password],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllAdmins() async {
    final db = await database;
    return await db.query('admin', orderBy: 'created_at DESC');
  }

  // ─────────────────────────────────────────────────────────
  // UTILITY
  // ─────────────────────────────────────────────────────────

  /// Generate ID seperti USR00001
  Future<String> generateId(String prefix, String table) async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
    final count = (result.first['count'] as int) + 1;
    return '$prefix${count.toString().padLeft(5, '0')}';
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Hapus seluruh database (untuk testing)
  Future<void> deleteDatabase() async {
    final path = kIsWeb
        ? 'mysilma_web.db'
        : join(await getDatabasesPath(), 'mysilma.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
