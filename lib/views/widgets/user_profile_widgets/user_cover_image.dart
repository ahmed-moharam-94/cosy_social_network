import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../post_widgets/image_detail_widget.dart';
import '../reusable_widgets/circular_loading_indicator_widget.dart';

class UserCoverImageWidget extends StatelessWidget {
  final String coverUrl;
  final String userName;

  const UserCoverImageWidget(
      {Key? key, required this.coverUrl, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coverUrl != '') {
      return networkCoverBuilder(context);
    } else {
      return noCoverWidgetBuilder();
    }
  }

  Widget noCoverWidgetBuilder() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: SvgPicture.asset('assets/images/auth_screen_image.svg'),
        ),
      ],
    );
  }

  Widget networkCoverBuilder(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToImageDetailScreen(context, userName, coverUrl),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: CachedNetworkImage(
          imageUrl: coverUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularLoadingIndicatorWidget(),
        ),
      ),
    );
  }

  void navigateToImageDetailScreen(
      BuildContext context, String userName, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ImageDetailWidget(
              userName: userName,
              imageUrl: imageUrl,
            )));
  }
}
