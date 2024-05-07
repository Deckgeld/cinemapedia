import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_rating_bar.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  final List<Movie> initialMovies;

  //debounceMovies es un StreamController que nos permite controlar cuando hacer las petciones
  //Se puede hacer con paquetes como rxdart, pero en este caso lo haremos nosotros mismos
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? _debounceTimmer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  void clearStrams() {
    debounceMovies.close();
  }

  //onQueryChanged es un metodo que se encarga de hacer la peticion de las peliculas
  void onQueryChanged(String query) {
    if (_debounceTimmer?.isActive ?? false) _debounceTimmer?.cancel();

    _debounceTimmer = Timer(const Duration(milliseconds: 500), () async {

      //if (query.isEmpty) return debounceMovies.add([]);

      final movies = await searchMovies(query);
      debounceMovies.add(movies);
    });
  }

  @override
  //searchFieldLabel es el texto que se muestra en el campo de busqueda
  String get searchFieldLabel => 'Search movies';

  @override
  //buildActions es el metodo que se encarga de mostrar los widgets que se van a mostrar en la parte derecha del appbar
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        //animate es un booleano que nos permite saber si el widget se debe animar o no
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
      )
    ];
  }

  @override
  //buildLeading es el metodo que se encarga de mostrar los widgets que se van a mostrar en la parte izquierda del appbar
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStrams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  //buildResults es el metodo que se encarga de mostrar los resultados cuando la persona presiona enter
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  //buildSuggestions es el metodo que se encarga de mostrar las sugerencias de la busqueda, cuando la persona esta escribiendo
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);

    return StreamBuilder(
      //son las peliculas que se guardaran en cache
      initialData: initialMovies,
      // future: searchMovies(query),
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        //ten cuidado porque cada vez que se escribe algo en el campo de busqueda, se hace una peticion
        //! print('Realizando peticion')

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MoviesItem(
            movie: movies[index],
            //close es un metodo que nos permite cerrar el search delegate
            onMovieSelected: (context, movie) {
              clearStrams();
              close(context, movie);
            } 
              
          ),
        );
      },
    );
  }
}

class _MoviesItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MoviesItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textSyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    //GestureDetector es un widget que nos permite detectar gestos
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(children: [
          // Image
          SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  //loadingBuilder es un callback que nos permite mostrar un widget mientras la imagen se esta cargando
                  //loadingBuilder: ,
                ),
              )),

          const SizedBox(
              width: 10), //se deja espacio entre la imagen y el texto (10px)

          // Title and overview
          SizedBox(
              //se deja espacio entre la imagen y el texto
              width: size.width * 0.7,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textSyles.titleMedium),
                    Text(
                      movie.overview,
                      textAlign: TextAlign.justify,
                      style: textSyles.bodySmall,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(children: [
                      Text(HumanFormats.number(movie.voteAverage, 1),
                          style: textSyles.bodySmall),
                      MovieRatingBar(
                          movieRating: movie.voteAverage, itemSize: 15.0),
                    ])
                  ]))
        ]),
      ),
    );
  }
}
