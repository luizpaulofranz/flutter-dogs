import 'package:flutter/material.dart';

import 'package:dog_lover/modules/home/models/breed_model.dart';
import 'package:dog_lover/shared/style/app_colors.dart';
import 'package:dog_lover/shared/style/app_text_styles.dart';

class BreedItem extends StatelessWidget {

  final BreedModel breed;
  final VoidCallback cardOnTap;
  final VoidCallback? favoriteOnTap;

  BreedItem({required this.breed, required this.cardOnTap, this.favoriteOnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.border),
          ),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10)),
      child: GestureDetector(
        onTap: cardOnTap,
        child: ListTile(
          title: Text(this.breed.breed, style: AppTextStyles.heading15),
          trailing: GestureDetector(
            onTap: this.favoriteOnTap,
            child: Icon(
              this.favoriteOnTap != null ? Icons.remove :
              this.breed.isFavorite ? Icons.star : Icons.star_border_outlined,
              size: 40,
              color: this.favoriteOnTap == null ? Colors.yellow : AppColors.darkRed,
            ),
          ),
        ),
      ),
    );
  }
}
