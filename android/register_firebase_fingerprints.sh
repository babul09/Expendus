#!/bin/bash

# This script outputs the SHA-1 and SHA-256 fingerprints for both debug and release keystores
# You can use these fingerprints to register your app with Firebase

echo "================================================================="
echo "EXPENDUS FIREBASE FINGERPRINTS"
echo "================================================================="
echo ""
echo "DEBUG KEYSTORE FINGERPRINTS (for development):"
echo "--------------------------------------------------------------------"
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android | grep -A 2 "Certificate fingerprints"
echo ""
echo "RELEASE KEYSTORE FINGERPRINTS (for production):"
echo "--------------------------------------------------------------------"
keytool -list -v -keystore app/keystore/expendus-key.jks -alias expendus -storepass android | grep -A 2 "Certificate fingerprints"
echo ""
echo "================================================================="
echo "INSTRUCTIONS:"
echo "1. Go to Firebase Console: https://console.firebase.google.com/"
echo "2. Select your project: expendus-f4501"
echo "3. Go to Project Settings > Your Apps > Android app"
echo "4. Add fingerprints at the bottom of the page"
echo "5. Download the updated google-services.json and replace the existing one"
echo "=================================================================" 