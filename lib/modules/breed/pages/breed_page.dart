import 'package:dog_lover/modules/home/models/breed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import 'package:dog_lover/modules/breed/components/image_card.dart';
import 'package:dog_lover/modules/breed/controllers/breed_controller.dart';
import 'package:dog_lover/shared/components/app_bar.dart';
import 'package:dog_lover/shared/components/error_content.dart';
import 'package:dog_lover/shared/components/loading_content.dart';
import 'package:dog_lover/shared/components/photo_viwer_gallery.dart';


class BreedPage extends StatefulWidget {
  final BreedModel breed;

  BreedPage({required this.breed});

  @override
  _BreedPageState createState() => _BreedPageState();
}

class _BreedPageState extends State<BreedPage> {

  late final BreedController _controller;

  @override
  void initState() {
    _controller = BreedController();
    _controller.breed = widget.breed;
    _controller.loadData();
    super.initState();
  }

  void _openGallery(int currentIndex, List<String> galleryItems) {
    Get.to(
      PhotoViewerGallery(
        galleryItems: galleryItems,
        initialIndex: currentIndex,
        isLocalFile: _controller.isOffline.value,
      ),
    );
  }

  void toggleFavorite() async {
    await _controller.toggleFavorite();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: _controller.breed.breed,
        actions: [
          GestureDetector(
            onTap: this.toggleFavorite,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                _controller.breed.isFavorite ? Icons.star : Icons.star_border_outlined, 
                size: 30, 
                color: Colors.yellow
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  if (_controller.imageUrls.isEmpty && _controller.hasError.value == false)
                    return LoadingContent();

                  if (_controller.imageUrls.isEmpty && _controller.hasError.value == true)
                    return ErrorContent(onTap: () => _controller.loadData());

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _controller.imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _openGallery(index, _controller.imageUrls),
                        child: ImageCard(imagePath: _controller.imageUrls[index], isLocalFile: _controller.isOffline.value),
                      );
                    },
                  );   
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
