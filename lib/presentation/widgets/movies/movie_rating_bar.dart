import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieRatingBar extends StatelessWidget {
  final double movieRating;
  final double? itemSize;
  const MovieRatingBar({super.key, required this.movieRating, this.itemSize});

  @override
  Widget build(BuildContext context) {
    final finalMvieRating = movieRating / 2;

    return RatingBarIndicator(
      itemSize: itemSize ?? 20.0,
      rating: finalMvieRating,
      //allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.yellow,
      ),
    );
    
  }
}
