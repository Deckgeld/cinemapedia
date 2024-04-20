import 'package:cinemapedia/domain/entitites/actor.dart';
import 'package:cinemapedia/infrastructure/models/credit_response.dart';

class ActorMapper {
  static Actor castToEntity( Cast cast ) {
    return Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null 
        ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
        : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png',
      character: cast.character
    );
  }
}