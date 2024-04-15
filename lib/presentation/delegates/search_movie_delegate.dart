import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;

  SearchMovieDelegate({
    required this.searchMovies
  });

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
      onPressed: () => close(context, null),
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
    return FutureBuilder(
      future: searchMovies(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return ListTile(
              title: Text(movie.title),
              onTap: () => close(context, movie),
            );
          }
        );
      },
    );
  }
}
