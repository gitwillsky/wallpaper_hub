import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/model/photo_src.dart';
import 'package:wallpaper_hub/model/photos.dart';
import 'package:wallpaper_hub/widgets/widget.dart';

class Category extends StatefulWidget {
  final String category;
  Category({@required this.category});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<PhotoSrc> photoSrcs = List();
  int currentPage = 1;
  int totalPage = 0;
  bool isLoading = false;

  Future<void> getCategoryPhotos() async {
    if (currentPage == totalPage || isLoading) {
      return;
    }
    try {
      Photos photos =
          await getSearchWallpapers(query: widget.category, page: currentPage);

      if (!mounted) return;
      setState(() {
        totalPage = photos.totalResults;
        currentPage++;
        photoSrcs.addAll(photos.photos.map((e) => e.src));
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
    getCategoryPhotos();
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
            SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: wallpaperList(
                  photoSrcs: photoSrcs,
                  context: context,
                  loadMoreFn: getCategoryPhotos),
            )
          ],
        ),
      ),
    );
  }
}
