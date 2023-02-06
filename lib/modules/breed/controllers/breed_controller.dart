import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dog_lover/modules/breed/repositories/breed_repository.dart';
import 'package:dog_lover/modules/favorites/services/favorites_service.dart';
import 'package:dog_lover/modules/home/models/breed_model.dart';

class BreedController extends GetxController {

  RxList<String> imageUrls = RxList<String>();
  RxBool hasError = false.obs;
  Rx<BreedModel> _breed = BreedModel().obs;
  RxBool isOffline = false.obs;

  final favoritesService = FavoritesService();

  set breed(BreedModel breed) {
    _breed.value = breed;
  }

  BreedModel get breed {
    return _breed.value;
  }

  void loadData() async {
    var repository = BreedRepository();
    this.hasError.value = false;
    this.isOffline.value = false;

    bool hasConnection = await this._hasConnection();
    if(!hasConnection) {
      this._loadFromCache();
      return;
    }

    try {
    List<String> imagesResponse = await repository.getImagesByBreed(_breed.value.breed.toLowerCase());

    this.imageUrls.clear();
    this.imageUrls.addAll(imagesResponse);
    if(imagesResponse.isNotEmpty)
      this.breed.imageUrls = imagesResponse.sublist(0, imagesResponse.length >= 5 ? 5 : imagesResponse.length - 1);

    } catch(e) {
      this.hasError.value = true;
    }
  }

  Future<bool> _hasConnection() async {
    try {
      await InternetAddress.lookup('dog.ceo');
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> toggleFavorite() async {

    if(this.breed.isFavorite){
      this._breed.value.isFavorite = false;
      favoritesService.removeFavorite(this.breed);
    } else {
      bool hasConnection = await this._hasConnection();
      if(!hasConnection) {
        this.hasError.value = true;
        Get.snackbar(
          "Network Error", 
          "It is not possible to favorite without internet connection :-(",
          snackPosition: SnackPosition.BOTTOM, 
          margin: EdgeInsets.only(right: 10, bottom: 10, left: 10), 
        );
        return;
      }

      this._breed.value.isFavorite = true;
      favoritesService.addFavorite(this.breed);
    }
  }

  Future<void> _loadFromCache() async {
    List<String> imagesResponse = await favoritesService.getImagePathsFromCache(this.breed);
    this.isOffline.value = true;
    if(imagesResponse.isEmpty)
      this.hasError.value = true;
    else
      this.imageUrls.addAll(imagesResponse);
  }
}
