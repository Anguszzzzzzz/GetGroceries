import 'package:GetGroceries/controllers/item_list_controller.dart';
import 'package:GetGroceries/models/item_model.dart';
import 'package:GetGroceries/util/colors.dart';
import 'package:GetGroceries/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/src/provider.dart';


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
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isUpdating?"Update Item":"Add Item"),
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