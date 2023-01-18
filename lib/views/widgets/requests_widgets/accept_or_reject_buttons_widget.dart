import 'package:cozy_social_media_app/models/request.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import 'custom_dialog_widget.dart';

class AcceptAndRejectButtonWidget extends StatefulWidget {
  final Request request;

  const AcceptAndRejectButtonWidget({Key? key, required this.request})
      : super(key: key);

  @override
  State<AcceptAndRejectButtonWidget> createState() =>
      _AcceptAndRejectButtonWidgetState();
}

class _AcceptAndRejectButtonWidgetState
    extends State<AcceptAndRejectButtonWidget> {

  void showConfirmDialog(BuildContext context, bool accept) async {
    showDialog(
        context: context,
        builder: (_) {
          return CustomDialogWidget(
            request: widget.request,
            acceptButtonPressed: accept,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return acceptAndRejectButtonsWidget();
  }

  Widget acceptAndRejectButtonsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: mediumPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => showConfirmDialog(context, true),
              child: const Text('Accept'),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.90)),
            ),
            const SizedBox(width: mediumPadding),
            ElevatedButton(
              onPressed: () => showConfirmDialog(context, false),
              child: const Text('Reject'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.60)),
            ),
          ],
        ),
      ],
    );
  }
}
