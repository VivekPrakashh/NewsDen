import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsden/models/article_model.dart';
import 'package:newsden/models/showCategoryModel.dart';
import 'package:newsden/models/slidermodel.dart';

class ShowCategoryNews {
  List<ArticleModel> categories = [];

  Future<void> getCategoriesNews(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=9551624e365b48a9a0b9beef86e105d3";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel categoryNewsModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          categories.add(categoryNewsModel);
        }
      });
    }
  }
}

class SearchApi {
  List<ArticleModel> categories = [];

  Future<void> getSearchNews(String search) async {
    String url =
        "https://newsapi.org/v2/everything?q=$search market&from=2024-05-05&sortBy=publishedAt&apiKey=9551624e365b48a9a0b9beef86e105d3";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel categoryNewsModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          categories.add(categoryNewsModel);
        }
      });
    }
  }
}
