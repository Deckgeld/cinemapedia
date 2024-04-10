import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

import '../../providers/providers.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  //cambio de StatefulWidget a ConsumerStatefulWidget
  const _HomeView();

  @override
  _HomeViewState createState() =>
      _HomeViewState(); //cambio de State<_HomeView> a _HomeViewState
}

class _HomeViewState extends ConsumerState<_HomeView> {
  //cambio de State<_HomeView> a ConsumerState<_HomeView>
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return Column(
      children: [
        const CustomAppbar(),

        MoviesSlideshow(movies: slideShowMovies,)
      ],
    );
  }
}
