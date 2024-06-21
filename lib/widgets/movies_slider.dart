import 'package:flutter/material.dart';
import 'package:movie_application/constants.dart';
import 'package:movie_application/screens/details_screens.dart';
import 'package:movie_application/models/movie.dart';

class MoviesSlider extends StatelessWidget {
  const MoviesSlider({
    super.key,
    required this.snapshot,
    required this.toggleFavorite,
    required this.favoriteMovieIds,
  });

  final AsyncSnapshot<List<Movie>> snapshot;
  final Function(int) toggleFavorite;
  final Set<int> favoriteMovieIds;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final movie = snapshot.data![index];
          final isFavorite = favoriteMovieIds.contains(movie.id);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(movie: movie),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Image.network(
                        '${Constants.imagePath}${movie.posterPath}',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        toggleFavorite(movie.id);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color.fromARGB(255, 17, 17, 215),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
