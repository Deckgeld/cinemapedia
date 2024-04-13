import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb_response.dart';

class MoviesDataSourceImpl extends MoviesDataSource {
  //Instalamos la dependencia de dio
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      }));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    //Obtenemos las peliculas que se estan reproduciendo actualmente
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page
      });

    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
      //Filtramos las peliculas que no tengan poster
      .where((moviedb) => moviedb.posterPath != 'no-poster')
      //Mapeamos las peliculas a la entidad
      .map(
        (movieDB) => MovieMapper.movieDBToEntity(movieDB)
      ).toList();

    return movies;
  }
}
