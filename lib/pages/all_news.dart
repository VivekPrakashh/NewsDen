import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsden/models/article_model.dart';
import 'package:newsden/models/slidermodel.dart';
import 'package:newsden/pages/article_view.dart';
import 'package:newsden/services/news.dart';
import 'package:newsden/services/slider_data.dart';

class AllNews extends StatefulWidget {
 String news;
   AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
   List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    getSlider();
    getNews();
  }


    getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    Sliders sliderclass = Sliders();
    await sliderclass.getSlider();
    sliders = sliderclass.sliders;
    setState(() {
      _loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
          widget.news+" News",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child:  ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount:widget.news=="Breaking"? sliders.length:articles.length,
                        itemBuilder: (context, index) {
                          return AllNewsSection(
                         image:widget.news=="Breaking"? sliders[index].urlToImage! : articles[index].urlToImage!,
                         desc:widget.news=="Breaking"? sliders[index].description! : articles[index].description!,
                         title:widget.news=="Breaking"? sliders[index].title! : articles[index].title!,
                          url:widget.news=="Breaking"? sliders[index].url! : articles[index].url!,
                          );
                        }),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
 String image, desc, title, url;
 AllNewsSection({required this.image, required this.desc, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: image,
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
               ),
            ),
            SizedBox(height: 5,),
             Text(title,
             maxLines: 2,
             style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
             Text(desc,
             maxLines: 3,
             ),
             SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}