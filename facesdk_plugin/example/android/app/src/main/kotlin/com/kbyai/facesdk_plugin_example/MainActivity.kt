package com.kbyai.facesdk_plugin_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;

class MainActivity: FlutterActivity() {
    @Override
    fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.getPlatformViewsController().getRegistry()
            .registerViewFactory("facedetectionview", FaceDetectionViewFactory())
    }
}
