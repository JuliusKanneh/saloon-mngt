import 'package:flutter/material.dart';
import 'package:saloon/theme/color_palette.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 5.222841262817383,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorPalette.blue,
      ),
    );
  }
}
