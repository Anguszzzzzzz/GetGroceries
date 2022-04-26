import 'package:GetGroceries/controllers/auth_controller.dart';
import 'package:GetGroceries/models/item_model.dart';
import 'package:GetGroceries/repositories/custom_exception.dart';
import 'package:GetGroceries/repositories/item_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ItemListFilter {
  all,
  unobtained,
  weekly,
  toBuy,
}

final itemListFilterProvider =
    StateProvider<ItemListFilter>((_) => ItemListFilter.all);

final filteredItemListProvider = Provider<List<Item>>((ref) {
  final itemListFilterState = ref.watch(itemListFilterProvider).state;
  final itemListState = ref.watch(itemListControllerProvider.state);
  return itemListState.maybeWhen(
    data: (items) {
      switch (itemListFilterState) {
        case ItemListFilter.weekly:
          return items.where((item) => item.weekly).toList();
        case ItemListFilter.unobtained:
          return items.where((item) => !item.obtained).toList();
        case ItemListFilter.toBuy:
          return items.where((item) => item.toBuy).toList();
        default:
          return items;
      }
    },
    orElse: () => [],
  );
});

// final filteredItemListIsObtainedProvider = Provider<List<Item>>((ref) {
//   final itemListFilterState = ref.watch(itemListFilterProvider).state;
//   final itemListState = ref.watch(itemListControllerProvider.state);
//   return itemListState.maybeWhen(
//     data: (items) {
//       switch (itemListFilterState) {
//         case ItemListFilter.obtained:
//           return items.where((item) => item.obtained).toList();
//         default:
//           return items;
//       }
//     },
//     orElse: () => [],
//   );
// });

final itemListExceptionProvider = StateProvider<CustomException?>((_) => null);

final itemListControllerProvider =
    StateNotifierProvider<ItemListController>((ref) {
  final user = ref.watch(authControllerProvider.state);
  return ItemListController(ref.read, user?.uid);
});

class ItemListController extends StateNotifier<AsyncValue<List<Item>>> {
  final Reader _read;
  final String? _userId;

  ItemListController(this._read, this._userId) : super(AsyncValue.loading()) {
    if (_userId != null) {
      retrieveItems();
    }
  }

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final items =
          await _read(itemRepositoryProvider).retrieveItems(userId: _userId!);
      if (mounted) {
        state = AsyncValue.data(items);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addItem({required String name, bool obtained = false, String? category}) async {
    try {
      print('category: $category');
      final item = Item(name: name, obtained: obtained, category: category??'');
      final itemId = await _read(itemRepositoryProvider).createItem(
        userId: _userId!,
        item: item,
      );
      state.whenData((items) =>
          state = AsyncValue.data(items..add(item.copyWith(id: itemId))));
    } on CustomException catch (e) {
      _read(itemListExceptionProvider).state = e;
    }
  }

  Future<void> updateItem({required Item updatedItem}) async {
    try {
      await _read(itemRepositoryProvider)
          .updateItem(userId: _userId!, item: updatedItem);
      state.whenData((items) {
        state = AsyncValue.data([
          for (final item in items)
            if (item.id == updatedItem.id) updatedItem else item
        ]);
      });
    } on CustomException catch (e) {
      _read(itemListExceptionProvider).state = e;
    }
  }

  Future<void> deleteItem({required String itemId}) async {
    try {
      await _read(itemRepositoryProvider).deleteItem(
        userId: _userId!,
        itemId: itemId,
      );
      state.whenData((items) => state =
          AsyncValue.data(items..removeWhere((item) => item.id == itemId)));
    } on CustomException catch (e) {
      _read(itemListExceptionProvider).state = e;
    }
  }
}
