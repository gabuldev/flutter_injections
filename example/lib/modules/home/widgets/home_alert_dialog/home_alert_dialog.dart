import 'package:example/modules/home/models/post_model.dart';
import 'package:example/modules/home/widgets/home_alert_dialog/home_alert_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

class HomeAlertWidget extends StatefulWidget {
  const HomeAlertWidget({Key? key}) : super(key: key);

  @override
  State<HomeAlertWidget> createState() => _HomeAlertWidgetState();
}

class _HomeAlertWidgetState extends State<HomeAlertWidget> {
  late final controller = FlutterInjections.get<HomeAlertDialogController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: controller.getPhotos(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data as List<PostModel>;
                return SingleChildScrollView(
                  child: Column(
                    children: list
                        .map((e) => ListTile(
                              title: Text(e.title),
                            ))
                        .toList(),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
