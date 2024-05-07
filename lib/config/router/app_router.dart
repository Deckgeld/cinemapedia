import 'package:cinemapedia/presentation/screen/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0', 
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? '0';

        if (int.parse(pageIndex) < 0 || int.parse(pageIndex) > 2) {
          return const HomeScreen( pageIndex: 0 );
        }

        return HomeScreen( pageIndex: int.parse(pageIndex) );
      },
      //Definimos las rutas hijas, esto nos ayudara con el deeo linking
      routes: [
        GoRoute(
            path: 'movie/:movieId',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['movieId'] ?? 'no-id';
              return MovieScreen(movieId: movieId);
            }),
      ]),
      //Ruta por defecto, si no se encuentra ninguna ruta, redirigimos a la ruta home
      GoRoute(
        path: '/',
        //_ y __ son parametros que no se usan
        redirect: (_, __) => '/home/0',
      )
]);
