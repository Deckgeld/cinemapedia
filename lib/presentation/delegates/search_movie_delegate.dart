import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_rating_bar.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;

  SearchMovieDelegate({required this.searchMovies});

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
          itemBuilder: (context, index) => _MoviesItem(movie: movies[index]),
        );
      },
    );
  }
}

class _MoviesItem extends StatelessWidget {
  final Movie movie;
  const _MoviesItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textSyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [

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
            )
          ),

          const SizedBox(width: 10), //se deja espacio entre la imagen y el texto (10px)

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
                Row(
                  children: [
                    Text(
                      HumanFormats.number( movie.voteAverage, 1 ),
                      style: textSyles.bodySmall
                    ),
                    MovieRatingBar(movieRating: movie.voteAverage, itemSize: 15.0),

                  ]
                )
              ]
            )
          )
        ]
      ),
    );
  }
}
