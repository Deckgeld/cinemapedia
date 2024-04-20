import 'package:cinemapedia/domain/entitites/actor.dart';

abstract class ActorsDataSource {
  Future<List<Actor>> getActorsByMovie(String movieId );

}