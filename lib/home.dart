import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:newsden/function.dart';
import 'package:newsden/models/article_model.dart';
import 'package:newsden/models/categorymodel.dart';
import 'package:newsden/models/slidermodel.dart';
import 'package:newsden/pages/all_news.dart';
import 'package:newsden/pages/article_view.dart';
import 'package:newsden/pages/category_news.dart';
import 'package:newsden/pages/favorite.dart';
import 'package:newsden/pages/searchPage.dart';
import 'package:newsden/services/data.dart';
import 'package:newsden/services/news.dart';

import 'package:newsden/services/slider_data.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ArticleModel> favoriteArticles = [];

  Future<void> loadFavoriteArticles() async {
    favoriteArticles = await getFavoriteArticles();
    setState(() {});
  }

  bool isFavorite(ArticleModel article) {
    return favoriteArticles.any((favArticle) => favArticle.url == article.url);
  }

  void toggleFavorite(ArticleModel article) async {
    if (isFavorite(article)) {
      await removeFavoriteArticle(article);
    } else {
      await saveFavoriteArticle(article);
    }
    loadFavoriteArticles();
  }

  List<CategoryModel> categgories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  List<String> favoriteDataList = [];
  bool _loading = true;
  int activeindex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categgories = getCategories();
    getSlider();
    getNews();
    // getData();
    loadFavoriteArticles();
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              'Den',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Favrouit button
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favorite()));
              },
              icon: Icon(Icons.favorite))
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search for news..."),
                            Icon(Icons.search_outlined)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 90,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categgories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            image: categgories[index].image,
                            categoryName: categgories[index].categoryName,
                          );
                        },
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Breaking News!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllNews(news: "Breaking")));
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CarouselSlider.builder(
                      itemCount: 5,
                      itemBuilder: (context, index, realIndex) {
                        String? res = sliders[index].urlToImage;
                        String? res1 = sliders[index].title;
                        return buildImage(res!, index, res1!);
                      },
                      options: CarouselOptions(
                        height: 250,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeindex = index;
                          });
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  buildIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trending News!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllNews(news: "Trending")));
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final isFav = isFavorite(article);
                          return Stack(
                            children: [
                              BlogTile(
                                url: articles[index].url!,
                                desc: articles[index].description!,
                                imageurl: articles[index].urlToImage!,
                                title: articles[index].title!,
                              ),
                              Positioned(
                                  top: 15,
                                  right: 15,
                                  child: isFav
                                      ? InkWell(
                                          onTap: () async {
                                            await removeFavoriteArticle(
                                                    articles[index])
                                                .then((value) =>
                                                    loadFavoriteArticles());

                                            // });
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.black,
                                          ))
                                      : InkWell(
                                          onTap: () async {
                                            await saveFavoriteArticle(
                                                    articles[index])
                                                .then((value) {
                                              loadFavoriteArticles();
                                              print("saved");
                                            });

                                            // });
                                          },
                                          child: Icon(
                                            Icons.favorite_outline,
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

  Widget buildImage(String image, int index, String name) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                imageUrl: image,
              ),
            ),
            Container(
              height: 250,
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: 170),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeindex,
        count: 5,
        effect: const SlideEffect(
            dotHeight: 15,
            dotWidth: 15,
            dotColor: Colors.grey,
            activeDotColor: Colors.blue),
      );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  const CategoryTile({super.key, this.image, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  image,
                  width: 120,
                  height: 70,
                  fit: BoxFit.cover,
                )),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                categoryName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatefulWidget {
  String imageurl, title, desc, url;
  bool showClose;
  BlogTile(
      {required this.desc,
      required this.imageurl,
      required this.title,
      this.showClose = false,
      required this.url});

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(blogUrl: widget.url)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageurl,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: Text(
                        widget.desc,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
