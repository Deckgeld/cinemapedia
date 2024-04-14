import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  // Obtenemos el repositorio de películas
  final movieRepository = ref.watch(movieRepositoryProvider);

  return MovieMapNotifier(getMovie: movieRepository.getMovieDetail);
});


/* Example of a MovieMapNotifier
  {
    '204682': Movie(),
    '204683': Movie(),
    '204684': Movie(),
  }
*/

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> leadMovie(String movieId) async {
    // Si la película ya está en el estado, no la vuelvas a cargar
    if (state[movieId] != null) return;

    // Cargar la película
    final movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}
