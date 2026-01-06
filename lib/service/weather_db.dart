import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class weather {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> intialDB() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "database.db");
    Database mysql = await openDatabase(path, version: 1, onCreate: _oncreate);
    return mysql;
  }

  Future<void> _oncreate(Database db, int vearsion) async {
    await db.execute('''
 Create Table Cities(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
    country TEXT,
    latitude TEXT,
    longitude TEXT
  )
''');//التوقعات
    await db.execute('''
 Create Table Forecast(
id INTEGER PRIMARY KEY AUTOINCREMENT,
 city_id INTEGER,
    forecast_date TEXT,
    min_temp TEXT,
    max_temp TEXT,
    condition_text TEXT,
    icon_url TEXT,
    FOREIGN KEY(city_id) REFERENCES Cities(id)
  )
''');//الطقس الحالي
    await db.execute('''
 Create Table CurrentWeather(
id INTEGER PRIMARY KEY AUTOINCREMENT,
city_id INTEGER,
    temperature_c TEXT,
    condition_text TEXT,
    humidity INTEGER,
    wind_kph TEXT,
    pressure_mb TEXT,
    icon_url TEXT,
    datetime TEXT,
    FOREIGN KEY(city_id) REFERENCES Cities(id)
  )
''');// الاجرائات والتنبيهات
    await db.execute('''
 Create Table warnining(
id INTEGER PRIMARY KEY AUTOINCREMENT,
CurrentWeather_id INTEGER,
    procedure TEXT,
    FOREIGN KEY(CurrentWeather_id) REFERENCES Cities(id)
  )
''');
    await db.execute('''
 Create Table Notifications(
id INTEGER PRIMARY KEY AUTOINCREMENT,
    noti_text TEXT,
    date TEXT
  )
''');
    print("created all table");
  }

// استعلامات المرض
  Future<List<Map>> read_wheather(String sql) async {
    Database? sqldb = await db;
    var result = await sqldb!.rawQuery(sql);
    return result;
  }

// استعلامات الاضافة
  Future<int> insert_wheather(String sql) async {
    Database? sqldb = await db;
    int result = await sqldb!.rawInsert(sql);
    return result;
  }

// استعلامات التحديث
  Future<int> update_wheather(String sql) async {
    Database? sqldb = await db;
    int result = await sqldb!.rawUpdate(sql);
    return result;
  }

// استعلامات الحذف
  Future<int> delete_wheathers(String sql) async {
    Database? sqldb = await db;
    int result = await sqldb!.rawDelete(sql);
    return result;
  }

}
