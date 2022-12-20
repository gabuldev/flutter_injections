# Flutter Injections
This package helps you to manage any dependencies in your project whithout need to use context and makes possible to create dependencies for modules. The objective is help any developer to manage dependencies with a easy to use API.

## Learn more

Use the [documentation](https://gabuldev-packages.web.app/) to improve your knowlegeds about this packages

## Why Flutter Injections?

- This package use search-tree to get the dependencies, this improve the speed to get, and use less CPU to search for specific objects.
- Provide you a way to create a module injections, i.e __HomeInjections__ have all dependencies needed on __HomePage__.
- Easy to use, the focus is to keep it simple to handle dependencies on large scale applications.
- Auto dispose objects when FlutterInjection is removed from the Widget Tree.
- With Flutter Injections you can dispose a specific object using `__dispose<T>` method.


## How to use
 It`s simple, just three steps:

 1. add on __pubspec.yaml__ file
```yaml
   flutter_injections: ^any # or current version
```
2. Create your __FlutterInjections__ anywhere you to need.

```dart
class YourPageInjections extends StatelessWidget {
  const YourPageInjections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjections(injections: [
      Inject<YourRepository>((i) => YourRepository(client: i.find<Dio>())),
      Inject<YourController>(
          (i) => YourController(repository: i.find<YourRepository>())),
    ], child: const YourPage());
  }
}
``` 

3. And finally, you use the `FlutterInjections` to get the dependencies:

```dart
    final controller = FlutterInjections.get<YourController>();
```  

- Direct and simple! Good job and have fun!

