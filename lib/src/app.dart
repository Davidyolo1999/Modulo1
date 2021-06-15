import 'package:app_modulo1/src/screens/home_page.dart';
import 'package:app_modulo1/src/screens/login_page.dart';
import 'package:app_modulo1/src/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/recipe.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';
import 'package:app_modulo1/src/screens/my_favorites_page.dart';
import 'connection/server_controller.dart';
import 'package:app_modulo1/src/screens/mys_recipes_page.dart';
import 'package:app_modulo1/src/screens/details_page.dart';
import 'package:app_modulo1/src/screens/add_recipe_page.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        accentColor: Colors.cyan[300],
        accentIconTheme: IconThemeData(
          color: Colors.white,
        ),
        appBarTheme: AppBarTheme(
            textTheme:
                TextTheme(title: TextStyle(color: Colors.white, fontSize: 22)),
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage(_serverController, context);
            case "/home":
              User loggedUser = settings.arguments;
              _serverController.loggedUser = loggedUser;
              return HomePage(_serverController);
            case "/register":
              User loggedUser = settings.arguments;
              return RegisterPage(
                _serverController,
                context,
                userToEdit: loggedUser,
              );
            case "/favorites":
              return MyFavoritesPage(
                _serverController,
              );
            case "/my_recipes":
              return MyRecipesPage(
                _serverController,
              );
            case "/add_recipe":
              return AddRecipePage(
                _serverController,
              );
            case "/details":
              Recipe recipe = settings.arguments;
              return DetailsPage(
                recipe: recipe,
                serverController: _serverController,
              );
          }
        });
      },
    );
  }
}
