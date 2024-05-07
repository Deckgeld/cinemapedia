import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  //transformamos el widget en un ConsumerWidget y le pasamos el ref
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              Icons.movie_outlined,
              color: colors.primary,
            ),
            const SizedBox(width: 5),
            Text('Cinemapedia', style: titleStyle),

            //Spacer nos ayuda a que el IconButton se posicione a la derecha
            const Spacer(),

            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final searchedMovies = ref.read( searchedMoviesProvider );
                final searchQuery = ref.read(searchQueryProvider);

                //showSearch es un metodo que nos permite mostrar un search delegate
                //Devuelve un Future<Movie?>, que es el movie seleccionado
                //Al finalizar la busqueda, se ejecuta el metodo then, que nos lleva a la pantalla de detalles de la pelicula
                showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    //delegate es el objeto que se encarga de manejar la busqueda
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery,
                    )).then((movie) {
                  //si movie es null, no hacemos nada
                  if (movie == null) return;

                  context.push('/home/0/movie/${movie.id}');
                });
              },
            )
          ],
        ),
      ),
    ));
  }
}
