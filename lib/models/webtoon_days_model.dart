class WebtoonDayModel {
  final int id;
  final String thumb, title;

  WebtoonDayModel.fromJson(Map<String, dynamic> json)
      : id = json['webtoonId'] - 1000000000000,
        thumb = json['img'],
        title = json['title'];
}
