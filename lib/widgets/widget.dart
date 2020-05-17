import 'package:flutter/material.dart';
import 'package:wallpaper_hub/model/photo_src.dart';
import 'package:wallpaper_hub/views/image_view.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 16), children: <TextSpan>[
      TextSpan(
          text: 'Wallpaper',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      TextSpan(
        text: 'Hub',
        style: TextStyle(color: Colors.blue),
      )
    ]),
  );
}

typedef Future<void> LoadMoreCallback();

Widget wallpaperList(
    {@required List<PhotoSrc> photoSrcs,
    BuildContext context,
    @required LoadMoreCallback loadMoreFn}) {
  return GridView.builder(
    shrinkWrap: true,
    padding: EdgeInsets.symmetric(horizontal: 16),
    physics: ClampingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0),
    itemCount: photoSrcs.length,
    itemBuilder: (context, index) {
      if (index == photoSrcs.length - 1) {
        loadMoreFn();
      }
      return Hero(
        tag: photoSrcs[index].portrait,
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgSrc: photoSrcs[index].portrait,
                          )));
            },
            child: Container(
              child: ClipRRect(
                child:
                    Image.network(photoSrcs[index].portrait, fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      );
    },
  );
}
