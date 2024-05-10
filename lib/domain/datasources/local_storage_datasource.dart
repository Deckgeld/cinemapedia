import 'package:cinemapedia/domain/entitites/movie.dart';

abstract class LocalStorageDatasource {

  Future<void> toggleFavorite( Movie movie );

  Future<bool> isMovieFavorite( int movieId );

  Future<List<Movie>> loadMovies({ int limit = 10, int offset = 0 });

}