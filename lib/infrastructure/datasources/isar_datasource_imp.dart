import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasourceImp implements LocalStorageDatasource {
  ///Necesarias para la implementación de Isar
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    // Recuerda instarlar el paquete path_provider y importarlo
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema],
        //inspector para ver la base de datos en el navegador
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  ///

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies
        //.where()
        .filter()
        //.backdropPathEqualTo(value)  Notese que el puede variar segun la propiedad que se quiera comparar
        .idEqualTo(movieId)
        .findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) async {
    final isar = await db;

    return isar.movies
      .where()
      .offset(offset)
      .limit(limit)
      .findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async{
    final isar = await db;

    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();
    
    if (favoriteMovie != null) {
      //las transacciones son necesarias para modificar la base de datos
      isar.writeTxnSync(() => isar.movies.delete(favoriteMovie.isarId!));
    } else {
      //Tx = Transacción
      isar.writeTxnSync(() => isar.movies.put(movie));
    }
  }
}
