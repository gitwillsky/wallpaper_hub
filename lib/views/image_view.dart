import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final String imgSrc;

  ImageView({@required this.imgSrc});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool showButtons = true;

  _askPermission() async {
    var photoStatus = await Permission.photos.status;
    if (photoStatus.isUndetermined) {
      await [Permission.photos].request();
    }
    var fileStatus = await Permission.storage.status;
    if (fileStatus.isUndetermined) {
      await [Permission.storage].request();
    }
  }

  _save() async {
    try {
      await _askPermission();
      var response = await getImageData(imgSrc: widget.imgSrc);
      final result = await ImageGallerySaver.saveImage(response.data);
      print(result);
      if (Platform.isAndroid) {
        await WallpaperManager.setWallpaperFromFile(
            Uri.parse(result).toFilePath(), WallpaperManager.HOME_SCREEN);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.imgSrc,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () => {setState(() => showButtons = !showButtons)},
                child: ExtendedImage.network(
                  widget.imgSrc,
                  fit: BoxFit.cover,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (ExtendedImageState state) {
                    return GestureConfig(
                      inPageView: true,
                      initialScale: 1.0,
                      cacheGesture: true,
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: showButtons,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await _save();
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title:
                                    Text('${Platform.isIOS ? '设置' : '保存'}成功'),
                                content: Text(
                                    Platform.isIOS ? '已经保存进相册' : '已经设置为壁纸'),
                                actions: <Widget>[
                                  CupertinoButton(
                                    child: Text('确定'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  )
                                ],
                              );
                            });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xff1c1b1b).withOpacity(0.4),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.white60),
                                gradient: LinearGradient(colors: [
                                  Color(0x36FFFFFF),
                                  Color(0x0FFFFFFF),
                                ])),
                            child: Text(
                              Platform.isIOS ? '保存进相册' : '设置为壁纸',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
