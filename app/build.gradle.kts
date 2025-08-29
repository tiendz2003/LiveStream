import com.ronaldo.livestream.build_logic.convention.implementation

plugins {
    alias(libs.plugins.livestream.android.application)
    alias(libs.plugins.livestream.android.application.compose)
    alias(libs.plugins.livestream.android.hilt)
}

android {
    namespace = "com.ronaldo.livestream"

    defaultConfig {
        applicationId = "com.ronaldo.livestream"
        versionCode = 1
        versionName = "0.0.1"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }

}

dependencies {
    implementation(projects.feature.login)
    implementation(projects.feature.home)

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.activity.compose)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    implementation(libs.androidx.navigation.compose)
}
