import 'package:cinemapedia/domain/entitites/actor.dart';

abstract class ActorsRepository {
  Future<List<Actor>> getActorsByMovie(String movieId);
}