import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_not_sepeti_app/model/kategori.dart';
import 'package:flutter_not_sepeti_app/model/notlar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static DatabaseHelper? databaseHelper;
  static Database? database;

  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper._internal();
      return databaseHelper!;
    } else {
      return databaseHelper!;
    }
  }
  DatabaseHelper._internal(){}

  Future<Database> _getDatabase() async {
    if (database == null) {
      database = await initializeDatabase();
      return database!;
    } else {
      return database!;
    }
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notlarim.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notlarim.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async {
    var kategorilerMapListesi = await kategorileriGetir();
    var kategoriListesi = <Kategori>[];
    for (var map in kategorilerMapListesi) {
      kategoriListesi.add(Kategori.fromMap(map));
    }
    return kategoriListesi;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update("kategori", kategori.toMap(),
        where: "kategoriID = ?", whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategroriSil(int kategoriID) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete("kategori", where: "kategoriID=?", whereArgs: [kategoriID]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        'SELECT * FROM "not" INNER JOIN kategori on kategori.kategoriID = "not".kategoriID  order by notID DESC;');
    return sonuc;
  }

  Future<List<Not>> notListesiniGetir() async {
    var notlarMapListesi = await notlariGetir();
    var notListesi = <Not>[];
    for (var map in notlarMapListesi) {
      notListesi.add(Not.fromMap(map));
    }
    return notListesi;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("not", not.toMap());
    return sonuc;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db
        .update("not", not.toMap(), where: "notID = ?", whereArgs: [not.notID]);
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete("not", where: "notID = ?", whereArgs: [notID]);
    return sonuc;
  }

  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(
      days: 1,
    );
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = const Duration(days: 7);
    String? month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
