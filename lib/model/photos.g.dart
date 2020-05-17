// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photos _$PhotosFromJson(Map<String, dynamic> json) {
  return Photos(
    json['id'] as int,
    json['width'] as int,
    json['height'] as int,
    json['url'] as String,
    json['photographer'] as String,
    json['src'] == null
        ? null
        : PhotoSrc.fromJson(json['src'] as Map<String, dynamic>),
    json['page'],
    json['perPage'] as int,
    json['totalResults'] as int,
    (json['photos'] as List)
        ?.map((e) =>
            e == null ? null : Photos.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PhotosToJson(Photos instance) => <String, dynamic>{
      'page': instance.page,
      'perPage': instance.perPage,
      'totalResults': instance.totalResults,
      'photos': instance.photos,
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'photographer': instance.photoGrapher,
      'src': instance.src,
    };
