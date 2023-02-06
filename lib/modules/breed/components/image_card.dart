import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dog_lover/shared/style/app_colors.dart';

class ImageCard extends StatelessWidget {

  final String imagePath;
  final bool isLocalFile;

  ImageCard({required this.imagePath, this.isLocalFile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.border),
        ),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        width: double.maxFinite,
        child: this.isLocalFile ? Image.file(File(imagePath)) :
         Image.network(imagePath, 
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;

            return Center(
              child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? 
                    loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}