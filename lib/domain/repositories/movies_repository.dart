import 'package:cinemapedia/domain/entitites/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({ int page = 1 });
}