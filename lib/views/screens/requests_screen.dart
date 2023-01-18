import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/strings.dart';
import '../../controllers/request_controller.dart';
import '../widgets/requests_widgets/requests_list_widget.dart';
import '../widgets/sliver_appbar_widget.dart';

class RequestsScreen extends StatefulWidget {
  static const String routeName = 'NotificationScreen';

  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool isLoading = false;

  Future<void> getReceivedRequests() async {
    setLoadingValue(true);
    await Provider.of<RequestController>(context, listen: false)
        .getReceivedRequests();
    setLoadingValue(false);
  }

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
      isLoading = !isLoading;
    });
    }
  }



  @override
  void initState() {
    getReceivedRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: isLoading
            ? const CircularLoadingIndicatorWidget()
            : Consumer<RequestController>(
              builder: (_, requestController, ch) {
                final receivedRequests = requestController.receivedRequests;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const CustomSliverAppBarWidget(
                      title: 'Received Requests',
                    ),
                    if (receivedRequests.isEmpty)
                      youDidNotReceiveRequestsYetWidget(),
                    if (receivedRequests.isNotEmpty)
                      RequestsListWidget(receivedRequests: receivedRequests),
                  ],
                );
              },
            ));
  }

  Widget youDidNotReceiveRequestsYetWidget() {
    return SliverToBoxAdapter(
        child: Column(
      children: const [
        SizedBox(height: hugePadding),
        Center(
            child: Text(
          youDidNotReceiveRequests,
          style: TextStyle(fontSize: 18),
        )),
      ],
    ));
  }
}

