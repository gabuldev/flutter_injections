## 1.2.0
- Bugfix: a module rebuilt by its parent (or by a hot reload) registered its
  injections again on every rebuild. Each rebuild created new instances (a
  `lazySingleton` was built once per rebuild) and stacked a level that leaving
  the module never removed, so its injections kept resolving after it left the
  tree. `FlutterInjectionsWidget` now registers once, when it enters the tree,
  keeps the same instances while it is there, and removes exactly its own level
  when it leaves.
- Breaking: the public `FlutterInjectionsWidget.instance` field is gone (the
  registry now lives in the widget's `State`). `FlutterInjectionsWidget` has a
  `const` constructor.
- The package imports only `package:flutter/widgets.dart`, not Material
  (deprecated in Flutter 3.50 in favour of `material_ui`).
## 1.1.2
- Documentation: write a short description about the package.
## 1.1.1
- Bugfix: when change module closed all injections
## 1.1.0
- Released stable version
- Add new widget __FlutterModule__
- Rename widget __FlutterInjections__ to __FlutterInjectionsWidget__
- Create all tests
## 1.0.3-beta
- Add contribuitors sections on reademe
## 1.0.2-beta
- Update descriptions on Readme and Doc
## 1.0.1-beta
- Fix Readme.md
## 1.0.0-beta

* TODO: Initial version beta released.
- This package use search-tree to get the dependencies, this improve the velocity to get and use more less CPU to search the specific object.
- Provide you create a module injections, such as __HomeInjections__ have all dependencies you to need on __HomePage__.
- Is easy to use, the focus is keep it simple to create a great application.
- Auto dispose when you remove the FlutterInjection on your Widget Tree.
- You can dispose a specific object using __dispose<T> method.