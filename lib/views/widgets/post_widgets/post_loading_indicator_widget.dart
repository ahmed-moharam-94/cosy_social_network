import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../reusable_widgets/decorated_container_widget.dart';

class PostLoadingIndicator extends StatefulWidget {
  final bool postHasImage;

  const PostLoadingIndicator({Key? key, this.postHasImage = false})
      : super(key: key);

  @override
  State<PostLoadingIndicator> createState() => _PostLoadingIndicatorState();
}

class _PostLoadingIndicatorState extends State<PostLoadingIndicator> {
  bool animateContainer = false;

  void startAnimation() {
    if (mounted) {
      setState(() {
      animateContainer = true;
    });
    }
  }

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 10))
        .then((value) => startAnimation());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedContainerWidget(child: postContentWidgetBuilder());
  }

  Widget postContentWidgetBuilder() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userAvatarAndExperienceImageWidgetBuilder(),
            const SizedBox(width: smallPadding),
            postFakeContentWidget(),
          ],
        ),
      ],
    );
  }

  Widget userAvatarAndExperienceImageWidgetBuilder() {
    return Column(
      children: [
        fakeUserAvatarLoading(),
        const SizedBox(height: mediumPadding),
        experienceLoading(),
      ],
    );
  }

  Widget postFakeContentWidget() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fakeNameAndTopicWidgetBuilder(),
          fakePostTextWidgetBuilder(100),
          fakePostTextWidgetBuilder(200),
          fakePostTextWidgetBuilder(400),
          fakePostTextWidgetBuilder(300),
          fakePostTextWidgetBuilder(50),
          fakePostTextWidgetBuilder(150),
          if (widget.postHasImage) fakeImageWidgetBuilder(),
        ],
      ),
    );
  }

  Widget fakeNameAndTopicWidgetBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        fakePostTextWidgetBuilder(120),
        fakePostTextWidgetBuilder(60),
      ],
    );
  }

  Widget fakeImageWidgetBuilder() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: tinyPadding),
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(smallPadding)),
      ),
    );
  }

  Widget fakePostTextWidgetBuilder(double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.symmetric(vertical: tinyPadding),
      height: 20,
      width: animateContainer ? width : 0,
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(smallPadding)),
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
      width: 60,
      height: 60,
    );
  }

  Widget experienceLoading() {
    return const SizedBox(
      height: 60,
      width: 60,
    );
  }
}
