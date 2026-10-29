// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostSet {

 int get id; String get name; String get shortname; String get description; bool get public; int get creatorId; List<int> get postIds; int get postCount; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PostSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostSetCopyWith<PostSet> get copyWith => _$PostSetCopyWithImpl<PostSet>(this as PostSet, _$identity);

  /// Serializes this PostSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostSet&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shortname, shortname) || other.shortname == shortname)&&(identical(other.description, description) || other.description == description)&&(identical(other.public, public) || other.public == public)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&const DeepCollectionEquality().equals(other.postIds, postIds)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,shortname,description,public,creatorId,const DeepCollectionEquality().hash(postIds),postCount,createdAt,updatedAt);

@override
String toString() {
  return 'PostSet(id: $id, name: $name, shortname: $shortname, description: $description, public: $public, creatorId: $creatorId, postIds: $postIds, postCount: $postCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PostSetCopyWith<$Res>  {
  factory $PostSetCopyWith(PostSet value, $Res Function(PostSet) _then) = _$PostSetCopyWithImpl;
@useResult
$Res call({
 int id, String name, String shortname, String description, bool public, int creatorId, List<int> postIds, int postCount, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PostSetCopyWithImpl<$Res>
    implements $PostSetCopyWith<$Res> {
  _$PostSetCopyWithImpl(this._self, this._then);

  final PostSet _self;
  final $Res Function(PostSet) _then;

/// Create a copy of PostSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? shortname = null,Object? description = null,Object? public = null,Object? creatorId = null,Object? postIds = null,Object? postCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortname: null == shortname ? _self.shortname : shortname // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,public: null == public ? _self.public : public // ignore: cast_nullable_to_non_nullable
as bool,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as int,postIds: null == postIds ? _self.postIds : postIds // ignore: cast_nullable_to_non_nullable
as List<int>,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _PostSet implements PostSet {
  const _PostSet({required this.id, required this.name, required this.shortname, required this.description, required this.public, required this.creatorId, required final  List<int> postIds, required this.postCount, required this.createdAt, required this.updatedAt}): _postIds = postIds;
  factory _PostSet.fromJson(Map<String, dynamic> json) => _$PostSetFromJson(json);

@override final  int id;
@override final  String name;
@override final  String shortname;
@override final  String description;
@override final  bool public;
@override final  int creatorId;
 final  List<int> _postIds;
@override List<int> get postIds {
  if (_postIds is EqualUnmodifiableListView) return _postIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postIds);
}

@override final  int postCount;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PostSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostSetCopyWith<_PostSet> get copyWith => __$PostSetCopyWithImpl<_PostSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostSetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostSet&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shortname, shortname) || other.shortname == shortname)&&(identical(other.description, description) || other.description == description)&&(identical(other.public, public) || other.public == public)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&const DeepCollectionEquality().equals(other._postIds, _postIds)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,shortname,description,public,creatorId,const DeepCollectionEquality().hash(_postIds),postCount,createdAt,updatedAt);

@override
String toString() {
  return 'PostSet(id: $id, name: $name, shortname: $shortname, description: $description, public: $public, creatorId: $creatorId, postIds: $postIds, postCount: $postCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PostSetCopyWith<$Res> implements $PostSetCopyWith<$Res> {
  factory _$PostSetCopyWith(_PostSet value, $Res Function(_PostSet) _then) = __$PostSetCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String shortname, String description, bool public, int creatorId, List<int> postIds, int postCount, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PostSetCopyWithImpl<$Res>
    implements _$PostSetCopyWith<$Res> {
  __$PostSetCopyWithImpl(this._self, this._then);

  final _PostSet _self;
  final $Res Function(_PostSet) _then;

/// Create a copy of PostSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? shortname = null,Object? description = null,Object? public = null,Object? creatorId = null,Object? postIds = null,Object? postCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PostSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortname: null == shortname ? _self.shortname : shortname // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,public: null == public ? _self.public : public // ignore: cast_nullable_to_non_nullable
as bool,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as int,postIds: null == postIds ? _self._postIds : postIds // ignore: cast_nullable_to_non_nullable
as List<int>,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
