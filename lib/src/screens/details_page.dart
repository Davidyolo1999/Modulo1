import 'package:app_modulo1/src/components/tab_ingredients_widget.dart';
import 'package:app_modulo1/src/components/tab_preparation.dart';
import 'package:app_modulo1/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';

class DetailsPage extends StatefulWidget {
  final Recipe recipe;
  final ServerController serverController;

  DetailsPage({this.recipe, this.serverController, key}) : super(key: key);

  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool favorite;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(widget.recipe.name),
                expandedHeight: 320,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(widget.recipe.photo),
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(.5),
                  ),
                ),
                pinned: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  indicatorWeight: 4,
                  tabs: <Widget>[
                    Tab(
                        child: Text(
                      'Ingredientes',
                      style: TextStyle(fontSize: 18),
                    )),
                    Tab(
                        child: Text(
                      'Preparación',
                      style: TextStyle(fontSize: 18),
                    )),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  getFavoriteWidget(),
                  IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () {},
                  ),
                ],
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              TabIngredientsWidget(
                recipe: widget.recipe,
              ),
              TapPreparationWidget(
                recipe: widget.recipe,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getFavoriteWidget() {
    if (favorite != null) {
      if (favorite) {
        return IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () async {
            await widget.serverController.deleteFavorite(widget.recipe);
            setState(() {
              favorite = false;
            });
          },
        );
      } else {
        return IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.white,
          onPressed: () async {
            await widget.serverController.addFavorite(widget.recipe);
            setState(() {
              favorite = true;
            });
          },
        );
      }
    } else {
      return Container(
          margin: EdgeInsets.all(15),
          width: 30,
          child: CircularProgressIndicator());
    }
  }
////inicia el estado para mostrarlo
  @override
  void initState() {
    super.initState();
    loadState();
  }
////pedir el esatdo de favoritos 
  void loadState() async {
    final state = await widget.serverController.getIsFavorite(widget.recipe);
    setState(() {
      this.favorite = state;
    });
  }
}
