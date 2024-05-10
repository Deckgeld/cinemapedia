import 'package:cinemapedia/infrastructure/models/movie_details.dart';
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
        // 'language': 'es-MX'
      }));

  //metodo para convertir un MovieDbResponse a una lista de Movie
  List<Movie> _jsonToMoviesList( Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
      //Filtramos las peliculas que no tengan poster
      .where((moviedb) => moviedb.posterPath != 'no-poster')
      //Mapeamos las peliculas a la entidad
      .map(
        (movieDB) => MovieMapper.movieDBToEntity(movieDB)
      ).toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    //Obtenemos las peliculas que se estan reproduciendo actualmente
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page
      });

    return _jsonToMoviesList(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', 
      queryParameters: {
        'page': page
      });

    return _jsonToMoviesList(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', 
      queryParameters: {
        'page': page
      });

    return _jsonToMoviesList(response.data);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', 
      queryParameters: {
        'page': page
      });

    return _jsonToMoviesList(response.data);
  }
  
  @override
  Future<Movie> getMovieDetail( String movieId ) async {
    final response = await dio.get('/movie/$movieId');
    
    if (response.statusCode != 200) throw Exception('Mvie with id $movieId not found');

      final movieDB = MovieDetails.fromJson(response.data);

      return MovieMapper.movieDetailsToEntity(movieDB);
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get('/search/movie', 
      queryParameters: {
        'query': query
      });

    return _jsonToMoviesList(response.data);
  }
  
}
