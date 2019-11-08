package com.example.example

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(
            flutterView,
            "test",
            StandardMethodCodec.INSTANCE
        ).setMethodCallHandler { methodCall, result ->
            if (methodCall.method == "getAFatJson") {
                val json = LinkedHashMap<String, String>()

                for (i in 1..1000) {
                    json.put("$i", "abc".repeat(i % 10))
                }
                result.success(json)
            } else {
                result.notImplemented()
            }
        }
    }
}
