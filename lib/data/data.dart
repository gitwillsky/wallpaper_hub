import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wallpaper_hub/model/category.dart';
import 'package:wallpaper_hub/model/photos.dart';

const _apikey = '563492ad6f9170000100000129494520662d4782a803d457b961de3e';

Dio _dio = Dio(BaseOptions(
  baseUrl: 'https://api.pexels.com/v1',
  connectTimeout: 5000,
  receiveTimeout: 5000,
  headers: {'Authorization': _apikey},
));

/// 获取热门图片
Future<Photos> getTrendingWallpapers(
    {@required int page, int pageSize = 15}) async {
  var response = await _dio.get('/curated?per_page=$pageSize&page=$page');
  return Photos.fromJson(response.data);
}

/// 搜素
Future<Photos> getSearchWallpapers(
    {@required String query, @required int page, int pageSize = 15}) async {
  var response =
      await _dio.get('/search?query=$query&per_page=$pageSize&page=$page');
  return Photos.fromJson(response.data);
}

// 获取图片数据
Future<Response> getImageData({@required String imgSrc}) async {
  return _dio.get(imgSrc, options: Options(responseType: ResponseType.bytes));
}

List<CategoryModel> getCategories() {
  return [
    CategoryModel('Street Art',
        'https://images.pexels.com/photos/545008/pexels-photo-545008.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
    CategoryModel('Wild Life',
        'https://images.pexels.com/photos/704320/pexels-photo-704320.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
    CategoryModel('Nature',
        'https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
    CategoryModel('City',
        'https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
    CategoryModel('Motivation',
        'https://images.pexels.com/photos/1434819/pexels-photo-1434819.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
    CategoryModel('Bikes',
        'https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
    CategoryModel('Cars',
        'https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
  ];
}
