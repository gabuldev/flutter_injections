---
sidebar_position: 3
---

# Get  parent dependencie
Use this method when you create a new instance of object and this object need a parent dependencie. For this you can use **find** method.

```dart
   final injections =  [ Inject<HomeRepository>((i) => HomeRepository(client: i.find<Object>())),];
```  

:::caution

You need create **Object** injection before this use

:::
