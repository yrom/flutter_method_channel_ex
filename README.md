# method_channel_ex
Alternative Flutter method channel.

## FatJsonMethodChannel
Encode/decode method channel's arguments/result in different Isolate (based on package '[dart-executor](https://github.com/yrom/dart-executor)'), alternative for `JSONMethodChannel`.

## Usage

Add dependency in `pubspec.yaml`:

```yaml
dependencies:
  method_channel_ex: 
    git: https://github.com/yrom/flutter_method_channel_ex.git
```

In flutter:
```dart
import 'package:method_channel_ex/method_channel_ex.dart';

var channel = FatJsonMethodChannel("test");
var json = channel.invokeMethod("getAFatJson");

```

In native (e.g. Android):

```kotlin

MethodChannel(
    flutterView,
    "test",
    JSONMethodCodec.INSTANCE
).setMethodCallHandler { methodCall, result ->
    if (methodCall.method == "getAFatJson") {
        val json = JSONObject()

        for (i in 1..1000) {
            json.put("$i", "abc".repeat(i % 10))
        }
        result.success(json)
    } else {
        result.notImplemented()
    }
}
```


