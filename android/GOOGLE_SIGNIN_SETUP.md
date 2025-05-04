# Google Sign-In Setup for Expendus

This guide will help you set up Google Sign-In for your Expendus app.

## Step 1: Register SHA-1 Fingerprints

Run the `register_firebase_fingerprints.sh` script to get both debug and release SHA-1 fingerprints:

```bash
cd android
bash register_firebase_fingerprints.sh
```

## Step 2: Add SHA-1 Fingerprints to Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `expendus-f4501`
3. Go to Project Settings > Your Apps > Android app
4. Add both the debug and release SHA-1 fingerprints at the bottom of the page
5. Download the updated `google-services.json` file

## Step 3: Enable Google Sign-In Method

1. In Firebase Console, go to Authentication
2. Click on "Sign-in method" tab
3. Enable "Google" as a sign-in provider
4. Save changes

## Step 4: Update google-services.json

1. Replace the `android/app/google-services.json` file with the newly downloaded one
2. Ensure the file contains your OAuth client ID and SHA certificate fingerprints

## Step 5: Testing

To test that Google Sign-In is working:

1. Run the app in debug mode with `flutter run`
2. Try to sign in with Google
3. If you encounter any errors, check the logs and verify your setup

## Reference SHA-1 Fingerprints

- Debug Keystore: `C5:57:98:42:D3:BA:8F:70:98:20:1A:A9:14:A2:69:02:5F:25:FD:E5`
- Release Keystore: `87:6A:16:BF:32:4B:8D:9B:5A:B4:29:ED:19:FD:FC:BC:82:01:80:7E`

## Client ID

Your Web Client ID: `666404751902-v2nah1cebnj8iae7cg5s9rvve9hn50g5.apps.googleusercontent.com` 