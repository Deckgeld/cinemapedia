import 'package:cinemapedia/domain/entitites/movie.dart';

abstract class MoviesDataSource {
  Future<List<Movie>> getNowPlaying({ int page = 1 });
}