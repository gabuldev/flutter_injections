import 'package:flutter/material.dart';
import 'package:flutter_instance/flutter_instance.dart';

import '../../shared/helpers/state.dart';
import 'home_controller.dart';
import 'home_repository.dart';
import 'widgets/home_alert_dialog/home_alert_dialog_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final controller = FlutterInstance.get<HomeController>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller.getPosts();
    return FlutterInstance(
      injections: [
        Inject<HomeAlertDialogController>.singleton((i) =>
            HomeAlertDialogController(repository: i.find<HomeRepository>()))
      ],
      child: Scaffold(
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(onPressed: () {
            Navigator.pushNamed(context, "/alert");
          }),
          body: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              if (controller.state == AppState.success) {
                return ListView.builder(
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(controller.posts[index].title),
                  ),
                );
              } else if (controller.state == AppState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (controller.state == AppState.error) {
                return const Center(
                  child: Text("Não foi possível realizar a requisição"),
                );
              } else {
                return const SizedBox();
              }
            },
          )),
    );
  }
}
