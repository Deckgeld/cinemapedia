import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final movies = ref.read(nowPlayingProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingProvider);

    if (nowPlayingMovies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
        itemCount: nowPlayingMovies.length,
        itemBuilder: (context, index) {
          final movie = nowPlayingMovies[index];
          return ListTile(
            title: Text( movie.title ),

          );
        });
  }
}
