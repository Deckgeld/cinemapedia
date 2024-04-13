import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListView extends StatelessWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListView(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (title != null || subTitle != null)
            _Title(title: title, suTitle: subTitle),
          Expanded(
            //Cuando no podamos hacer scroll infinito usaremos un ListView.builder, de lo contrario usaremos un ListView normal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return _Slide(movie: movies[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      //Agregamos un margen a cada slide
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //* Image
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                fit: BoxFit.cover,
                movie.posterPath,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return FadeIn(child: child);

                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },

              ),
            ),
          ),

          const SizedBox(height: 5),

          //* Title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            ),
          ),

          Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.yellow.shade800),
              Text('${movie.voteAverage}', style: textStyle.bodyMedium?.copyWith( color: Colors.yellow.shade800 ) ),
              
              const SizedBox(width: 10),

              Text('${movie.popularity}', style: textStyle.bodySmall),
            ],)

        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? suTitle;

  const _Title({this.title, this.suTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (suTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(suTitle!),
              onPressed: () {},
            )
        ],
      ),
    );
  }
}
