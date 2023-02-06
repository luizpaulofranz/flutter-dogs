import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'package:dog_lover/modules/home/models/breed_model.dart';

const FAVORITES_KEY = "favorites";

class FavoritesService {

  final storage = GetStorage();
  final DefaultCacheManager cacheFile = DefaultCacheManager();

  void addFavorite(BreedModel breed) {
    List? favorites = storage.read<List>(FAVORITES_KEY);
    if(favorites == null)
      favorites = [];

    List favoriteExists = favorites.map((favorite) => BreedModel.fromJson(favorite))
      .where((favoriteBreed) => favoriteBreed.breed.toLowerCase() == breed.breed.toLowerCase())
      .toList();
    
    if(favoriteExists.isEmpty){
      breed.isFavorite = true;
      favorites.add(breed.toJson());
      storage.write(FAVORITES_KEY, favorites);

      breed.imageUrls!.forEach((imageUrl) async {
        await cacheFile.downloadFile(imageUrl);
      });
    }
  }

  List<BreedModel> getFavorites() {
    List? favorites = storage.read<List>(FAVORITES_KEY);
    if(favorites == null)
      return [];

    return favorites.map((favorite) => BreedModel.fromJson(favorite)).toList();
  }

  void removeFavorite(BreedModel breed) {
    List? favorites = storage.read<List>(FAVORITES_KEY);
    if(favorites == null)
      return;

    List newFavorites = favorites.map((favorite) => BreedModel.fromJson(favorite))
      .where((favoriteBreed) => favoriteBreed.breed.toLowerCase() != breed.breed.toLowerCase())
      .map((favorite) => favorite.toJson())
      .toList();
    storage.write(FAVORITES_KEY, newFavorites);

    breed.imageUrls!.forEach((imageUrl) async {
      await cacheFile.removeFile(imageUrl);
    });
  }

  void removeAll() {
    storage.remove(FAVORITES_KEY);
    cacheFile.emptyCache();
  }

  Future<List<String>> getImagePathsFromCache(BreedModel breed) async {
    List<String> paths = [];
    print(breed.imageUrls);
    for(String imageUrl in breed.imageUrls ?? []) {
        FileInfo? fileInfo = await cacheFile.getFileFromCache(imageUrl);
        String path = fileInfo?.file.path ?? "";
        if(path.isNotEmpty)
          paths.add(path);
    }
    return paths;
  }
}