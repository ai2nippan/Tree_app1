import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String path;
  //final double imgWidth;
  //final double imgHeight;
  const ShowImage({
    Key? key,
    required this.path,
    //required this.imgWidth,
    //required this.imgHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      //width: imgWidth,
      //height: imgHeight,
    );
  }
}
