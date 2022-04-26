import 'package:checklist_app/controllers/auth_controller.dart';
import 'package:checklist_app/controllers/item_list_controller.dart';
import 'package:checklist_app/repositories/custom_exception.dart';
import 'package:checklist_app/screens/widgets/itemDialogs.dart';
import 'package:checklist_app/screens/widgets/itemList.dart';
import 'package:checklist_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:checklist_app/util/colors.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
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
          //weekly item filter
          filterButton(
              onPressed: () => itemListFilter.state = isWeeklyFilter ? ItemListFilter.all : ItemListFilter.weekly,
              icon: RpgAwesome.recycle,
              iconColor: isWeeklyFilter ? secondaryYellow : Colors.white
          ),
          SizedBox(width: 15,),
          //item low filter
          filterButton(
              onPressed: () => itemListFilter.state = isUnobtainedFilter ? ItemListFilter.all : ItemListFilter.unobtained,
              icon: Typicons.warning_empty,
              iconColor: isUnobtainedFilter ? secondaryYellow : Colors.white
          ),
          // //to-buy item filter
          // filterButton(
          //     onPressed: () => itemListFilter.state = isToBuyFilter ? ItemListFilter.all : ItemListFilter.toBuy,
          //     icon: FontAwesome5.shopping_basket,
          //     iconColor: isToBuyFilter ? secondaryYellow : Colors.white
          // ),
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
      floatingActionButton: addItemButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget addItemButton (BuildContext context) => Container(
  height: 110,width: 150,padding: EdgeInsets.only(bottom: 40),
    child: FloatingActionButton(
      onPressed: () => AddItemDialog.show(context, Item.empty()),
      elevation: 5,
      child: const Icon(
        CupertinoIcons.plus,
        size: 30,
        color: primaryGreenDark,
      ),
    )
);

Widget filterButton (
    {required IconData icon, Color? iconColor, required void Function() onPressed}) {
  return Container(width: appbarIconSize*1.5,
    child: Center(
      child: IconButton(
        padding: EdgeInsets.all(0),
        splashRadius: appbarIconSize,
        icon: Icon(
          icon,
          size: appbarIconSize,
          color: iconColor,
        ),
        onPressed: onPressed
      ),
    ),
  );
}