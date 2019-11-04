# fat_json_method_channel
Encode/decode method channel's arguments/result in different Isolate (based on package '[dart-executor](https://github.com/yrom/dart-executor)'), alternative for `JSONMethodChannel`.

## Usage

Add dependency in `pubspec.yaml`:

```yaml
dependencies:
  fat_json_method_channel: 
    git: https://github.com/yrom/fat_json_method_channel.git
```

In flutter:
```dart
import 'package:fat_json_method_channel/fat_json_method_channel.dart';

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


