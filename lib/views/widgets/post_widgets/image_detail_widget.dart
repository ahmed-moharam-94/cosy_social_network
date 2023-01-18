import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailWidget extends StatelessWidget {
  final String userName;
  final String imageUrl;
  const ImageDetailWidget({Key? key, required this.userName, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(userName, style: const TextStyle(color: Colors.white)),
      ),
      body: PhotoView(
          loadingBuilder: (context, progress) => Center(
            child: loadingIndicatorWidgetBuilder(),
          ),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          basePosition: Alignment.center,
          imageProvider: NetworkImage(imageUrl)),
    );
  }


  Widget loadingIndicatorWidgetBuilder() {
    return const SizedBox(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(),
    );
  }
}
