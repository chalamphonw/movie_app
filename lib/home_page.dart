import 'package:flutter/material.dart';
import 'add_edit_movie_page.dart';
// ignore: library_prefixes
import 'database_helper.dart' as dbHelperLib;
// ignore: library_prefixes
import 'movie_model.dart' as movieModelLib;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = dbHelperLib.DatabaseHelper.instance;
  List<movieModelLib.Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _refreshMovieList();
  }

  Future<void> _refreshMovieList() async {
    final movieList = await dbHelper.getMovies();
    setState(() {
      movies = movieList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Dismissible(
            key: Key(movie.id.toString()),
            onDismissed: (direction) async {
              await dbHelper.deleteMovie(movie.id!);
              _refreshMovieList();
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ภาพยนตร์ถูกลบแล้ว')),
              );
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(movie.title),
              subtitle: Text('คะแนน: ${movie.rating}, ประเภท: ${movie.genre}'),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditMoviePage(movie: movie),
                  ),
                );
                if (result != null) {
                  await dbHelper.updateMovie(result);
                  _refreshMovieList();
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditMoviePage()),
          );
          if (result != null) {
            await dbHelper.insertMovie(result);
            _refreshMovieList();
          }
        },
        tooltip: 'เพิ่มภาพยนตร์',
        child: const Icon(Icons.add),
      ),
    );
  }
}