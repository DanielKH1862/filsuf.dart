import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.imagepicker.ImagePickerPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Remove or comment out the line causing the error
        // ImagePickerWorkaround.registerWith(flutterEngine)
        
        // Instead, use the standard way to register the ImagePickerPlugin
        flutterEngine.plugins.add(ImagePickerPlugin())
    }
}
