import 'package:cozy_social_media_app/views/widgets/post_widgets/post_loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../reusable_widgets/decorated_container_widget.dart';

class LoadingProfileWidget extends StatelessWidget {
  const LoadingProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        fakeProfileHeaderWidgetBuilder(screenHeight),
        fakeUserAboutWidgetBuilder(),
        fakeUserPostsWidgetBuilder(),
      ],
    );
  }

  Widget fakeProfileHeaderWidgetBuilder(double screenHeight) {
    return Container(
      height: screenHeight * 0.30,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.30),
      child: Stack(
        children: [
          Positioned(
              bottom: mediumPadding,
              left: smallPadding,
              child: fakeUserAvatarLoading()),
        ],
      ),
    );
  }

  Widget fakeUserAvatarLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: Colors.grey, width: 3),
      ),
      alignment: Alignment.center,
      width: 100,
      height: 100,
    );
  }

  Widget fakeUserAboutWidgetBuilder() {
    return const DecoratedContainerWidget(
      child: SizedBox(height: 100, width: double.infinity,),
    );
  }

  Widget fakeUserPostsWidgetBuilder() {
    return Column(children: const [
      PostLoadingIndicator(),
      PostLoadingIndicator(),
      PostLoadingIndicator(),
      PostLoadingIndicator(),
      PostLoadingIndicator(),
    ]);
  }
}
