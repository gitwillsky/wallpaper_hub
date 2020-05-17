import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/model/category.dart';
import 'package:wallpaper_hub/model/photo_src.dart';
import 'package:wallpaper_hub/views/category.dart';
import 'package:wallpaper_hub/views/search.dart';
import 'package:wallpaper_hub/widgets/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories;
  int currentPage = 1;
  int totalPage = 0;
  bool isLoading = false;
  List<PhotoSrc> trendingPhotos = List();

  Future<void> getTrending() async {
    if (currentPage == totalPage || isLoading) {
      return;
    }
    try {
      isLoading = true;
      var photos = await getTrendingWallpapers(page: currentPage);
      if (!mounted) return;
      setState(() {
        totalPage = photos.totalResults;
        currentPage++;
        trendingPhotos.addAll(photos.photos.map((e) => e.src));
      });
    } catch (e) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('加载失败'),
              actions: <Widget>[
                CupertinoButton(
                  child: Text('确定'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    } finally {
      isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getTrending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        // remove app bar shadow
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xfff5f8fd)),
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'search',
                    suffixIcon: Icon(Icons.search)),
                onSubmitted: (value) {
                  if (value != "") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(
                            searchQuery: value,
                          ),
                        ));
                  }
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoriesTile(
                    title: categories[index].name,
                    imgURL: categories[index].imgURL,
                  );
                },
              ),
            ),
            Expanded(
              child: wallpaperList(
                  photoSrcs: trendingPhotos,
                  context: context,
                  loadMoreFn: getTrending),
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgURL, title;

  CategoriesTile({@required this.title, @required this.imgURL});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Category(category: title.toLowerCase()),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imgURL,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 50,
                width: 100,
                color: Colors.black26,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
