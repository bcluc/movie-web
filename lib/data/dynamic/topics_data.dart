import 'package:movie_web/main.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/models/topic.dart';

List<Topic> topicsData = [];

Future<void> fetchTopicsData() async {
  // topicsData = await supabase.from('topic').select('''
  //     name,
  //     films: film(id, poster_path)
  //   ''').order(
  //   'order',
  //   ascending: true,
  // );

  final topics = await supabase.from('topic').select().order(
        'order',
        ascending: true,
      );

  for (var topic in topics) {
    final posters = await supabase
        .from('topic_film')
        .select('''
      film(id, poster_path)
      ''')
        .eq(
          'topic_id',
          topic['id'],
        )
        .order('priority');

    topicsData.add(
      Topic(
        name: topic['name'],
        posters: List.generate(
          posters.length,
          (index) => Poster(
            filmId: posters[index]['film']['id'],
            posterPath: posters[index]['film']['poster_path'],
          ),
        ),
      ),
    );
  }
}
