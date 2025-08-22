# Student Attendance Scanner Implementation

## Overview
This directory contains the implementation of the QR code scanner for student attendance in the SiPresensi mobile application. The scanner uses `expo-barcode-scanner` with several enhancements for better reliability and user experience.

## Files

### RobustScanQRSection.tsx
This is the main scanner component with the following features:
- Camera permission handling with settings redirect
- Rate limiting to prevent multiple scans
- Visual viewfinder with corner markers
- Vibration feedback on successful scan
- Data validation for scanned QR codes

### scannerConfig.ts
Configuration file containing:
- Supported barcode types
- Scanner settings (interval, vibration)
- UI settings for the viewfinder
- Helper functions for data validation and error formatting

## Implementation Details

### Camera Permissions
The scanner automatically requests camera permissions when loaded. If permissions are denied, users are prompted to open app settings to enable them.

### Rate Limiting
To prevent accidental multiple scans, the scanner implements a rate limiting mechanism that only allows one scan per 500ms.

### Supported Barcode Types
The scanner supports the following barcode types:
- QR codes
- EAN-13
- EAN-8
- Code 128
- Code 39

### UI Features
- Visual viewfinder with corner markers for better alignment
- Cancel button to exit scanning mode
- Vibration feedback on successful scan

## Usage
The scanner component is used in the StudentAttendanceScreen and provides a callback function `onQRScan` that receives the scanned QR code data.

## Error Handling
The scanner includes comprehensive error handling for:
- Camera permission issues
- Invalid QR code data
- Network errors
- API errors

## Dependencies
- `expo-barcode-scanner`
- `expo-intent-launcher`
- `@react-native-async-storage/async-storage`

## Limitations
- Flashlight control is not supported in the current implementation
- Camera switching is not supported in the current implementation
- These features would require a different library or native implementation