import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

// flutter packages pub run build_runner watch --delete-conflicting-outputs


@freezed
abstract class Item implements _$Item{
  const Item._();

  const factory Item({
    String? id,
    required String name,
    @Default(false) bool obtained,
    @Default(false) bool weekly,
    @Default(false) bool toBuy,
}) = _Item;

  factory Item.empty() => Item(name: '');

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  factory Item.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()!;
    return Item.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocument() => toJson()..remove('id');

}