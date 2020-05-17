import 'package:json_annotation/json_annotation.dart';

import 'base.dart';
import 'photo_src.dart';

part 'photos.g.dart';

@JsonSerializable()
class Photos extends Base<Photos> {
  int id, width, height;
  String url;

  @JsonKey(name: 'photographer')
  String photoGrapher;

  PhotoSrc src;

  Photos(this.id, this.width, this.height, this.url, this.photoGrapher,
      this.src, page, int perPage, int totalResults, List<Photos> photos)
      : super(page, perPage, totalResults, photos);

  factory Photos.fromJson(Map<String, dynamic> json) => _$PhotosFromJson(json);
  Map<String, dynamic> toJson() => _$PhotosToJson(this);
}
