import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsden/function.dart';
import 'package:newsden/models/article_model.dart';
import 'package:newsden/models/showCategoryModel.dart';
import 'package:newsden/pages/article_view.dart';
import 'package:newsden/services/show_category_news.dart';

class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> categories = [];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNews();
    loadFavoriteArticles();
  }

  getNews() async {
    setState(() {
      _loading = true;
    });
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoriesNews(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {
      _loading = false;
    });
  }

  List<ArticleModel> favoriteArticles = [];

  Future<void> loadFavoriteArticles() async {
    favoriteArticles = await getFavoriteArticles();
    setState(() {});
  }

  bool isFavorite(ArticleModel article) {
    return favoriteArticles
        .any((favArticle) => favArticle.title == article.title);
  }

  void toggleFavorite(ArticleModel article) async {
    if (isFavorite(article)) {
      await removeFavoriteArticle(article);
    } else {
      await saveFavoriteArticle(article);
    }
    loadFavoriteArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final article = categories[index];
                      final isFav = isFavorite(article);
                      print(isFav);
                      return Stack(
                        children: [
                          ShowCategory(
                            image: categories[index].urlToImage!,
                            desc: categories[index].description!,
                            title: categories[index].title!,
                            url: categories[index].url!,
                          ),
                          Positioned(
                              top: 5,
                              right: 5,
                              child: isFav
                                  ? InkWell(
                                      onTap: () async {
                                        await removeFavoriteArticle(
                                                categories[index])
                                            .then((value) {
                                          loadFavoriteArticles();
                                          print("removed");
                                        });
                                      },
                                      child: Container(
                                          height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.black,
                                        ),
                                      ))
                                  : InkWell(
                                      onTap: () async {
                                        await saveFavoriteArticle(
                                                categories[index])
                                            .then((value) {
                                          loadFavoriteArticles();
                                          print("saved");
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                        child: Icon(
                                          Icons.favorite_outline,
                                          color: Colors.black,
                                        ),
                                      ))
                              // ? InkWell(
                              //     onTap: () async {
                              //       await removeFavoriteArticle(categories[index])
                              //           .then((value) {
                              //         loadFavoriteArticles();
                              //         print("removed");
                              //       });
                              //     },
                              //     child: Icon(
                              //       Icons.favorite_outline,
                              //       color: Colors.black,
                              //     ))
                              // : InkWell(
                              //     onTap: () async {
                              //       await saveFavoriteArticle(categories[index])
                              //           .then((value) {
                              //         loadFavoriteArticles();
                              //         print("saved");
                              //       });
                              //     },
                              //     child: Icon(
                              //       Icons.favorite,
                              //       color: Colors.black,
                              //     ))
                              ),
                        ],
                      );
                    }),
              ));
  }
}

class ShowCategory extends StatelessWidget {
  String image, desc, title, url;
  ShowCategory(
      {required this.image,
      required this.desc,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              maxLines: 3,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
