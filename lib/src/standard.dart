import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'utils.dart';

class StandardMethodChannel extends MethodChannel {
  StandardMethodChannel(String name) : super(name, const StandardMethodCodec2());


  @override
  Future<T> invokeMethod<T>(String method, [arguments]) async {
    assert(method != null);
    final ByteData result = await binaryMessenger.send(
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
    return decoded as T;
  }
}

class StandardMethodCodec2 extends StandardMethodCodec {
  const StandardMethodCodec2();

  @override
  Future<dynamic> decodeEnvelope(ByteData envelope) async {
    /// see [StandardMethodCodec.decodeEnvelope]
    if (envelope.lengthInBytes == 0)
      throw const FormatException('Expected envelope, got nothing');
    final ReadBuffer buffer = ReadBuffer(envelope);
    if (buffer.getUint8() == 0) {
      dynamic decoded = decodeStandardMessageBuffer(buffer);
      if (decoded is Future) {
        return await decoded;
      } else {
        return decoded;
      }
    }
    final dynamic errorCode = messageCodec.readValue(buffer);
    final dynamic errorMessage = messageCodec.readValue(buffer);
    final dynamic errorDetails = messageCodec.readValue(buffer);
    if (errorCode is String && (errorMessage == null || errorMessage is String) && !buffer.hasRemaining)
      throw PlatformException(code: errorCode, message: errorMessage, details: errorDetails);
    else
      throw const FormatException('Invalid envelope');
  }
}
