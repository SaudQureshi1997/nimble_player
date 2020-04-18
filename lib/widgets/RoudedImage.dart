import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedImage extends StatelessWidget {
  final ImageProvider image;
  final double height;
  final double width;

  RoundedImage(this.image, {this.height = 50, this.width = 50});

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.transparent,
      child: Image(
        fit: BoxFit.cover,
        image: image,
        height: height,
        width: width,
      ),
    );
  }
}
