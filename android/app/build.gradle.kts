import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
  keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
  id("com.android.application")
  id("com.google.gms.google-services")
  id("kotlin-android")
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "com.schedulelab.dutytable"
  compileSdk = flutter.compileSdkVersion
  ndkVersion = "27.0.12077973"

  compileOptions {
    isCoreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
  }

  kotlinOptions {
    jvmTarget = JavaVersion.VERSION_11.toString()
  }

  defaultConfig {
    applicationId = "com.schedulelab.dutytable"
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
    multiDexEnabled = true
  }

  signingConfigs {
    create("release") {
      keyAlias = keystoreProperties.getProperty("keyAlias")
      keyPassword = keystoreProperties.getProperty("keyPassword")
      storePassword = keystoreProperties.getProperty("storePassword")

      val stFile = keystoreProperties.getProperty("storeFile")
      if (stFile != null) {
        storeFile = file(stFile)
      }
    }
  }

  buildTypes {
    getByName("release") {
      signingConfig = signingConfigs.getByName("release")
      isMinifyEnabled = false
      isShrinkResources = false
    }
    getByName("debug") {
      signingConfig = signingConfigs.getByName("debug")
    }
  }
    buildFeatures {
        viewBinding = true
    }
}

flutter {
  source = "../.."
}

dependencies {
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
