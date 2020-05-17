import 'package:json_annotation/json_annotation.dart';

part 'photo_src.g.dart';

@JsonSerializable()
class PhotoSrc {
  String original, large2x, large, medium, small, portrait, landscape, tiny;

  PhotoSrc(this.original, this.large, this.landscape, this.large2x, this.medium,
      this.portrait, this.small, this.tiny);

  factory PhotoSrc.fromJson(Map<String, dynamic> json) =>
      _$PhotoSrcFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoSrcToJson(this);
}
