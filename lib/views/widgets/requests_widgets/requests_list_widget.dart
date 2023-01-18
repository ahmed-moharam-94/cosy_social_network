import 'package:cozy_social_media_app/views/widgets/requests_widgets/received_request_item_widget.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../models/request.dart';

class RequestsListWidget extends StatelessWidget {
  final List<Request> receivedRequests;

  const RequestsListWidget({Key? key, required this.receivedRequests})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final request = receivedRequests[index];
            return ReceivedRequestItemWidget(request: request);
          },
          childCount: receivedRequests.length,
        ));
  }
}
