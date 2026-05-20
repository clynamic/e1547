// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TagPreview {

 int? get id; String get name; int? get category; int? get postCount; List<String>? get implies; String? get alias; String? get resolved;
/// Create a copy of TagPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagPreviewCopyWith<TagPreview> get copyWith => _$TagPreviewCopyWithImpl<TagPreview>(this as TagPreview, _$identity);

  /// Serializes this TagPreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&const DeepCollectionEquality().equals(other.implies, implies)&&(identical(other.alias, alias) || other.alias == alias)&&(identical(other.resolved, resolved) || other.resolved == resolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,postCount,const DeepCollectionEquality().hash(implies),alias,resolved);

@override
String toString() {
  return 'TagPreview(id: $id, name: $name, category: $category, postCount: $postCount, implies: $implies, alias: $alias, resolved: $resolved)';
}


}

/// @nodoc
abstract mixin class $TagPreviewCopyWith<$Res>  {
  factory $TagPreviewCopyWith(TagPreview value, $Res Function(TagPreview) _then) = _$TagPreviewCopyWithImpl;
@useResult
$Res call({
 int? id, String name, int? category, int? postCount, List<String>? implies, String? alias, String? resolved
});




}
/// @nodoc
class _$TagPreviewCopyWithImpl<$Res>
    implements $TagPreviewCopyWith<$Res> {
  _$TagPreviewCopyWithImpl(this._self, this._then);

  final TagPreview _self;
  final $Res Function(TagPreview) _then;

/// Create a copy of TagPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? category = freezed,Object? postCount = freezed,Object? implies = freezed,Object? alias = freezed,Object? resolved = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as int?,postCount: freezed == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int?,implies: freezed == implies ? _self.implies : implies // ignore: cast_nullable_to_non_nullable
as List<String>?,alias: freezed == alias ? _self.alias : alias // ignore: cast_nullable_to_non_nullable
as String?,resolved: freezed == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _TagPreview implements TagPreview {
  const _TagPreview({this.id, required this.name, this.category, this.postCount, final  List<String>? implies, this.alias, this.resolved}): _implies = implies;
  factory _TagPreview.fromJson(Map<String, dynamic> json) => _$TagPreviewFromJson(json);

@override final  int? id;
@override final  String name;
@override final  int? category;
@override final  int? postCount;
 final  List<String>? _implies;
@override List<String>? get implies {
  final value = _implies;
  if (value == null) return null;
  if (_implies is EqualUnmodifiableListView) return _implies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? alias;
@override final  String? resolved;

/// Create a copy of TagPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagPreviewCopyWith<_TagPreview> get copyWith => __$TagPreviewCopyWithImpl<_TagPreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagPreviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&const DeepCollectionEquality().equals(other._implies, _implies)&&(identical(other.alias, alias) || other.alias == alias)&&(identical(other.resolved, resolved) || other.resolved == resolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,postCount,const DeepCollectionEquality().hash(_implies),alias,resolved);

@override
String toString() {
  return 'TagPreview(id: $id, name: $name, category: $category, postCount: $postCount, implies: $implies, alias: $alias, resolved: $resolved)';
}


}

/// @nodoc
abstract mixin class _$TagPreviewCopyWith<$Res> implements $TagPreviewCopyWith<$Res> {
  factory _$TagPreviewCopyWith(_TagPreview value, $Res Function(_TagPreview) _then) = __$TagPreviewCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, int? category, int? postCount, List<String>? implies, String? alias, String? resolved
});




}
/// @nodoc
class __$TagPreviewCopyWithImpl<$Res>
    implements _$TagPreviewCopyWith<$Res> {
  __$TagPreviewCopyWithImpl(this._self, this._then);

  final _TagPreview _self;
  final $Res Function(_TagPreview) _then;

/// Create a copy of TagPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? category = freezed,Object? postCount = freezed,Object? implies = freezed,Object? alias = freezed,Object? resolved = freezed,}) {
  return _then(_TagPreview(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as int?,postCount: freezed == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int?,implies: freezed == implies ? _self._implies : implies // ignore: cast_nullable_to_non_nullable
as List<String>?,alias: freezed == alias ? _self.alias : alias // ignore: cast_nullable_to_non_nullable
as String?,resolved: freezed == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
