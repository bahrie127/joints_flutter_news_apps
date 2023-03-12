import 'dart:convert';

import 'package:flutter_joints_news_apps/article_model.dart';
import 'package:http/http.dart' as http;

class NetworkManager {
  Future<List<Article>> getAllNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=id&apiKey=412c98bdbbbe4762a921933c5097bd84'));
    return ArticleModel.fromJson(json.decode(response.body)).articles!;
  }

  Future<List<Article>> getSearchNews(String search) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=id&apiKey=412c98bdbbbe4762a921933c5097bd84&q=$search'));
    return ArticleModel.fromJson(json.decode(response.body)).articles!;
  }
}
