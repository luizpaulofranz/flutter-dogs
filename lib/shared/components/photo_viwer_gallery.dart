import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerGallery extends StatelessWidget {
  final List<String> galleryItems;
  final int initialIndex;
  final bool isLocalFile;

  PhotoViewerGallery({required this.galleryItems, this.initialIndex = 0, this.isLocalFile = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(alignment: Alignment.topRight, children: <Widget>[
        PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            if(this.isLocalFile)
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(this.galleryItems[index])),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index]),
              );
            
            return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(this.galleryItems[index]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index]),
              );
          },
          itemCount: galleryItems.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded /
                        (event.expectedTotalBytes ?? 1),
              ),
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          pageController: PageController(initialPage: this.initialIndex),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: GestureDetector(
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 35,
            ),
            onTap: () => Get.back(),
          ),
        ),
      ]),
    );
  }
}
