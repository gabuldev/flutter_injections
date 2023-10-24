---
sidebar_position: 2
---

# How to use
You need to add __FlutterInjections__ widget before your __Page__. See below example.
```dart
class YourPageInjections extends StatelessWidget {
  const YourPageInjections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // highlight-start
    return FlutterInjections(injections: [
      Inject<YourRepository>((i) => YourRepository(client: i.find<Dio>())),
      Inject<YourController>(
          (i) => YourController(repository: i.find<YourRepository>())),
    ], child: const YourPage());
    // highlight-end
  }
}
```

Or you can use extends the new widget __FlutterModule__ to add your dependencies
```dart
    class YourModule extends FlutterModule {
      const YourModule({Key? key}) : super(key: key);

      @override
      Widget get child => const HomePage();

      @override
        List<Inject<Object>> get injections => [
          Inject<HomeRepository>((i) => HomeRepository(client: i.find<Dio>())),
          Inject<HomeController>(
              (i) => HomeController(repository: i.find<HomeRepository>())),
        ];
}

``` 

:::caution

You need pass the **type** on Inject<\T> of object inject.

:::