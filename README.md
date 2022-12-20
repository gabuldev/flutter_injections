# Flutter Injections
This package helps you manage any dependencies in your project with whithout context and is possible to create dependencies for modules. The objective is help any developer to manage dependencies using a easy way for do this.

## Learn more

Used this [documentation](https://gabuldev-packages.web.app/) to improve your knowlegeds about this packages

## Features

- This package use search-tree to get the dependencies, this improve the velocity to get and use more less CPU to search the specific object.
- Provide you create a module injections, such as __HomeInjections__ have all dependencies you to need on __HomePage__.
- Is easy to use, the focus is keep it simple to create a great application.
- Auto dispose when you remove the FlutterInjection on your Widget Tree.
- You can dispose a specific object using __dispose<T> method.


## How to use
 It`s simple, you need three step to add this package

 - add on __pubspec.yaml__ file
```yaml
   flutter_injections: ^any # or current version
```
- Create your __FlutterInjections__ anywhere you to need.

``` dart
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

  - And get the dependencies is simple. See below

```dart
    final controller = FlutterInjections.get<YourController>();
```  

  - So, that's it! Great job for you.

