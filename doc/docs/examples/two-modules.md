---
sidebar_position: 3
---
# Using two modules
This is a small project to demonstrate the power of this lib.

Use the common navigation of Flutter to create this project. The first file is **main.dart** when have all controll  of navigation and **FlutterInjections** to provide a client Http for anywhere need this, this is a example of Global Injection.

```dart title='main.dart'
import 'package:dio/dio.dart';
import 'package:example/modules/home/widgets/home_alert_dialog/home_alert_dialog.dart';
import 'package:example/modules/splash/splash_injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'modules/home/home_injections.dart';
import 'shared/services/custom_dio/custom_dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjections(
        injections: [
          Inject<Dio>((i) => CustomDio()),
        ],
        child: MaterialApp(
          title: 'Flutter Offline First',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          initialRoute: "/splash",
          routes: {
            "/splash": (context) => const SplashInjections(),
            "/home": (context) => const HomeInjections(),
            "/alert": (context) => const HomeAlertWidget()
          },
        ));
  }
}
```

Now to create a **SplashInjections** to add any dependencies this page use and pass the **SplashPage** on child parameter.

```dart title='splash_injections.dart'
import 'package:example/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'splash_controller.dart';

class SplashInjections extends StatelessWidget {
  const SplashInjections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjectionsWidget(
      builder:(_) => const SplashPage(),
      injections: [
        Inject<SplashController>.singleton((i) => SplashController())
      ],
    );
  }
}
```


Now to create a **HomeInjections** to add any dependencies this page use and pass the **HomePage** on child parameter. This use a method **find** to recovery a global or parent injection and put on instance of the new object.


```dart title=home_injections.dart'
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'home_controller.dart';
import 'home_page.dart';
import 'home_repository.dart';

class HomeInjections extends StatelessWidget {
  const HomeInjections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjectionsWidget(injections: [
      Inject<HomeRepository>((i) => HomeRepository(client: i.find<Dio>())),
      Inject<HomeController>(
          (i) => HomeController(repository: i.find<HomeRepository>())),
    ], builder: (_) => const HomePage());
  }
}


```


The complete example here [github repository](https://github.com/gabuldev/flutter_injections/tree/main/example)