import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsden/function.dart';
import 'package:newsden/models/article_model.dart';
import 'package:newsden/pages/category_news.dart';
import 'package:newsden/services/show_category_news.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ArticleModel> categories = [];
  bool _loading = false;

  getNews(search) async {
    setState(() {
      _loading = true;
    });
    SearchApi newsData = SearchApi();
    await newsData.getSearchNews(search);
    categories = newsData.categories;
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

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search News",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        // height: 40,
                        child: TextField(
                          autofocus: true,
                          controller: _controller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for news"),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          getNews(_controller.text);
                        },
                        child: Icon(Icons.search_outlined))
                  ],
                ),
              ),
            ),
            _loading
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
                                  top: 15,
                                  right: 15,
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
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.black,
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
                                          child: Icon(
                                            Icons.favorite_outline,
                                            color: Colors.black,
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
                  )
          ],
        ),
      ),
    );
  }
}
