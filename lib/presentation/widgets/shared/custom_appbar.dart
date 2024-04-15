import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                final movieRepository = ref.read(movieRepositoryProvider);

                showSearch(
                  context: context,
                  //delegate es el objeto que se encarga de manejar la busqueda
                  delegate: SearchMovieDelegate( 
                    //no estamos creando un provider nuevo, estamos pasando el movieRepository que ya creamos
                    searchMovies: movieRepository.searchMovies
                  )
              );
              },
            )
          ],
        ),
      ),
    ));
  }
}
