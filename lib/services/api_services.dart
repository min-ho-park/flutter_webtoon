import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/models/webtoon_favorite_model.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/models/webtoon_days_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static const String dayWebtoonUrl =
      "https://korea-webtoon-api.herokuapp.com/?perPage=0&page=1&service=naver&updateDay=";

  //웹툰 전체
  static Future<List<WebtoonModel>> getTodaysToon() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  //웹툰 정보
  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  //웹툰 에피소드 목록
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];

    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);

      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }

  //요일별 웹툰
  static Future<List<WebtoonDayModel>> getDaysToon(String day) async {
    List<WebtoonDayModel> dayWebtoonInstances = [];
    final url = Uri.parse('$dayWebtoonUrl$day');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body)['webtoons'];

      for (var webtoon in webtoons) {
        dayWebtoonInstances.add(WebtoonDayModel.fromJson(webtoon));
      }
      return dayWebtoonInstances;
    }
    throw Error();
  }

  //즐겨찾기 정보
  static Future<List<WebtoonFavoriteModel>> getFavoriteToonById(
      List favoriteToon) async {
    List<WebtoonFavoriteModel> favoriteWebtoonInstances = [];
    final List<dynamic> favoriteWebtoons;

    for (var favoriteToon in favoriteToon) {
      final url = Uri.parse("$baseUrl/$favoriteToon");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        favoriteWebtoonInstances
            .add(WebtoonFavoriteModel.fromJson(jsonDecode(response.body)));
      }
    }
    return favoriteWebtoonInstances;
  }
}
