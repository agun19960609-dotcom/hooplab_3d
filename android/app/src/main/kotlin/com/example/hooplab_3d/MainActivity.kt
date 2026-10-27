package com.example.hooplab_3d

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hooplab/reel")
            .setMethodCallHandler { call, result ->
                if (call.method != "encode") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val dir = call.argument<String>("dir")
                val output = call.argument<String>("output")
                val fps = call.argument<Int>("fps") ?: 10
                val width = call.argument<Int>("width") ?: 540
                val height = call.argument<Int>("height") ?: 960
                if (dir == null || output == null) {
                    result.success(false)
                    return@setMethodCallHandler
                }
                try {
                    result.success(ReelEncoder.encode(dir, fps, width, height, output))
                } catch (err: Exception) {
                    result.success(false)
                }
            }
    }
}
