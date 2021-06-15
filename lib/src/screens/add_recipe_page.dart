import 'dart:io';

import 'package:app_modulo1/src/components/image_picker_widget.dart';
import 'package:app_modulo1/src/components/ingredient_widget.dart';
import 'package:app_modulo1/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';

class AddRecipePage extends StatefulWidget {
  ServerController serverController;
  AddRecipePage(this.serverController, {Key key}) : super(key: key);

  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "", description = "";
  List<String> ingredientsList = [], stepsList = [];
  File photoFile;
  final nIngredientControler = TextEditingController();
  final nPasoController = TextEditingController();
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
              imageFile: this.imageFile,
              onImageSelected: (File file) {
                setState(() {
                  imageFile = file;
                });
              },
            ),
            SizedBox(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      _save(context);
                    },
                  )
                ],
              ),
              height: kToolbarHeight + 25,
            ),
            Center(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 260, bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: ListView(children: <Widget>[
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Nombre de receta"),
                      onSaved: (value) {
                        this.name = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "LLene este campo";
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Descripción"),
                      onSaved: (value) {
                        this.description = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "LLene este campo";
                        }
                      },
                      maxLines: 6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text("Ingredientes"),
                      trailing: FloatingActionButton(
                        heroTag: "uno",
                        child: Icon(Icons.add),
                        onPressed: () {
                          _ingredientDialog(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    getIngredientsList(),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text("Pasos"),
                      trailing: FloatingActionButton(
                        heroTag: "dos",
                        child: Icon(Icons.add),
                        onPressed: () {
                          _stepDialog(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    getStepsList()
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getStepsList() {
    if (stepsList.length == 0) {
      return Text(
        "Listado vacío",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: List.generate(stepsList.length, (index) {
          final ingredient = stepsList[index];
          return IngredientWidget(
            index: index,
            ingredientName: ingredient,
            onIngredientDeleteCallback: _onStepDelete,
            onIngredientEditCallback: _onStepEdit,
          );
        }),
      );
    }
  }

  Widget getIngredientsList() {
    if (ingredientsList.length == 0) {
      return Text(
        "Listado vacío",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: List.generate(ingredientsList.length, (index) {
          final ingredient = ingredientsList[index];
          return IngredientWidget(
            index: index,
            ingredientName: ingredient,
            onIngredientDeleteCallback: _onIngredientDelete,
            onIngredientEditCallback: _onIngredientEdit,
          );
        }),
      );
    }
  }

  void _ingredientDialog(BuildContext context, {String ingredient, int index}) {
    final textController = TextEditingController(text: ingredient);
    final editing = ingredient != null;
    final onSave = () {
      final text = textController.text;
      if (text.isEmpty) {
        _showSnackBar("El nombre está vacío", backColor: Colors.orange);
      } else {
        setState(() {
          if (editing) {
            ingredientsList[index] = text;
          } else {
            ingredientsList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                editing ? "Editando ingrediente" : "Agregando ingrediente"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(labelText: "Ingrediente"),
              onEditingComplete: onSave,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(editing ? "Actualizar" : "Guardar"),
                onPressed: onSave,
              ),
            ],
          );
        });
  }

  void _stepDialog(BuildContext context, {String step, int index}) {
    final textController = TextEditingController(text: step);
    final editing = step != null;
    final onSave = () {
      final text = textController.text;
      if (text.isEmpty) {
        _showSnackBar("El paso está vacío", backColor: Colors.orange);
      } else {
        setState(() {
          if (editing) {
            stepsList[index] = text;
          } else {
            stepsList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(editing ? "Editando paso" : "Agregando paso"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Paso",
              ),
              textInputAction: TextInputAction.newline,
              maxLines: 6,
              //onEditingComplete: onSave,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(editing ? "Actualizar" : "Guardar"),
                onPressed: onSave,
              ),
            ],
          );
        });
  }

  void _showSnackBar(String message, {Color backColor = Colors.black}) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backColor,
      ),
    );
  }

  void _onIngredientEdit(int index) {
    final ingredient = ingredientsList[index];
    _ingredientDialog(context, ingredient: ingredient, index: index);
  }

  void _onIngredientDelete(int index) {
    questionDialog(context, "¿Seguro desea eliminar el ingrediente?", () {
      setState(() {
        ingredientsList.removeAt(index);
      });
    });
  }

  void _onStepEdit(int index) {
    final step = stepsList[index];
    _stepDialog(context, step: step, index: index);
  }

  void _onStepDelete(int index) {
    questionDialog(context, "¿Seguro desea eliminar el paso?", () {
      setState(() {
        stepsList.removeAt(index);
      });
    });
  }

  void questionDialog(BuildContext context, String message, VoidCallback onOk) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Si"),
                onPressed: () {
                  Navigator.pop(context);
                  onOk();
                },
              ),
            ],
          );
        });
  }

  void _save(BuildContext context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (imageFile == null) {
        _showSnackBar("La imágen está vacía");
        return;
      }
      if (ingredientsList.length == 0) {
        _showSnackBar("No tiene ingredientes");
        return;
      }
      if (stepsList.length == 0) {
        _showSnackBar("No tiene pasos");
        return;
      }

      final recipe = Recipe(
          name: this.name,
          description: this.description,
          ingredients: this.ingredientsList,
          steps: this.stepsList,
          photo: this.imageFile,
          user: widget.serverController.loggedUser,
          date: DateTime.now());

      final recipe2 = await widget.serverController.addRecipe(recipe);

      if (recipe2 != null) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Receta guardada exitosamente"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      } else {
        _showSnackBar("No se pudo realizar");
      }
    }
     }
 }
