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

:::caution

You need pass the **type** on Inject<\T> of object inject.

:::