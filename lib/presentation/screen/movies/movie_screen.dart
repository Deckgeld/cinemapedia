import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie-screen';

  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).leadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).leadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        //Esta propiedad es para que el scroll no se pase de los limites, que no de como esa elasticidad
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(
                        movie: movie,
                      ),
                  childCount: 1))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // * little image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // * info movie
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: textStyle.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.overview,
                        maxLines: 12,
                        style: TextStyle(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((genre) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(genre),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ))),
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * Actor foto
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    width: 135,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),

                // * Actor name
                const SizedBox(height: 5),

                Text(
                  actor.name,
                  maxLines: 2,
                ),
                Text(
                  actor.character ?? '',
                  maxLines: 2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
        backgroundColor: Colors.black,
        expandedHeight: size.height * 0.7,
        foregroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          //Eliminamos el title porque las poster ya tienen el titulo

          background: Stack(
            children: [
              //expanded es para que ocupe todo el espacio disponible
              // * image
              SizedBox.expand(
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return FadeIn(child: child);
                    return const SizedBox();
                  },
                ),
              ),

              //2 gradientes para oscurecer la imagen
              // * gradientes
              const SizedBox.expand(
                //DecoratedBox es un widget que nos permite decorar otro widget
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      //gradient es una propiedad que nos permite poner el gradiente, en este caso un LinearGradient
                      gradient: LinearGradient(
                          //begin y end son los puntos de inicio y fin del gradiente
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          //stops es para indicar en que punto del gradiente se va a poner el color, en este caso en el 70% y 100%
                          stops: [0.7, 1.0],
                          //colors es para indicar los colores del gradiente
                          colors: [Colors.transparent, Colors.black87])),
                ),
              ),

              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          // end: Alignment.bottomCenter,
                          stops: [
                        0.0,
                        0.3
                      ],
                          colors: [
                        Colors.black87,
                        Colors.transparent,
                      ])),
                ),
              ),
            ],
          ),
        ));
  }
}
