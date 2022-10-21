import 'package:example/modules/home/widgets/home_alert_dialog/home_alert_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instance/flutter_instance.dart';

class HomeAlertWidget extends StatefulWidget {
  const HomeAlertWidget({Key? key}) : super(key: key);

  @override
  State<HomeAlertWidget> createState() => _HomeAlertWidgetState();
}

class _HomeAlertWidgetState extends State<HomeAlertWidget> {
  late final controller = FlutterInstance.get<HomeAlertDialogController>();

  @override
  Widget build(BuildContext context) {
    controller.getPhotos();
    return Container(
      color: Colors.green,
    );
  }
}
