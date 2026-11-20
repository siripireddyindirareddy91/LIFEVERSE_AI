plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val uploadStore = System.getenv("LIFEVERSE_KEYSTORE_PATH")
val uploadStorePassword = System.getenv("LIFEVERSE_STORE_PASSWORD")
val uploadAlias = System.getenv("LIFEVERSE_KEY_ALIAS")
val uploadKeyPassword = System.getenv("LIFEVERSE_KEY_PASSWORD")
val hasUploadSigning = listOf(uploadStore, uploadStorePassword, uploadAlias, uploadKeyPassword).all { !it.isNullOrBlank() }

android {
    namespace = "com.lifeverse.lifeverse_ai"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.lifeverse.lifeverse_ai"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasUploadSigning) {
            create("upload") {
                storeFile = file(uploadStore!!)
                storePassword = uploadStorePassword
                keyAlias = uploadAlias
                keyPassword = uploadKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasUploadSigning) signingConfigs.getByName("upload") else null
        }
    }
}

tasks.configureEach {
    if (name == "assembleRelease" || name == "bundleRelease" || name == "packageRelease") {
        doFirst {
            check(hasUploadSigning) { "Release signing requires LIFEVERSE_KEYSTORE_PATH, LIFEVERSE_STORE_PASSWORD, LIFEVERSE_KEY_ALIAS and LIFEVERSE_KEY_PASSWORD. Debug keys are never used for release." }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
