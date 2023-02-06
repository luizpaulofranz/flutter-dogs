import 'package:dog_lover/modules/favorites/services/favorites_service.dart';
import 'package:get/get.dart';

import 'package:dog_lover/modules/home/models/breed_model.dart';
import 'package:dog_lover/modules/home/repositories/breeds_repository.dart';

class BreedsController extends GetxController {

  RxList<BreedModel> breeds = RxList<BreedModel>();
  RxBool hasError = false.obs;

  List<BreedModel> _apiBreeds = [];

  void loadData() async {
    var repository = BreedsRepository();
    var favoritesService = FavoritesService();
    this.hasError.value = false;

    try {
      
      Map<String, dynamic> breedsResponse = await repository.getAllBreeds();

      List<BreedModel> favorites = favoritesService.getFavorites();

      this.breeds.clear();
      this.breeds.addAll(
        breedsResponse.keys.map((breed) {
          List<BreedModel> matchingFavorite = favorites.where((favorite) => favorite.breed.toLowerCase() == breed).toList();
          if(matchingFavorite.isNotEmpty)
            return matchingFavorite.first;
          else
            return BreedModel(
              breed: breed.capitalize ?? "",
              isFavorite: false
            );
        }).toList()
      );

      this._apiBreeds = this.breeds.toList();
    } catch(e) {
      this.hasError.value = true;
    }
  }

  void searchBreed(String keyWord) {
    if(keyWord.isEmpty) {
      this.breeds.addAll(this._apiBreeds);
      return;
    }

    this.breeds.clear();
    this.breeds.addAll(
      this._apiBreeds.where((breed) => breed.breed.toLowerCase().contains(keyWord.toLowerCase())).toList()
    );
  }
}
