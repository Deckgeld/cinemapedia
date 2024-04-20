import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingProvider);

  if (nowPlayingMovies.isEmpty) {
    return const [];
  }
  return nowPlayingMovies.sublist(0, 6);
  
});
