plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keys/key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "net.e1547"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "net.e1547"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystoreProperties.containsKey("storeFile")) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                initWith(getByName("debug"))
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            applicationIdSuffix = ".debug"
        }
    }

    // Splits and AAB builds are mutually exclusive in AGP 8 (the bundle
    // task chokes on per-ABI shrunk-resources outputs). Enable splits
    // only when the gradle invocation is building APKs, not bundles.
    // See https://issuetracker.google.com/402800800
    val buildingBundle = gradle.startParameter.taskNames.any {
        it.contains("bundle", ignoreCase = true)
    }
    splits {
        abi {
            isEnable = !buildingBundle
            reset()
            include("arm64-v8a", "armeabi-v7a")
            isUniversalApk = true
        }
    }

    dependenciesInfo {
        includeInApk = false
        includeInBundle = false
    }
}

flutter {
    source = "../.."
}

androidComponents {
    onVariants(selector().withBuildType("release")) { variant ->
        // AAR-provided native libraries (libmpv, cronet, sqlite) ignore
        // flutter's --target-platform flag, and build type abi filters do
        // not apply to split outputs. Excluding the paths from the native
        // library merge drops the x86_64 copies from the release universal
        // APK. No phone runs x86_64; debug builds stay unfiltered for
        // emulator developers.
        variant.packaging.jniLibs.excludes.addAll(
            listOf("lib/x86_64/**", "**/lib/x86_64/**", "lib/x86/**")
        )
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
