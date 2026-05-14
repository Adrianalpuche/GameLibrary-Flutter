import 'dart:convert';

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
    genre = Genre.fromJson(
      json['genre'] is String
        ? jsonDecode(json['genre'])
        : json['genre'],
    ),
    developer = Developer.fromJson(
      json['developer'] is String
        ? jsonDecode(json['developer'])
        : json['developer'],
    ),
    releaseDate = DateTime.parse(json['releaseDate']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'description': description,
    'genre': genre.toJson(),
    'developer': developer.toJson(),
    'releaseDate': releaseDate.toIso8601String(),
  };
}

class Genre {
  int id;
  String name;

  Genre({required this.id, required this.name});

  Genre.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) => other is Genre && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class Developer {
  int id;
  String name;

  Developer({required this.id, required this.name});

  Developer.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) => other is Developer && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
