import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_application/constants.dart';
import 'package:movie_application/models/movie.dart';

class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _upComingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';
  static const _genresUrl =
      'https://api.themoviedb.org/3/genre/movie/list?api_key=${Constants.apiKey}';
  static const _moviesByGenreUrl =
      'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&with_genres=';

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upComingUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<dynamic>> getGenres() async {
    final response = await http.get(Uri.parse(_genresUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['genres'] as List;
      return decodeData;
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse('$_moviesByGenreUrl$genreId'));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  Future<List<Movie>> getAllMovies() async {
    final trendingMovies = await getTrendingMovies();
    final topRatedMovies = await getTopRatedMovies();
    final upcomingMovies = await getUpcomingMovies();
    return [...trendingMovies, ...topRatedMovies, ...upcomingMovies];
  }

  Future<List<Movie>> getFavoriteMovies(Set<int> favoriteMovieIds) async {
    List<Movie> allMovies = await getAllMovies();
    return allMovies.where((movie) => favoriteMovieIds.contains(movie.id)).toList();
  }
}
