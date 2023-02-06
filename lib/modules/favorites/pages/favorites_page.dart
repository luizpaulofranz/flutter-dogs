import 'dart:convert';

import 'package:dog_lover/shared/style/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:dog_lover/modules/breed/pages/breed_page.dart';
import 'package:dog_lover/modules/favorites/controllers/favorites_controller.dart';
import 'package:dog_lover/modules/favorites/services/favorites_service.dart';
import 'package:dog_lover/modules/home/components/breed_item.dart';
import 'package:dog_lover/modules/home/models/breed_model.dart';
import 'package:dog_lover/shared/components/app_bar.dart';
import 'package:dog_lover/shared/components/error_content.dart';
import 'package:dog_lover/shared/style/app_text_styles.dart';

class FavoritesPage extends StatelessWidget {

  late final FavoritesController _controller;
  late final FavoritesService _favoritesService;

  FavoritesPage(){
    _favoritesService = FavoritesService();
    _controller = FavoritesController();
    _controller.loadData();
  }

  void _removefavoriteAction(BreedModel breed) {
    if(breed.isFavorite)
      _favoritesService.removeFavorite(breed);
    _controller.loadData();
  }

  Widget _emptyListContent() {
    return Center(
      child: Text("There is no favorites ...", style: AppTextStyles.heading15)
    );
  }

  void _removeAllFavorites() {
    Get.defaultDialog(
      title: "Are you sure?",
      content: Column(
        children: [
          Text("This action will remove all favorites!"),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(), 
                  child: Text("No"),
                  style: ElevatedButton.styleFrom(primary: AppColors.darkGreen)
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _controller.removeAllFavorites();
                    Get.back();
                  }, 
                  child: Text("Yes"),
                  style: ElevatedButton.styleFrom(primary: AppColors.darkRed)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Favorites List", 
        actions: [
          GestureDetector(
            onTap: _removeAllFavorites,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, size: 30, color: Colors.white,),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (_controller.breeds.isEmpty && _controller.hasError.value == false)
                  return _emptyListContent();

                if (_controller.breeds.isEmpty && _controller.hasError.value == true)
                  return ErrorContent(onTap: () => _controller.loadData());

                return ListView(
                  children: _controller.breeds.map((breed) => 
                    BreedItem(
                      breed: breed,
                      cardOnTap: () => Get.to(BreedPage(breed: breed)),
                      favoriteOnTap: () => _removefavoriteAction(breed),
                    ),
                  ).toList().cast<Widget>(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
