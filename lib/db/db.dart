import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TomTomDb {
  static final TomTomDb _tomTomDb = TomTomDb.internal();

  TomTomDb.internal();

  factory TomTomDb() {
    return _tomTomDb;
  }

  Database? database;

  void initDb() async {
    String path = await getDatabasesPath();

    // print('database clicked .................$path');
    openDatabase(
      join(await getDatabasesPath(), AppConstants.DB_NAME),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE ${AppConstants.PODCAST_TABLE_NAME} (id INTEGER PRIMARY KEY, podcast_id TEXT,user_id TEXT,rjname TEXT,podcast_name TEXT,author_name TEXT,imagepath TEXT,audiopath TEXT,like_count TEXT,broadcast_date TEXT,localPath TEXT)",
        );
      },
      version: 1,
    ).then((value) => database = value);
  }

  Future<int?> insertPodcast(DpPodcast dpPodcast) async {
    final result = await database?.insert(
      AppConstants.PODCAST_TABLE_NAME,
      dpPodcast.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(result);
    return result;
  }

  Future<List<DpPodcast>> dpPodcasts() async {
    final List<Map<String, dynamic>> maps = await database
        ?.query(AppConstants.PODCAST_TABLE_NAME) as List<Map<String, dynamic>>;

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DpPodcast.fromJson(maps[i]);
    });
  }

  Future<int?> deletePodcast(String id) async {
    // Get a reference to the database.

    // Remove the Dog from the database.
    final i = await database?.delete(
      AppConstants.PODCAST_TABLE_NAME,
      // Use a `where` clause to delete a specific dog.
      where: 'podcast_id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    return i;
  }

  Future<bool> isPodcastExist(String userId, String podcastId) async {
    final result = await database?.rawQuery(
        'SELECT * FROM ${AppConstants.PODCAST_TABLE_NAME} where user_id = $userId and podcast_id = $podcastId');
    print(result);
    return result!.isNotEmpty;
  }

  Future<void> deleteAll() async {
    return await database
        ?.execute("delete from ${AppConstants.PODCAST_TABLE_NAME}");
  }
}
