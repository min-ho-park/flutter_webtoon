class WebtoonFavoriteModel {
  final String title, thumb, id;

  WebtoonFavoriteModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['thumb'];
}
