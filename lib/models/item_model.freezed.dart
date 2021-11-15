// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
class _$ItemTearOff {
  const _$ItemTearOff();

  _Item call(
      {String? id,
      required String name,
      bool obtained = false,
      bool weekly = false,
      bool toBuy = false}) {
    return _Item(
      id: id,
      name: name,
      obtained: obtained,
      weekly: weekly,
      toBuy: toBuy,
    );
  }

  Item fromJson(Map<String, Object> json) {
    return Item.fromJson(json);
  }
}

/// @nodoc
const $Item = _$ItemTearOff();

/// @nodoc
mixin _$Item {
  String? get id;
  String get name;
  bool get obtained;
  bool get weekly;
  bool get toBuy;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $ItemCopyWith<Item> get copyWith;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res>;
  $Res call({String? id, String name, bool obtained, bool weekly, bool toBuy});
}

/// @nodoc
class _$ItemCopyWithImpl<$Res> implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  final Item _value;
  // ignore: unused_field
  final $Res Function(Item) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? obtained = freezed,
    Object? weekly = freezed,
    Object? toBuy = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String?,
      name: name == freezed ? _value.name : name as String,
      obtained: obtained == freezed ? _value.obtained : obtained as bool,
      weekly: weekly == freezed ? _value.weekly : weekly as bool,
      toBuy: toBuy == freezed ? _value.toBuy : toBuy as bool,
    ));
  }
}

/// @nodoc
abstract class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) then) =
      __$ItemCopyWithImpl<$Res>;
  @override
  $Res call({String? id, String name, bool obtained, bool weekly, bool toBuy});
}

/// @nodoc
class __$ItemCopyWithImpl<$Res> extends _$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(_Item _value, $Res Function(_Item) _then)
      : super(_value, (v) => _then(v as _Item));

  @override
  _Item get _value => super._value as _Item;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? obtained = freezed,
    Object? weekly = freezed,
    Object? toBuy = freezed,
  }) {
    return _then(_Item(
      id: id == freezed ? _value.id : id as String?,
      name: name == freezed ? _value.name : name as String,
      obtained: obtained == freezed ? _value.obtained : obtained as bool,
      weekly: weekly == freezed ? _value.weekly : weekly as bool,
      toBuy: toBuy == freezed ? _value.toBuy : toBuy as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Item extends _Item with DiagnosticableTreeMixin {
  const _$_Item(
      {this.id,
      required this.name,
      this.obtained = false,
      this.weekly = false,
      this.toBuy = false})
      : super._();

  factory _$_Item.fromJson(Map<String, dynamic> json) =>
      _$_$_ItemFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @JsonKey(defaultValue: false)
  @override
  final bool obtained;
  @JsonKey(defaultValue: false)
  @override
  final bool weekly;
  @JsonKey(defaultValue: false)
  @override
  final bool toBuy;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Item(id: $id, name: $name, obtained: $obtained, weekly: $weekly, toBuy: $toBuy)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Item'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('obtained', obtained))
      ..add(DiagnosticsProperty('weekly', weekly))
      ..add(DiagnosticsProperty('toBuy', toBuy));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.obtained, obtained) ||
                const DeepCollectionEquality()
                    .equals(other.obtained, obtained)) &&
            (identical(other.weekly, weekly) ||
                const DeepCollectionEquality().equals(other.weekly, weekly)) &&
            (identical(other.toBuy, toBuy) ||
                const DeepCollectionEquality().equals(other.toBuy, toBuy)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(obtained) ^
      const DeepCollectionEquality().hash(weekly) ^
      const DeepCollectionEquality().hash(toBuy);

  @JsonKey(ignore: true)
  @override
  _$ItemCopyWith<_Item> get copyWith =>
      __$ItemCopyWithImpl<_Item>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ItemToJson(this);
  }
}

abstract class _Item extends Item {
  const _Item._() : super._();
  const factory _Item(
      {String? id,
      required String name,
      bool obtained,
      bool weekly,
      bool toBuy}) = _$_Item;

  factory _Item.fromJson(Map<String, dynamic> json) = _$_Item.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  bool get obtained;
  @override
  bool get weekly;
  @override
  bool get toBuy;
  @override
  @JsonKey(ignore: true)
  _$ItemCopyWith<_Item> get copyWith;
}
