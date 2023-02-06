import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:dog_lover/shared/style/app_gradients.dart';
import 'package:dog_lover/shared/style/app_images.dart';
import 'package:dog_lover/shared/style/app_text_styles.dart';

class AppBarWidget extends PreferredSize {

  final String title;
  final bool showLogo;
  final List<Widget>? actions;

  AppBarWidget({required this.title, this.showLogo = false, this.actions}) : super(
    preferredSize: Size.fromHeight(70),
    child: AppBar(
      leading: showLogo ? 
        Container(
          alignment: Alignment.centerRight,
          child: SvgPicture.asset(AppImages.logo, color: Colors.white,height: 30,),
        )
        : null,
      brightness: Brightness.dark,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.linear,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleBold,
      ),
      centerTitle: true,
      actions: actions,
    ),
  );
}