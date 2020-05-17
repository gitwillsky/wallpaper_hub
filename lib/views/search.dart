import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/model/photo_src.dart';
import 'package:wallpaper_hub/model/photos.dart';
import 'package:wallpaper_hub/widgets/widget.dart';

class Search extends StatefulWidget {
  final String searchQuery;

  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<PhotoSrc> searchedPhotoSrcs = List();
  int currentPage = 1;
  int totalPage = 0;
  bool isLoading = false;

  Future<void> getSearchedWallpapers({String query}) async {
    if (currentPage == totalPage) {
      return;
    }
    if (query != null) {
      currentPage = 1;
      totalPage = 0;
    }

    try {
      Photos photos = await getSearchWallpapers(
        query: query ?? widget.searchQuery,
        page: currentPage,
      );

      if (!mounted) return;
      setState(() {
        currentPage++;
        totalPage = photos.totalResults;
        searchedPhotoSrcs.addAll(photos.photos.map((e) => e.src));
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
    getSearchedWallpapers();
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
                    hintText: widget.searchQuery,
                    suffixIcon: Icon(Icons.search)),
                onSubmitted: (value) {
                  if (value != '' && value != widget.searchQuery) {
                    getSearchedWallpapers(query: value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: wallpaperList(
                  photoSrcs: searchedPhotoSrcs,
                  context: context,
                  loadMoreFn: getSearchedWallpapers),
            ),
            if (isLoading)
              Center(
                child: RefreshProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
