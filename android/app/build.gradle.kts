import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties file if it exists
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.expen"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Add signing configuration
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                storeFile = file("keystore/expendus-key.jks")
                storePassword = System.getenv("KEYSTORE_PASSWORD") ?: "YOUR_KEYSTORE_PASSWORD"
                keyAlias = "expendus"
                keyPassword = System.getenv("KEY_PASSWORD") ?: "YOUR_KEY_PASSWORD"
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.expen"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use the release signing config
            signingConfig = signingConfigs.getByName("release")
            // Disable minification for now
            isMinifyEnabled = false
            // Disable resource shrinking
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Use the release build to resolve the conflicts
    bundle {
        // Disable the inclusion of configuration specific files
        language.enableSplit = false
        density.enableSplit = false
        abi.enableSplit = false
    }
    
    packagingOptions {
        // Exclude problematic files that might be causing conflicts
        resources.excludes.add("META-INF/DEPENDENCIES")
        resources.excludes.add("META-INF/LICENSE")
        resources.excludes.add("META-INF/LICENSE.txt")
        resources.excludes.add("META-INF/license.txt")
        resources.excludes.add("META-INF/NOTICE")
        resources.excludes.add("META-INF/NOTICE.txt")
        resources.excludes.add("META-INF/notice.txt")
        resources.excludes.add("META-INF/*.kotlin_module")
    }
}

flutter {
    source = "../.."
}
