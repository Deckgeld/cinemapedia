import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este provider nos permite obtener las peliculas que se estan reproduciendo actualmente
final nowPlayingProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //Obtenemos el repositorio de peliculas
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying; 

  //creamos una instancia de MoviesNotifier
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );

});


//Tipamos la funcion que requiere como parametro
typedef MovieCallBack = Future<List<Movie>> Function({int page});


class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  //Funcion que se encargara de obtener las peliculas
  MovieCallBack fetchMoreMovies;

  MoviesNotifier({ 
    required this.fetchMoreMovies 
  }) : super([]);

  //
  Future<void> loadNextPage() async {
    currentPage++;
    //Obtenemos las peliculas
    final movies = await fetchMoreMovies(page: currentPage);
    //Agregamos las peliculas al estado
    state = [...state, ...movies];
  }


}