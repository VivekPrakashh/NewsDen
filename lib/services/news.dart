import 'dart:convert';

import 'package:newsden/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{
  List<ArticleModel> news=[];



  Future<void> getNews()async{
    String url="https://newsapi.org/v2/everything?q=tesla&from=2024-05-05&sortBy=publishedAt&apiKey=9551624e365b48a9a0b9beef86e105d3";
    var response= await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData["articles"].forEach((element){
        if(element['urlToImage']!=null && element['description']!=null){
          ArticleModel articleModel=ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],

          );
          news.add(articleModel);
        }
      });
    }
  }
}