import 'package:flutter/material.dart';

class CircularLoadingIndicatorWidget extends StatelessWidget {
  const CircularLoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
