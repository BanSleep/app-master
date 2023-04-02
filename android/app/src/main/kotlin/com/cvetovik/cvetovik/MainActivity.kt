package com.cvetovik.mobile

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.engine.FlutterEngine


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("89c44946-e909-4272-b949-b338ba46f37f")
        super.configureFlutterEngine(flutterEngine)
    }
}
