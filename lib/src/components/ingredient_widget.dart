import 'package:flutter/material.dart';

typedef OnIngredientDeleteCallback = void Function(int index);

class IngredientWidget extends StatelessWidget {
  final int index;

  final String ingredientName;
  final OnIngredientDeleteCallback onIngredientDeleteCallback;
  final OnIngredientDeleteCallback onIngredientEditCallback;

  const IngredientWidget({
    this.index,
    this.ingredientName,
    this.onIngredientDeleteCallback,
    this.onIngredientEditCallback,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backColor = Colors.white;
    if ((index % 2) == 1) {
      backColor = Colors.grey[300];
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: backColor),
      child: ListTile(
        leading: Text(
          "${index + 1}",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        title: Text(
          ingredientName,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                this.onIngredientEditCallback(index);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                this.onIngredientDeleteCallback(index);
              },
            )
          ],
        ),
      ),
    );
     }
 }
