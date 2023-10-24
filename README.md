[![codecov](https://codecov.io/gh/gabuldev/flutter_injections/graph/badge.svg?token=G2b17lOXaU)](https://codecov.io/gh/gabuldev/flutter_injections)

# Flutter Injections
This package helps you to manage any dependencies in your project without need to use context and makes possible to create dependencies for modules. The objective is help any developer to manage dependencies with a easy to use API.

## Learn more

More details on the [documentation](https://gabuldev-packages.web.app/).

## Why Flutter Injections?

- __Fast and Efficient__
  > Flutter Injections use search-tree to get the dependencies, this improve the speed to get them, and use less CPU to search for specific objects.
- __Module Injections__
  > Create module injections that have all dependencies needed on your widgets. I.E __`HomeInjections`__ have all dependencies needed on __`HomePage`__.
- __Easy to use__
  > The focus is to keep it simple to handle dependencies on large scale applications.
- __Auto dispose__
  > Objects are auto disposed when FlutterInjection is removed from the Widget Tree.
- __Simple dispose__
  > With Flutter Injections you can dispose a specific object using `__dispose<T>` method.


## How to use

It`s simple, just three steps:

 1. Add the FlutterInjections to __pubspec.yaml__ file
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

    Or you can use extends the new widget __FlutterModule__ to add your dependencies
    ```dart
    class YourModule extends FlutterModule {
      const YourModule({Key? key}) : super(key: key);

      @override
      Widget get child => const YourPage();

      @override
        List<Inject<Object>> get injections => [
         Inject<YourRepository>((i) => YourRepository(client: i.find<Dio>())),
          Inject<YourController>(
              (i) => YourController(repository: i.find<YourRepository>())),
        ];
}

    ``` 


3. And finally, use it to get the dependencies:
    ```dart
    final controller = FlutterInjections.get<YourController>();
    ```  

- Direct and simple! Good job and have fun!

# Contribuitors

Be a contribuitor too!

<a href="https://github.com/gabuldev/flutter_injections/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=gabuldev/flutter_injections" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
