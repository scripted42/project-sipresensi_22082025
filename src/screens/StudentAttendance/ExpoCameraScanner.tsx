import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert, Platform, Linking, Vibration } from 'react-native';
import { Camera, CameraType, FlashMode, BarcodeScannerResult } from 'expo-camera';
import * as IntentLauncher from 'expo-intent-launcher';

interface ExpoCameraScannerProps {
  onQRScan: (qrCode: string) => void;
  loading: boolean;
}

export const ExpoCameraScanner = ({ onQRScan, loading }: ExpoCameraScannerProps) => {
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [scanning, setScanning] = useState(false);
  const [torchMode, setTorchMode] = useState<FlashMode>(FlashMode.off);
  const [cameraType, setCameraType] = useState<CameraType>(CameraType.back);
  const cameraRef = useRef<Camera>(null);
  const scanTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const lastScanTimeRef = useRef<number>(0);

  useEffect(() => {
    (async () => {
      // Meminta izin kamera saat komponen dimuat
      await requestCameraPermission();
    })();
    
    // Cleanup function
    return () => {
      if (scanTimeoutRef.current) {
        clearTimeout(scanTimeoutRef.current);
      }
    };
  }, []);

  const requestCameraPermission = async () => {
    try {
      const { status } = await Camera.requestCameraPermissionsAsync();
      setHasPermission(status === 'granted');
      
      if (status !== 'granted') {
        showPermissionAlert();
      }
    } catch (error) {
      console.error('Error requesting camera permission:', error);
      Alert.alert('Error', 'Failed to request camera permission');
    }
  };

  const showPermissionAlert = () => {
    Alert.alert(
      'Permission required', 
      'Camera permission is needed to scan QR codes',
      [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Open Settings', onPress: openSettings }
      ]
    );
  };

  const openSettings = () => {
    if (Platform.OS === 'ios') {
      Linking.openURL('app-settings:');
    } else {
      IntentLauncher.startActivityAsync(IntentLauncher.ActivityAction.APPLICATION_DETAILS_SETTINGS, {
        data: 'package:' + 'sipresensi.mobile',
      });
    }
  };

  const toggleTorch = () => {
    setTorchMode(torchMode === FlashMode.off ? FlashMode.torch : FlashMode.off);
  };

  const switchCamera = () => {
    setCameraType(cameraType === CameraType.back ? CameraType.front : CameraType.back);
  };

  const handleBarCodeScanned = ({ type, data }: BarcodeScannerResult) => {
    // Rate limiting - prevent multiple scans in quick succession
    const now = Date.now();
    if (now - lastScanTimeRef.current < 1000) { // 1 second interval
      return;
    }
    
    lastScanTimeRef.current = now;
    
    // Validasi data QR (bisa ditambahkan validasi khusus sesuai kebutuhan)
    if (!data || data.trim().length === 0) {
      Alert.alert('Invalid QR Code', 'The scanned QR code is not valid');
      return;
    }
    
    // Vibrasi saat scan berhasil
    Vibration.vibrate(100);
    
    // Hentikan scanning
    setScanning(false);
    
    // Panggil callback dengan data QR
    onQRScan(data);
  };

  const startScan = async () => {
    if (loading) return;
    
    // Jika izin belum diminta atau ditolak, minta izin
    if (hasPermission === null) {
      await requestCameraPermission();
    } else if (hasPermission === false) {
      showPermissionAlert();
      return;
    }
    
    setScanning(true);
  };

  if (scanning) {
    return (
      <View style={styles.scannerContainer}>
        {hasPermission ? (
          <Camera
            ref={cameraRef}
            style={StyleSheet.absoluteFillObject}
            type={cameraType}
            flashMode={torchMode}
            onBarCodeScanned={handleBarCodeScanned}
            barCodeScannerSettings={{
              barCodeTypes: ['qr'],
            }}
          >
            {/* Viewfinder overlay */}
            <View style={styles.overlay}>
              <View style={styles.topOverlay} />
              
              <View style={styles.centerOverlay}>
                <View style={styles.leftOverlay} />
                <View style={[styles.viewFinder, {
                  borderColor: '#007AFF',
                  borderWidth: 2,
                  height: 250,
                  width: 250,
                }]}>
                  {/* Corner markers */}
                  <View style={[styles.cornerMarker, styles.topLeft]} />
                  <View style={[styles.cornerMarker, styles.topRight]} />
                  <View style={[styles.cornerMarker, styles.bottomLeft]} />
                  <View style={[styles.cornerMarker, styles.bottomRight]} />
                </View>
                <View style={styles.rightOverlay} />
              </View>
              
              <View style={styles.bottomOverlay}>
                <Text style={styles.scannerText}>Align QR code within frame</Text>
                
                <View style={styles.controls}>
                  <TouchableOpacity
                    style={styles.controlButton}
                    onPress={toggleTorch}
                  >
                    <Text style={styles.controlButtonText}>
                      {torchMode === FlashMode.off ? 'Flash Off' : 'Flash On'}
                    </Text>
                  </TouchableOpacity>
                  
                  <TouchableOpacity
                    style={styles.controlButton}
                    onPress={switchCamera}
                  >
                    <Text style={styles.controlButtonText}>
                      Switch Camera
                    </Text>
                  </TouchableOpacity>
                </View>
                
                <TouchableOpacity
                  style={styles.cancelButton}
                  onPress={() => setScanning(false)}
                >
                  <Text style={styles.cancelButtonText}>Cancel</Text>
                </TouchableOpacity>
              </View>
            </View>
          </Camera>
        ) : (
          <View style={styles.permissionContainer}>
            <Text style={styles.permissionText}>Camera permission is required</Text>
            <TouchableOpacity
              style={styles.permissionButton}
              onPress={requestCameraPermission}
            >
              <Text style={styles.permissionButtonText}>Grant Permission</Text>
            </TouchableOpacity>
          </View>
        )}
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Scan QR Code</Text>
      <TouchableOpacity
        style={[styles.scanButton, loading && styles.disabledButton]}
        onPress={startScan}
        disabled={loading}
      >
        <Text style={styles.scanButtonText}>Scan QR Code</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 20,
    padding: 20,
    backgroundColor: 'white',
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
    textAlign: 'center',
  },
  scanButton: {
    backgroundColor: '#34C759',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  disabledButton: {
    opacity: 0.6,
  },
  scanButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
  scannerContainer: {
    flex: 1,
    backgroundColor: 'black',
  },
  permissionContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'black',
  },
  permissionText: {
    color: 'white',
    fontSize: 18,
    marginBottom: 20,
  },
  permissionButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
  },
  permissionButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
  overlay: {
    flex: 1,
  },
  topOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  centerOverlay: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  leftOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  rightOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  viewFinder: {
    borderWidth: 2,
    borderColor: '#007AFF',
    height: 200,
    width: 200,
    borderRadius: 8,
  },
  cornerMarker: {
    position: 'absolute',
    width: 20,
    height: 20,
    borderColor: '#007AFF',
  },
  topLeft: {
    top: 0,
    left: 0,
    borderTopWidth: 3,
    borderLeftWidth: 3,
  },
  topRight: {
    top: 0,
    right: 0,
    borderTopWidth: 3,
    borderRightWidth: 3,
  },
  bottomLeft: {
    bottom: 0,
    left: 0,
    borderBottomWidth: 3,
    borderLeftWidth: 3,
  },
  bottomRight: {
    bottom: 0,
    right: 0,
    borderBottomWidth: 3,
    borderRightWidth: 3,
  },
  bottomOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  scannerText: {
    color: 'white',
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 20,
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: '100%',
    marginBottom: 20,
  },
  controlButton: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    padding: 10,
    borderRadius: 5,
  },
  controlButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  cancelButton: {
    backgroundColor: '#ff3b30',
    padding: 15,
    borderRadius: 10,
    width: '100%',
    alignItems: 'center',
  },
  cancelButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
});