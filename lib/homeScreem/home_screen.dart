import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_application/api/api.dart';
import 'package:movie_application/models/movie.dart';
import 'package:movie_application/screens/categories_screen.dart';
import 'package:movie_application/widgets/movies_slider.dart';
import 'package:movie_application/widgets/trending_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upComingMovies;
  Set<int> favoriteMovieIds = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    upComingMovies = Api().getUpcomingMovies();
  }

  void toggleFavorite(int movieId) {
    setState(() {
      if (favoriteMovieIds.contains(movieId)) {
        favoriteMovieIds.remove(movieId);
      } else {
        favoriteMovieIds.add(movieId);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/gordo.jpg',
          fit: BoxFit.cover,
          height: 60,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : _selectedIndex == 1
              ? const CategoriesScreen()
              : _buildFavoriteContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritas',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peliculas en tendencia',
            style: GoogleFonts.aBeeZee(fontSize: 25),
          ),
          const SizedBox(height: 32),
          FutureBuilder<List<Movie>>(
            future: trendingMovies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                return TrendingSlider(
                  snapshot: snapshot,
                  toggleFavorite: toggleFavorite,
                  favoriteMovieIds: favoriteMovieIds,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          Text(
            'Top mejores peliculas',
            style: GoogleFonts.aBeeZee(fontSize: 25),
          ),
          const SizedBox(height: 32),
          FutureBuilder<List<Movie>>(
            future: topRatedMovies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                return MoviesSlider(
                  snapshot: snapshot,
                  toggleFavorite: toggleFavorite,
                  favoriteMovieIds: favoriteMovieIds,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          Text(
            'Pelicula estreno',
            style: GoogleFonts.aBeeZee(fontSize: 25),
          ),
          const SizedBox(height: 32),
          FutureBuilder<List<Movie>>(
            future: upComingMovies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                return MoviesSlider(
                  snapshot: snapshot,
                  toggleFavorite: toggleFavorite,
                  favoriteMovieIds: favoriteMovieIds,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteContent() {
    return FutureBuilder<List<Movie>>(
      future: Api().getFavoriteMovies(favoriteMovieIds),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peliculas Favoritas',
                  style: GoogleFonts.aBeeZee(fontSize: 25),
                ),
                const SizedBox(height: 32),
                MoviesSlider(
                  snapshot: snapshot,
                  toggleFavorite: toggleFavorite,
                  favoriteMovieIds: favoriteMovieIds,
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
