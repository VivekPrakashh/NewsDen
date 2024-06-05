import 'package:newsden/models/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Save an article to the favorites list
Future<void> saveFavoriteArticle(ArticleModel article) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favoriteArticles = prefs.getStringList('favoriteArticles') ?? [];

  favoriteArticles.add(jsonEncode(article.toMap()));
  await prefs.setStringList('favoriteArticles', favoriteArticles);
}

// Retrieve the list of favorite articles
Future<List<ArticleModel>> getFavoriteArticles() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favoriteArticles = prefs.getStringList('favoriteArticles') ?? [];
  
  return favoriteArticles.map((article) {
    return ArticleModel.fromMap(jsonDecode(article));
  }).toList();
}

// Remove an article from the favorites list
Future<void> removeFavoriteArticle(ArticleModel article) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favoriteArticles = prefs.getStringList('favoriteArticles') ?? [];

  favoriteArticles.removeWhere((item) => ArticleModel.fromMap(jsonDecode(item)).url == article.url);
  await prefs.setStringList('favoriteArticles', favoriteArticles);
}
