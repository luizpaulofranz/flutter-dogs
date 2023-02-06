import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import 'package:dog_lover/modules/breed/pages/breed_page.dart';
import 'package:dog_lover/modules/favorites/pages/favorites_page.dart';
import 'package:dog_lover/modules/home/components/breed_item.dart';
import 'package:dog_lover/modules/home/controllers/breeds_controller.dart';
import 'package:dog_lover/shared/components/app_bar.dart';
import 'package:dog_lover/shared/components/error_content.dart';
import 'package:dog_lover/shared/components/loading_content.dart';

class HomePage extends StatelessWidget {

  late final BreedsController _controller;
  late final _inputController;

  HomePage(){
    _controller = BreedsController();
    _controller.loadData();
    _inputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Breeds List", 
        showLogo: true,
        actions: [
          GestureDetector(
            onTap: () => Get.to(FavoritesPage())?.then((_) => _controller.loadData()),
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.star, size: 30, color: Colors.white,),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 5),
            TextField(
              controller: _inputController,
              onSubmitted: (value) => _controller.searchBreed(value),
              decoration: InputDecoration(
                hintText: "Breeds finder",
                suffixIcon: IconButton(
                  onPressed: () => _controller.searchBreed(_inputController.text),
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (_controller.breeds.isEmpty && _controller.hasError.value == false)
                  return LoadingContent();

                if (_controller.breeds.isEmpty && _controller.hasError.value == true)
                  return ErrorContent(onTap: () => _controller.loadData());

                return ListView(
                  children: _controller.breeds.map((breed) => 
                    BreedItem(
                      breed: breed,
                      cardOnTap: () => Get.to(BreedPage(breed: breed))?.then((_) => _controller.loadData()),
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
