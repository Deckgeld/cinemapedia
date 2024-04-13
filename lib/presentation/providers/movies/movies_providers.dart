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
  //creamos una bandera booleana, porque el MovieHorizontalListView llama a la funcion loadNextPage varias veces y puede causar errores de rendimiento
  bool isLoading = false;
  //Funcion que se encargara de obtener las peliculas
  MovieCallBack fetchMoreMovies;

  MoviesNotifier({ 
    required this.fetchMoreMovies 
  }) : super([]);

  //
  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    currentPage++;
    //Obtenemos las peliculas
    final movies = await fetchMoreMovies(page: currentPage);
    //Agregamos las peliculas al estado
    state = [...state, ...movies];

    //Esperamos 300 milisegundos para que el usuario pueda ver las peliculas
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }


}