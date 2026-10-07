#!/bin/bash
set -e
BUILD_TOOLS=$ANDROID_HOME/build-tools/34.0.0
PLATFORM=$ANDROID_HOME/platforms/android-34/android.jar
echo "=== 1. Compiling Resources ==="
mkdir -p build/compiled_res
$BUILD_TOOLS/aapt2 compile --dir app/src/main/res -o build/compiled_res/
echo "=== 2. Linking Resources ==="
mkdir -p build/gen
$BUILD_TOOLS/aapt2 link -o build/app.unsigned.apk -I $PLATFORM --manifest app/src/main/AndroidManifest.xml --java build/gen build/compiled_res/*.flat
echo "=== 3. Compiling Kotlin ==="
mkdir -p build/classes
SOURCES=$(find app/src/main/java -name "*.kt")
R_JAVA=$(find build/gen -name "R.java")
kotlinc -cp $PLATFORM -d build/classes $SOURCES $R_JAVA
echo "=== 4. Converting to DEX ==="
mkdir -p build/dex
$BUILD_TOOLS/d8 --output build/dex --lib $PLATFORM build/classes/*
echo "=== 5. Injecting DEX ==="
zip -j build/app.unsigned.apk build/dex/classes.dex
echo "=== 6. Aligning and Signing ==="
$BUILD_TOOLS/zipalign -f 4 build/app.unsigned.apk build/app.aligned.apk
keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Debug, OU=Debug, O=Debug, L=Debug, ST=Debug, C=US"
$BUILD_TOOLS/apksigner sign --ks debug.keystore --ks-pass pass:android --ks-key-alias androiddebugkey --key-pass pass:android --out build/ceremoni.apk build/app.aligned.apk
echo "✅ BUILD SUCCESSFUL"
