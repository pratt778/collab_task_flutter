pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    // FlutterFire — re-enable after running `flutterfire configure`. The plugin
    // requires `android/app/google-services.json` to exist; Gradle fails if it
    // doesn't, even when Dart doesn't call `Firebase.initializeApp()`.
    // id("com.google.gms.google-services") version("4.3.15") apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
