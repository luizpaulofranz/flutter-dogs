import 'package:flutter/material.dart';
import 'package:dog_lover/shared/style/app_colors.dart';

class ErrorContent extends StatelessWidget {
  final VoidCallback onTap;
  const ErrorContent({ Key? key, required this.onTap }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ops, it does'nt work :-("),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: this.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Try again."),
                Icon(
                  Icons.autorenew, 
                  color: AppColors.darkRed,
                  size: 35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}