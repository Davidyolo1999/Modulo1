import 'package:flutter/widgets.dart';
import 'package:flutter_modulo1_fake_backend/modulo1_fake_backend.dart'
    as server;
import 'package:flutter_modulo1_fake_backend/models.dart';

class ServerController {
  User loggedUser;
  void init(BuildContext context) {
    server.generateData(context);
  }

  ///funcion asincrona
  Future<User> login(String userName, String password) async {
    return await server.backendLogin(userName, password);
  }

  Future<bool> addUser(User nUser) async {
    return await server.addUser(nUser);
  }

  Future<List<Recipe>> getRecipesList() async {
    return await server.getRecipes();
  }

  Future<bool> updateUser(User user) async {
    loggedUser = user;
    return await server.updateUser(user);
  }

  Future<List<Recipe>> getFavoritesList() async {
    return await server.getFavorites();
  }

  Future<bool> getIsFavorite(Recipe recipeToCheck) async {
    return await server.isFavorite(recipeToCheck);
  }

  Future<Recipe> addFavorite(Recipe nFavorite) async {
    return await server.addFavorite(nFavorite);
  }

  Future<bool> deleteFavorite(Recipe favoriteRecipe) async {
    return await server.deleteFavorite(favoriteRecipe);
  }

  Future<List<Recipe>> getUserRecipesList() async {
    return await server.getUserRecipes(loggedUser);
  }

  Future<Recipe> addRecipe(Recipe nRecipe) async {
    return await server.addRecipe(nRecipe);
  }
}
