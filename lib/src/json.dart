import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'utils.dart';

/// Handling fat-json message from [MethodChannel] in different [Isolate].
class FatJsonMethodChannel extends MethodChannel {
  const FatJsonMethodChannel(String name)
      : super(name, const FatJsonMethodCodec());

  @override
  Future<T?> invokeMethod<T>(String method, [arguments]) async {
    final ByteData? result = await binaryMessenger.send(
      name,
      codec.encodeMethodCall(MethodCall(method, arguments)),
    );
    if (result == null) {
      throw MissingPluginException(
          'No implementation found for method $method on channel $name');
    }
    // FatJsonMethodCodec decoded result is a Future
    final decoded = codec.decodeEnvelope(result);
    if (decoded is Future) {
      return await decoded;
    }
    // ignore: avoid_as
    return decoded as T?;
  }
}
/// Encode and decode fat-json for method arguments in different [Isolate].
class FatJsonMethodCodec extends JSONMethodCodec {
  const FatJsonMethodCodec();

  @override
  Future<dynamic> decodeEnvelope(ByteData envelope) async {
    final dynamic decoded = const FatJsonMessageCodec().decodeMessage(envelope);
    dynamic result;
    if (decoded is Future) {
      result = await decoded;
    } else {
      result = decoded;
    }
    if (result is! List) {
      throw FormatException('Expected envelope List, got $result');
    }
    if (result.length == 1) return result[0];
    if (result.length == 3 &&
        result[0] is String &&
        (result[1] == null || result[1] is String)) {
      throw PlatformException(
        code: result[0],
        message: result[1],
        details: result[2],
      );
    }
    throw FormatException('Invalid envelope: $result');
  }
}
/// Encode and decode fat-json message in different [Isolate].
class FatJsonMessageCodec extends JSONMessageCodec {
  const FatJsonMessageCodec();

  @override
  dynamic decodeMessage(ByteData? message) {
    if (message == null) return null;
    var bytes = message.buffer
        .asUint8List(message.offsetInBytes, message.lengthInBytes);
    return decodeJson(bytes);
  }
}
