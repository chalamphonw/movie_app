import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'movie_model.dart' as movieModelLib;

class AddEditMoviePage extends StatefulWidget {
  final movieModelLib.Movie? movie;

  const AddEditMoviePage({super.key, this.movie});

  @override
  State<AddEditMoviePage> createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ratingController = TextEditingController();
  String? _genre;
  DateTime _releaseDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _ratingController.text = widget.movie!.rating.toString();
      _genre = widget.movie!.genre;
      _releaseDate = widget.movie!.releaseDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'เพิ่มภาพยนตร์' : 'แก้ไขภาพยนตร์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'ชื่อเรื่อง'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่ชื่อเรื่อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'คะแนน'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่คะแนน';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _genre,
                items: <String>['Action', 'Comedy', 'Drama', 'Sci-Fi']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _genre = newValue;
                  });
                },
                decoration: const InputDecoration(labelText: 'ประเภท'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกประเภท';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final movie = movieModelLib.Movie(
                      id: widget.movie?.id,
                      title: _titleController.text,
                      rating: int.parse(_ratingController.text),
                      genre: _genre!,
                      releaseDate: _releaseDate,
                    );
                    Navigator.pop(context, movie);
                  }
                },
                child: const Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}