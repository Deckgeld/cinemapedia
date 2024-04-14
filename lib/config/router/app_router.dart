import 'package:cinemapedia/presentation/screen/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      //Definimos las rutas hijas, esto nos ayudara con el deeo linking
      routes: [
        GoRoute(
            path: 'movie/:movieId',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id';
              return MovieScreen(movieId: movieId);
            }),
      ]),
]);
