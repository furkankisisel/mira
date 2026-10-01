plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream
import java.io.InputStreamReader
import java.nio.charset.StandardCharsets

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    InputStreamReader(FileInputStream(keystorePropertiesFile), StandardCharsets.UTF_8).use { reader ->
        keystoreProperties.load(reader)
    }
}

android {
    namespace = "com.koralabs.mira"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    // Determine if a valid keystore file is present
    val hasKeystoreProps = keystorePropertiesFile.exists()
    val storeFilePropForCheck: String? = keystoreProperties.getProperty("storeFile")
    val resolvedStoreFileForCheck: java.io.File? = when {
        !storeFilePropForCheck.isNullOrBlank() && file(storeFilePropForCheck).exists() -> file(storeFilePropForCheck)
        file("key.jks").exists() -> file("key.jks")
        rootProject.file("key.jks").exists() -> rootProject.file("key.jks")
        else -> null
    }
    val hasValidKeystore = hasKeystoreProps && (resolvedStoreFileForCheck?.exists() == true)

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.koralabs.mira"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Only create the release signing config when a VALID keystore file is present to avoid errors.
        if (hasValidKeystore && resolvedStoreFileForCheck != null) {
            create("release") {
                val keyAliasProp: String? = keystoreProperties.getProperty("keyAlias")
                val keyPasswordProp: String? = keystoreProperties.getProperty("keyPassword")
                val storePasswordProp: String? = keystoreProperties.getProperty("storePassword")

                if (!keyAliasProp.isNullOrBlank()) keyAlias = keyAliasProp
                if (!keyPasswordProp.isNullOrBlank()) keyPassword = keyPasswordProp
                storeFile = resolvedStoreFileForCheck
                if (!storePasswordProp.isNullOrBlank()) storePassword = storePasswordProp
            }
        }
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now,
            // so `flutter run --release` works.
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = if (hasValidKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.activity:activity-ktx:1.9.2")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.android.material:material:1.12.0")
    // Google Play Billing library (required for Play Billing operations)
    implementation("com.android.billingclient:billing:6.0.1")
    
    // Jetpack Glance for home screen widgets
    implementation("androidx.glance:glance:1.1.1")
    implementation("androidx.glance:glance-appwidget:1.1.1")
    implementation("androidx.glance:glance-material3:1.1.1")
}

configurations.all {
    resolutionStrategy {
        force("androidx.glance:glance:1.1.1")
        force("androidx.glance:glance-appwidget:1.1.1")
        force("androidx.glance:glance-material3:1.1.1")
    }
}
