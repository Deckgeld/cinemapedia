import 'package:cinemapedia/domain/entitites/movie.dart';
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
        : 'no-poster',
      
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount);
}
