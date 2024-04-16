import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/infrastructure/models/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB movieDB) => Movie(
      adult: movieDB.adult,
      //Validamos si el backdropPath es vacio para asignar una imagen por defecto
      backdropPath: (movieDB.backdropPath != '' )
        ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}' 
        : 'https://ih1.redbubble.net/image.1027712254.9762/pp,840x830-pad,1000x1000,f8f8f8.u2.jpg',
      //Es necesario convertir los generos a string para que el modelo de datos sea consistente
      genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      //Validamos si el posterPath es vacio para asignar una imagen por defecto
      posterPath: (movieDB.posterPath != '')
      //ODIO ESTA LINEA
        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}' 
        //Esto no sirve para filtrar las peliculas, dentro de moviedb_datasource.dart
        : 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.istockphoto.com%2Fvectors%2Fno-image-available-sign-vector-id1138179183%3Fk%3D6%26m%3D1138179183%26s%3D612x612%26w%3D0%26h%3DprMYPP9mLRNpTp3XIykjeJJ8oCZRhb2iez6vKs8a8eE%3D&f=1&nofb=1&ipt=ffb8f9315d1ed861f2ee216c3b6dfab0c59149e020b31b6259f261458c80ff2b&ipo=images',
      
      releaseDate: movieDB.releaseDate != null ? movieDB.releaseDate! : DateTime.now(),
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount
    );

  static Movie movieDetailsToEntity(MovieDetails movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: (movieDB.backdropPath != '' )
        ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}' 
        : 'https://ih1.redbubble.net/image.1027712254.9762/pp,840x830-pad,1000x1000,f8f8f8.u2.jpg',
      genreIds: movieDB.genres.map((e) => e.name).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: (movieDB.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}' 
        : 'no-poster',
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount
    );
}