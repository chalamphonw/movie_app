import 'package:flutter/material.dart';
import 'add_edit_movie_page.dart';
import 'database_helper.dart' as dbHelperLib;
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
            key: Key(movie.id.toString()), // เพิ่ม key ให้กับ Dismissible
            onDismissed: (direction) async {
              await dbHelper.deleteMovie(movie.id!);
              _refreshMovieList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ภาพยนตร์ถูกลบแล้ว')),
              );
            },
            background: Container(color: Colors.red),
            child: ListTile(
              key: Key('movie_${movie.id}'), // เพิ่ม key ให้กับ ListTile
              title: Text(movie.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('คะแนน: ${movie.rating}'),
                  Text('ประเภท: ${movie.genre}'),
                  Text('วันที่ฉาย: ${movie.releaseDate.toLocal()}'), // เพิ่มวันที่ฉาย
                ],
              ),
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