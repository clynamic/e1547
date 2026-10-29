// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostSetParams implements DiagnosticableTreeMixin {

 String? get name; String? get creator; PostSetOrder? get order;
/// Create a copy of PostSetParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostSetParamsCopyWith<PostSetParams> get copyWith => _$PostSetParamsCopyWithImpl<PostSetParams>(this as PostSetParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PostSetParams'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostSetParams&&(identical(other.name, name) || other.name == name)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,name,creator,order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PostSetParams(name: $name, creator: $creator, order: $order)';
}


}

/// @nodoc
abstract mixin class $PostSetParamsCopyWith<$Res>  {
  factory $PostSetParamsCopyWith(PostSetParams value, $Res Function(PostSetParams) _then) = _$PostSetParamsCopyWithImpl;
@useResult
$Res call({
 String? name, String? creator, PostSetOrder? order
});




}
/// @nodoc
class _$PostSetParamsCopyWithImpl<$Res>
    implements $PostSetParamsCopyWith<$Res> {
  _$PostSetParamsCopyWithImpl(this._self, this._then);

  final PostSetParams _self;
  final $Res Function(PostSetParams) _then;

/// Create a copy of PostSetParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? creator = freezed,Object? order = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PostSetOrder?,
  ));
}

}



/// @nodoc


class _PostSetParams extends PostSetParams with DiagnosticableTreeMixin {
  const _PostSetParams({this.name, this.creator, this.order}): super._();
  

@override final  String? name;
@override final  String? creator;
@override final  PostSetOrder? order;

/// Create a copy of PostSetParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostSetParamsCopyWith<_PostSetParams> get copyWith => __$PostSetParamsCopyWithImpl<_PostSetParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PostSetParams'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostSetParams&&(identical(other.name, name) || other.name == name)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,name,creator,order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PostSetParams(name: $name, creator: $creator, order: $order)';
}


}

/// @nodoc
abstract mixin class _$PostSetParamsCopyWith<$Res> implements $PostSetParamsCopyWith<$Res> {
  factory _$PostSetParamsCopyWith(_PostSetParams value, $Res Function(_PostSetParams) _then) = __$PostSetParamsCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? creator, PostSetOrder? order
});




}
/// @nodoc
class __$PostSetParamsCopyWithImpl<$Res>
    implements _$PostSetParamsCopyWith<$Res> {
  __$PostSetParamsCopyWithImpl(this._self, this._then);

  final _PostSetParams _self;
  final $Res Function(_PostSetParams) _then;

/// Create a copy of PostSetParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? creator = freezed,Object? order = freezed,}) {
  return _then(_PostSetParams(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PostSetOrder?,
  ));
}


}

// dart format on
