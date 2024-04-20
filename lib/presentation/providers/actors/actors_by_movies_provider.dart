import 'package:cinemapedia/domain/entitites/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actor_repository_provaider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch(actorsReposotoryProvider);
  return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie);
});


/* Example of a MovieMapNotifier
  {
    '204682': <Actor>[],
    '204683': <Actor>[],
    '204684': <Actor>[],
  }
*/

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> leadActors(String movieId) async {
    if (state[movieId] != null) return;

    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}
