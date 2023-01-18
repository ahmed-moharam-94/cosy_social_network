import 'package:cached_network_image/cached_network_image.dart';
import 'package:cozy_social_media_app/models/post.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';

import '../../../constants/dims.dart';
import '../post_widgets/image_detail_widget.dart';

class ImageViewerWidget extends StatelessWidget {
  final String image;
  final String userName;

  const ImageViewerWidget(
      {Key? key, required this.image, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToImageDetailScreen(context),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(generalRadius)),
        child: CachedNetworkImage(
          placeholder: (_, value) => const CircularProgressIndicator(color: Colors.grey),
          imageUrl: image,
        ),
      ),
    );
  }

  void navigateToImageDetailScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            ImageDetailWidget(userName: userName, imageUrl: image)));
  }
}
