import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedImage extends StatelessWidget {
  final ImageProvider image;
  final double height;
  final double width;
  final String heroTag;

  RoundedImage(this.image, {this.height = 50, this.width = 50, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(image: image, fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken))),
    );
  }
}
