import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_application/api/api.dart';
import 'package:movie_application/models/movie.dart';
import 'package:movie_application/widgets/movies_slider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<dynamic>> genres;
  Map<int, Future<List<Movie>>> genreMovies = {};
  Set<int> favoriteMovieIds = {}; 

  @override
  void initState() {
    super.initState();
    genres = Api().getGenres();
    genres.then((genreList) {
      for (var genre in genreList) {
        genreMovies[genre['id']] = Api().getMoviesByGenre(genre['id']);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: genres,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            final genreList = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: genreList.map<Widget>((genre) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      genre['name'],
                      style: GoogleFonts.aBeeZee(fontSize: 25),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Movie>>(
                      future: genreMovies[genre['id']],
                      builder: (context, genreSnapshot) {
                        if (genreSnapshot.hasError) {
                          return Center(child: Text(genreSnapshot.error.toString()));
                        } else if (genreSnapshot.hasData) {
                          return MoviesSlider(
                            snapshot: AsyncSnapshot<List<Movie>>.withData(
                              ConnectionState.done,
                              genreSnapshot.data!,
                            ),
                            toggleFavorite: toggleFavorite, 
                            favoriteMovieIds: favoriteMovieIds, 
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
