import 'dart:ffi';

import 'package:checklist_app/controllers/auth_controller.dart';
import 'package:checklist_app/controllers/item_list_controller.dart';
import 'package:checklist_app/repositories/custom_exception.dart';
import 'package:checklist_app/screens/login.dart';
import 'package:checklist_app/util/constants.dart';
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
        centerTitle: true,
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
                  size: appbarIconSize,
                ))
            : null,
        actions: [
          Container(width: appbarIconSize*1.5,
            child: IconButton(
              padding: EdgeInsets.all(0),
              splashRadius: appbarIconSize,
              icon: Icon(
                RpgAwesome.recycle,
                color: isWeeklyFilter ? secondaryYellow : Colors.white,
                size: appbarIconSize,
                // isWeeklyFilter
                //     ? Icons.arrow_back_rounded
                //     : Icons.find_replace_rounded,
              ),
              onPressed: () => itemListFilter.state =
                  isWeeklyFilter ? ItemListFilter.all : ItemListFilter.weekly,
            ),
          ),
          //item low filter
          Container(width: appbarIconSize*1.5,
            child: IconButton(
              padding: EdgeInsets.all(0),
              splashRadius: appbarIconSize,
              icon: Icon(
                Typicons.warning_empty,
                size: appbarIconSize,
                color: isUnobtainedFilter ? secondaryYellow : Colors.white,
              ),
              onPressed: () => itemListFilter.state = isUnobtainedFilter
                  ? ItemListFilter.all
                  : ItemListFilter.unobtained,
            ),
          ),
          //to-buy item filter
          Container(width: appbarIconSize*1.5,
            child: Center(
              child: IconButton(
                padding: EdgeInsets.all(0),
                splashRadius: appbarIconSize,
                icon: Icon(
                  FontAwesome5.shopping_basket,
                  size: appbarIconSize,
                  color: isToBuyFilter ? secondaryYellow : Colors.white,
                ),
                onPressed: () => itemListFilter.state = isToBuyFilter
                    ? ItemListFilter.all
                    : ItemListFilter.toBuy,
              ),
            ),
          ),
          SizedBox(width: 15,)
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
        child: ItemList(),
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
    final nameController = useTextEditingController(text: item.name);
    ValueNotifier categoryValue = useState(categories.indexOf(item.category??'Others'));
    print('${categoryValue.value}');

    return Dialog(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),
            DropdownButtonFormField(
              value: categoryValue.value,
                items: categories.map((e) => DropdownMenuItem(child: Text(e),value: categories.indexOf(e),)).toList(),
              onChanged: (v) =>
                categoryValue.value = v,
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
                              name: nameController.text.trim(),
                              obtained: item.obtained,
                              category: categories[categoryValue.value]
                            ),
                          )
                      : context
                          .read(itemListControllerProvider)
                          .addItem(name: nameController.text.trim(), category: categories[categoryValue.value]);
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

class DeleteItemDialog extends HookWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => DeleteItemDialog(item: item),
    );
  }

  final Item item;

  const DeleteItemDialog({Key? key, required this.item}) : super(key: key);

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
            Text('Delete item: ${item.name}?'),
            const SizedBox(height: 12),
            Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(
                width: dialogButtonSize,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primaryGreen,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              SizedBox(
                width: dialogButtonSize,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primaryRed,
                  ),
                  onPressed: () {
                    try{
                      context.read(itemListControllerProvider).deleteItem(itemId: item.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted ${item.name}')));
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],)

          ],
        ),
      ),
    );
  }
}

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
