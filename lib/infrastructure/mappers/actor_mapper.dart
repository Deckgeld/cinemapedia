import 'package:cinemapedia/domain/entitites/actor.dart';
import 'package:cinemapedia/infrastructure/models/credit_response.dart';

class ActorMapper {
  static Actor castToEntity( Cast cast ) {
    return Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null 
        ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
        : 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fgeekwebsolution.com%2Fwp-content%2Fuploads%2F2020%2F06%2Fuser_face.jpg&f=1&nofb=1&ipt=f3f0b5f352ea944d468e383a331b14709a1536fcfc60129170322eff1172217f&ipo=images',
      character: cast.character
    );
  }
}