import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsden/function.dart';
import 'package:newsden/home.dart';
import 'package:newsden/models/article_model.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<ArticleModel> favoriteArticles = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    favoriteArticles = await getFavoriteArticles();
    favoriteArticles.forEach((article) {
      print(article.title);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: favoriteArticles.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        BlogTile(
                          url: favoriteArticles[index].url!,
                          desc: favoriteArticles[index].description!,
                          imageurl: favoriteArticles[index].urlToImage!,
                          title: favoriteArticles[index].title!,
                          showClose: true,
                        ),
                        Positioned(
                            top: 15,
                            right: 15,
                            child: InkWell(
                                onTap: () async {
                                  await removeFavoriteArticle(
                                          favoriteArticles[index])
                                      .then((value) => getData());
                                  // setState(() {});
                                  // await saveFavoriteArticle(
                                  //         articles[index])
                                  //     .then((value) => print("saved"));

                                  // });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ))),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
