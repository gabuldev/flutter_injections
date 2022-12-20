---
sidebar_position: 1
---

# Introduction

This package helps you manage any dependencies in your project with whithout context and is possible to create dependencies for modules. The objective is help any developer to manage dependencies using a easy way for do this.

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


