import 'package:flutter/material.dart';

import '../utils/shape_info.dart';

class ShapeText extends StatelessWidget {
  final ShapeInfo shapeInfo;
  const ShapeText({
    Key? key,
    required this.shapeInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.rectangle,
      size: shapeInfo.size,
      color: shapeInfo.color,
    );
  }
}
