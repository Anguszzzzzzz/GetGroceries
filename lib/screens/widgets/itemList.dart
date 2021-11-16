import 'package:checklist_app/controllers/item_list_controller.dart';
import 'package:checklist_app/models/item_model.dart';
import 'package:checklist_app/repositories/custom_exception.dart';
import 'package:checklist_app/ui/components.dart';
import 'package:checklist_app/util/app_theme.dart';
import 'package:checklist_app/util/colors.dart';
import 'package:checklist_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hooks_riverpod/all.dart';
import 'itemDialogs.dart';


final currentItem = ScopedProvider<Item>((_) => throw UnimplementedError());

class ItemList extends HookWidget {
  ItemList({Key? key}) : super(key: key);
  ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final itemListState = useProvider(itemListControllerProvider.state);
    final filteredItemList = useProvider(filteredItemListProvider);
    filteredItemList.sort((a,b)
    {
      var cmp = (a.category?.toLowerCase()??'').compareTo(b.category?.toLowerCase()??'');
      if (cmp != 0) return -cmp;
      else return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return itemListState.when(
      data: (items) => items.isEmpty
          ? const Center(
        child: Text(
          'Tap + to add an item',
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      )
          : Scrollbar(thickness: 10, hoverThickness: 5,showTrackOnHover: true,
        controller: sc,
        child: ListView.builder(
          controller: sc,
          itemCount: filteredItemList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = filteredItemList[index];
            return ProviderScope(
              overrides: [currentItem.overrideWithValue(item)],
              child: const ItemTile(),
            );
          },
        ),
      ),
      loading: () => Center(
        child: circProgIndi(),
      ),
      error: (error, _) => ItemListError(
        message:
        error is CustomException ? error.message! : 'Something went wrong',
      ),
    );
  }
}

class ItemTile extends HookWidget {
  const ItemTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final item = useProvider(currentItem);

    final isWeekly = item.weekly;
    final isToBuy = item.toBuy;


    return ListTile(
        key: ValueKey(item.id),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Row(mainAxisSize: MainAxisSize.min,
          children: [
            //weekly icon
            Container(width: appbarIconSize*1.5,
              child: IconButton(
                icon: Icon(
                  FontAwesome5.recycle,
                  size: 20,
                  color: isWeekly ? primaryGreen : Colors.black87,
                ),
                onPressed: () => context
                    .read(itemListControllerProvider)
                    .updateItem(updatedItem: item.copyWith(weekly: !item.weekly)),
              ),
            ),
            //tobuy icon
            Container(width: appbarIconSize*1.5,
              child: IconButton(
                icon: Icon(
                  FontAwesome5.shopping_basket,
                  size: 20,
                  color: isToBuy ? primaryGreen : Colors.black87,
                ),
                onPressed: () => context
                    .read(itemListControllerProvider)
                    .updateItem(updatedItem: item.copyWith(toBuy: !item.toBuy)),
              ),
            ),
          ],
        ),
        title: Text(
          item.name,
          style: appTheme.textTheme.bodyText1,
        ),
        trailing: Checkbox(
          // fillColor: MaterialStateProperty.all(Colors.black87),
          value: item.obtained,
          onChanged: (val) => context
              .read(itemListControllerProvider)
              .updateItem(updatedItem: item.copyWith(obtained: !item.obtained, toBuy: false)),
        ),
        onTap: () => AddItemDialog.show(context, item),
        onLongPress: () {
          DeleteItemDialog.show(context, item);
          // context.read(itemListControllerProvider).deleteItem(itemId: item.id!);
        });
  }
}

class ItemListError extends StatelessWidget {
  final String message;

  const ItemListError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context
                .read(itemListControllerProvider)
                .retrieveItems(isRefreshing: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
