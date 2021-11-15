import 'dart:ffi';

import 'package:checklist_app/controllers/auth_controller.dart';
import 'package:checklist_app/controllers/item_list_controller.dart';
import 'package:checklist_app/repositories/custom_exception.dart';
import 'package:checklist_app/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:checklist_app/util/colors.dart';
import 'package:checklist_app/util/app_theme.dart';
import 'package:fluttericon/typicons_icons.dart';

import 'package:hooks_riverpod/all.dart';

import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

import 'package:checklist_app/models/item_model.dart';

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final authControllerState = useProvider(authControllerProvider.state);
    final itemListFilter = useProvider(itemListFilterProvider);
    final isWeeklyFilter = itemListFilter.state == ItemListFilter.weekly;
    final isUnobtainedFilter = itemListFilter.state == ItemListFilter.unobtained;
    final isToBuyFilter = itemListFilter.state == ItemListFilter.toBuy;
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Groceries!"),
        leading: authControllerState != null
            ? IconButton(
                onPressed: () => {
                      context.read(authControllerProvider).signOut(),
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => LoginScreen())),
                    },
                icon: const Icon(
                  Icons.logout,
                  color: textOnPrimaryGreen,
                ))
            : null,
        actions: [
          IconButton(
            // splashColor: Colors.white54,
            // highlightColor: Colors.white24,
            //weekly filter
            icon: Icon(
              RpgAwesome.recycle,
              color: isWeeklyFilter ? secondaryYellow : Colors.white,
              // isWeeklyFilter
              //     ? Icons.arrow_back_rounded
              //     : Icons.find_replace_rounded,
            ),
            onPressed: () => itemListFilter.state =
                isWeeklyFilter ? ItemListFilter.all : ItemListFilter.weekly,
          ),
          //item low filter
          IconButton(
            // splashColor: Colors.white54,
            // highlightColor: Colors.white24,
            icon: Icon(
              Typicons.warning_empty,
              size: 21,
              color: isUnobtainedFilter ? secondaryYellow : Colors.white,
            ),
            onPressed: () => itemListFilter.state = isUnobtainedFilter
                ? ItemListFilter.all
                : ItemListFilter.unobtained,
          ),
          //to-buy item filter
          IconButton(
            // splashColor: Colors.white54,
            // highlightColor: Colors.white24,
            icon: Icon(
              FontAwesome5.shopping_basket,
              size: 21,
              color: isToBuyFilter ? secondaryYellow : Colors.white,
            ),
            onPressed: () => itemListFilter.state = isToBuyFilter
                ? ItemListFilter.all
                : ItemListFilter.toBuy,
          ),
        ],
      ),
      body: ProviderListener(
        provider: itemListExceptionProvider,
        onChange: (
          BuildContext context,
          StateController<CustomException?> customException,
        ) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(customException.state!.message!),
            ),
          );
        },
        child: const ItemList(),
      ),
      floatingActionButton: Container(
        height: 110,
        width: 150,
        padding: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          elevation: 5,
          child: const Icon(
            CupertinoIcons.plus,
            size: 30,
            color: primaryGreenDark,
          ),
          onPressed: () => AddItemDialog.show(context, Item.empty()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AddItemDialog extends HookWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(item: item),
    );
  }

  final Item item;

  const AddItemDialog({Key? key, required this.item}) : super(key: key);

  bool get isUpdating => item.id != null;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final textController = useTextEditingController(text: item.name);
    return Dialog(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: isUpdating ? primaryGreen : secondaryYellow,
                ),
                onPressed: () {
                  isUpdating
                      ? context.read(itemListControllerProvider).updateItem(
                            updatedItem: item.copyWith(
                              name: textController.text.trim(),
                              obtained: item.obtained,
                            ),
                          )
                      : context
                          .read(itemListControllerProvider)
                          .addItem(name: textController.text.trim());
                  Navigator.of(context).pop();
                },
                child: Text(
                  isUpdating ? 'Update' : 'Add',
                  style: TextStyle(
                    color: isUpdating ? Colors.white : primaryGreenDark,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final currentItem = ScopedProvider<Item>((_) => throw UnimplementedError());

class ItemList extends HookWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final itemListState = useProvider(itemListControllerProvider.state);
    final filteredItemList = useProvider(filteredItemListProvider);
    return itemListState.when(
      data: (items) => items.isEmpty
          ? const Center(
              child: Text(
                'Tap + to add an item',
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
            )
          : ListView.builder(
              itemCount: filteredItemList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = filteredItemList[index];
                return ProviderScope(
                  overrides: [currentItem.overrideWithValue(item)],
                  child: const ItemTile(),
                );
              },
            ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
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
        leading: Row(mainAxisSize: MainAxisSize.min,
          children: [
            //weekly icon
            IconButton(
              icon: Icon(
                FontAwesome5.recycle,
                size: 20,
                color: isWeekly ? primaryGreen : Colors.black87,
              ),
              onPressed: () => context
                  .read(itemListControllerProvider)
                  .updateItem(updatedItem: item.copyWith(weekly: !item.weekly)),
            ),
            //tobuy icon
            IconButton(
              icon: Icon(
                FontAwesome5.shopping_basket,
                size: 20,
                color: isToBuy ? primaryGreen : Colors.black87,
              ),
              onPressed: () => context
                  .read(itemListControllerProvider)
                  .updateItem(updatedItem: item.copyWith(toBuy: !item.toBuy)),
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
              .updateItem(updatedItem: item.copyWith(obtained: !item.obtained)),
        ),
        onTap: () => AddItemDialog.show(context, item),
        onLongPress: () => context
            .read(itemListControllerProvider)
            .deleteItem(itemId: item.id!));
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
