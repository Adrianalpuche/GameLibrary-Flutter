class Games {
  int id;
  String title;
  String imageUrl;
  String description;
  Genre genre;
  Developer developer;
  DateTime releaseDate;

  Games({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.genre,
    required this.developer,
    required this.releaseDate,
  });


  Games.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['imageUrl'],
        description = json['description'],
        genre = Genre.fromJson(json['genre']),
        developer = Developer.fromJson(json['developer']),
        releaseDate = DateTime.parse(json['releaseDate']);

}


class Genre {
  int id;
  String name;

  Genre({
    required this.id,
    required this.name,
  });

  Genre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Developer {
  int id;
  String name;

  Developer({
    required this.id,
    required this.name,
  });

  Developer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

