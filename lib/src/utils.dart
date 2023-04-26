import 'dart:convert';
import 'dart:typed_data';

import 'package:executor/executor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _max_json_bytes = 12 * 1024;
const _max_strlen = 6 * 1024;

/// result can be [List], [Map], [Future], and null
dynamic decodeJson(Uint8List? bytes) {
  if (bytes == null) return null;
  if (bytes.lengthInBytes <= _max_json_bytes) {
    return _decodeMessage(bytes);
  }
  assert((){
    print("decode fat json in cache executor, bytes: ${bytes.lengthInBytes}");
    return true;
  }());
  return cachedExecutor.run(_decodeMessage, bytes);
}

/// result can be [List], [Map], [Future], and null
dynamic decodeJsonString(String? source) {
  if (source == null) return null;
  if (source.length <= _max_strlen) {
    return json.decode(source);
  }
  assert((){
    print("decode fat json in cache executor, strlen: ${source.length}");
    return true;
  }());
  return cachedExecutor.run(_decodeJsonString, source);
}

dynamic _decodeMessage(Uint8List bytes) {
  var str = utf8.decoder.convert(bytes);
  return json.decode(str);
}
const _max_standard_message_bytes = 48 * 1024;

dynamic _decodeJsonString(String source) => json.decode(source);

dynamic decodeStandardMessageBuffer(ReadBuffer buffer) {
  if (buffer.data.lengthInBytes >= _max_standard_message_bytes) {
    assert((){
      print("decode fat message data in cache executor, bytes: ${buffer.data.lengthInBytes}");
      return true;
    }());
    return cachedExecutor.run(_decodeStandardMessageBuffer, buffer);
  }
  return _decodeStandardMessageBuffer(buffer);
}

dynamic _decodeStandardMessageBuffer(ReadBuffer buffer) {
  return const StandardMessageCodec().readValue(buffer);
}