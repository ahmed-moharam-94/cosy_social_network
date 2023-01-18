import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/dims.dart';
import '../../../constants/enums.dart';
import '../../../constants/strings.dart';

class RequestStatusWidget extends StatelessWidget {
  final RequestStatus status;
  const RequestStatusWidget({Key? key, required this.status}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 35,
      padding: const EdgeInsets.symmetric(vertical: tinyPadding),
      child: Center(
          child: Text(
            statusText(status),
            style:
            TextStyle(color: Colors.grey.shade50, fontWeight: FontWeight.bold),
          )),
      decoration: BoxDecoration(
        color: statusColor(status),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
