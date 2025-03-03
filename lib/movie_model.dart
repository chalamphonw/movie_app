class Movie {
  int? id;
  String title;
  int rating;
  String genre;
  DateTime releaseDate;

  Movie({
    this.id,
    required this.title,
    required this.rating,
    required this.genre,
    required this.releaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'genre': genre,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      rating: map['rating'],
      genre: map['genre'],
      releaseDate: DateTime.parse(map['releaseDate']),
    );
  }
}