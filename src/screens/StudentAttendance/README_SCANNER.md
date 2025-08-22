# Scanner Implementation Guide

## Overview
This document explains the implementation of the QR code scanner in the SiPresensi mobile application using `expo-camera`. The scanner is designed to work on real devices rather than emulators.

## Implementation Details

### Technology Used
- `expo-camera`: For camera access and QR code scanning
- `expo-intent-launcher`: For opening app settings on Android
- `expo-barcode-scanner`: Still included but not actively used in the new implementation

### Key Features
1. Camera permission handling with settings redirect
2. QR code scanning with visual viewfinder
3. Flashlight toggle functionality
4. Camera switching between front and back
5. Rate limiting to prevent multiple scans
6. Vibration feedback on successful scan
7. Data validation for scanned QR codes

## File Structure
```
src/
└── screens/
    └── StudentAttendance/
        ├── ExpoCameraScanner.tsx     # Main scanner component
        ├── scannerHelpers.ts         # Helper functions
        └── StudentAttendanceScreen.tsx # Parent component
```

## How It Works

### 1. Permission Handling
When the scanner component mounts, it requests camera permission from the user. If permission is denied, the user is prompted to open app settings to grant permission.

### 2. Scanner Activation
When the user taps the "Scan QR Code" button:
1. If permission hasn't been granted, it requests permission
2. If permission is granted, it opens the camera view
3. The camera view displays a viewfinder overlay with corner markers

### 3. QR Code Detection
The scanner continuously detects QR codes within the viewfinder:
1. When a QR code is detected, it validates the data
2. If valid, it triggers vibration feedback
3. It calls the parent component's callback with the QR code data
4. The scanner view closes

### 4. Controls
- **Flash Toggle**: Turns the flashlight on/off
- **Camera Switch**: Switches between front and back cameras
- **Cancel**: Closes the scanner view

## Usage Instructions

### For Developers
1. Import the `ExpoCameraScanner` component:
   ```tsx
   import { ExpoCameraScanner } from './ExpoCameraScanner';
   ```

2. Use the component in your screen:
   ```tsx
   <ExpoCameraScanner
     onQRScan={(qrCode) => handleQRScan(qrCode)}
     loading={loading}
   />
   ```

3. Implement the `handleQRScan` function to process the scanned QR code data.

### For End Users
1. Tap the "Scan QR Code" button
2. Grant camera permission if prompted
3. Point the camera at a QR code within the viewfinder
4. Wait for vibration feedback indicating successful scan
5. The app will process the attendance automatically

## Testing on Real Devices

### Important Note
The QR code scanner **does not work on emulators** and must be tested on real devices.

### Testing Steps
1. Connect a physical Android or iOS device to your computer
2. Enable USB debugging on the device
3. Run `npm start` in the project directory
4. Scan the QR code displayed in the terminal with the Expo Go app
5. Test the scanner functionality

## Troubleshooting

### Common Issues

#### 1. Camera Permission Denied
- Solution: Open app settings and manually grant camera permission

#### 2. Scanner Not Detecting QR Codes
- Solution: Ensure the QR code is within the viewfinder and well-lit

#### 3. Flashlight Not Working
- Solution: Not all devices support flashlight control; this is a hardware limitation

#### 4. Camera Switch Not Working
- Solution: Not all devices have multiple cameras; this is a hardware limitation

## Future Improvements

### Planned Enhancements
1. Add torch mode support for devices that support it
2. Improve error handling for different device capabilities
3. Add analytics for scanning success rates
4. Implement offline QR code caching

## Dependencies

### Required Packages
- `expo-camera`: For camera access and QR code scanning
- `expo-intent-launcher`: For opening app settings
- `expo-barcode-scanner`: Included for compatibility (not actively used)

## Best Practices

### For Implementation
1. Always check for camera permission before opening the scanner
2. Implement rate limiting to prevent multiple scans
3. Provide clear visual feedback to users
4. Handle errors gracefully with informative messages
5. Test on multiple device types and OS versions

### For UX
1. Ensure the viewfinder is clearly visible
2. Provide clear instructions for scanning
3. Give immediate feedback when a scan is successful
4. Make cancel/close actions easy to access
5. Handle low-light conditions appropriately