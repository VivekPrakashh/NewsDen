import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsden/models/slidermodel.dart';

class Sliders{
  List<SliderModel> sliders=[];



  Future<void> getSlider()async{
    String url="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=9551624e365b48a9a0b9beef86e105d3";
    var response= await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData["articles"].forEach((element){
        if(element['urlToImage']!=null && element['description']!=null){
          SliderModel sliderModel=SliderModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],

          );
          sliders.add(sliderModel);
        }
      });
    }
  }
}