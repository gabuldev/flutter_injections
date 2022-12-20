---
sidebar_position: 4
---

# Dispose dependencie
Is very simple to dispose a dependencie, you need to method dispose and pass the type.
```dart
void dispose(){
   FlutterInjections.dispose<YourController>();
}
```  

:::caution

Recommend using this method when you have certain don't use this **object** again

:::
