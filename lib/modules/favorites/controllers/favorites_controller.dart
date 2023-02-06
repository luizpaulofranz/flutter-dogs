import 'package:get/get.dart';

import 'package:dog_lover/modules/favorites/services/favorites_service.dart';
import 'package:dog_lover/modules/home/models/breed_model.dart';

class FavoritesController extends GetxController {

  RxList<BreedModel> breeds = RxList<BreedModel>();
  RxBool hasError = false.obs;

  final FavoritesService _favoritesService = FavoritesService();

  void loadData() async {
    this.hasError.value = false;

    try {

      List<BreedModel> favorites = _favoritesService.getFavorites();

      this.breeds.clear();
      this.breeds.addAll(favorites);

    } catch(e) {
      this.hasError.value = true;
    }
  }

  void removeAllFavorites() {
    _favoritesService.removeAll();
    this.loadData();
  }
}
