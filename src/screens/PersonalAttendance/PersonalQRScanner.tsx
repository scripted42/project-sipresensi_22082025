import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { BarCodeScanner } from 'expo-barcode-scanner';

interface QRToken {
  token: string;
  expires_at: string;
}

interface PersonalQRScannerProps {
  qrToken: QRToken;
  onScan: (token: string) => void;
  loading: boolean;
}

export const PersonalQRScanner = ({ qrToken, onScan, loading }: PersonalQRScannerProps) => {
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [scanning, setScanning] = useState(false);
  const [timeLeft, setTimeLeft] = useState(15); // 15 seconds as per updated QR duration

  // Countdown timer for QR token expiration
  useEffect(() => {
    const expiryTime = new Date(qrToken.expires_at).getTime();
    const interval = setInterval(() => {
      const now = new Date().getTime();
      const difference = expiryTime - now;
      
      if (difference <= 0) {
        setTimeLeft(0);
        clearInterval(interval);
      } else {
        setTimeLeft(Math.floor(difference / 1000));
      }
    }, 1000);

    return () => clearInterval(interval);
  }, [qrToken.expires_at]);

  const requestCameraPermission = async () => {
    const { status } = await BarCodeScanner.requestPermissionsAsync();
    setHasPermission(status === 'granted');
    
    if (status !== 'granted') {
      Alert.alert('Permission required', 'Camera permission is needed to scan QR codes');
    }
  };

  const handleBarCodeScanned = ({ type, data }: { type: string; data: string }) => {
    setScanning(false);
    onScan(data);
  };

  const startScan = async () => {
    if (loading) return;
    
    if (hasPermission === null) {
      await requestCameraPermission();
    } else if (hasPermission === false) {
      Alert.alert('No camera permission', 'Please enable camera permission in settings');
      return;
    }
    
    setScanning(true);
  };

  if (scanning) {
    return (
      <View style={styles.scannerContainer}>
        <BarCodeScanner
          onBarCodeScanned={handleBarCodeScanned}
          style={StyleSheet.absoluteFillObject}
        />
        <View style={styles.scannerOverlay}>
          <Text style={styles.scannerText}>Scan the Dynamic QR Code</Text>
          <Text style={styles.timerText}>Time left: {timeLeft}s</Text>
          <TouchableOpacity
            style={styles.cancelButton}
            onPress={() => setScanning(false)}
          >
            <Text style={styles.cancelButtonText}>Cancel</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Scan QR Code</Text>
      <Text style={styles.description}>
        Scan the dynamic QR code displayed on the school monitor.
      </Text>
      
      <View style={styles.tokenContainer}>
        <Text style={styles.tokenLabel}>Token:</Text>
        <Text style={styles.tokenValue}>{qrToken.token}</Text>
      </View>
      
      <View style={styles.timerContainer}>
        <Text style={styles.timerLabel}>Expires in:</Text>
        <Text style={[styles.timerValue, timeLeft < 5 ? styles.expiringSoon : null]}>
          {timeLeft} seconds
        </Text>
      </View>
      
      <TouchableOpacity
        style={[styles.scanButton, loading && styles.disabledButton]}
        onPress={startScan}
        disabled={loading}
      >
        <Text style={styles.scanButtonText}>Scan QR Code</Text>
      </TouchableOpacity>
      
      {timeLeft === 0 && (
        <Text style={styles.expiredText}>
          QR token has expired. Please refresh to get a new token.
        </Text>
      )}
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
    marginBottom: 10,
    textAlign: 'center',
  },
  description: {
    fontSize: 14,
    color: '#666',
    marginBottom: 20,
    textAlign: 'center',
  },
  tokenContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 15,
    padding: 10,
    backgroundColor: '#f0f0f0',
    borderRadius: 5,
  },
  tokenLabel: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  tokenValue: {
    fontSize: 16,
    fontFamily: 'monospace',
  },
  timerContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  timerLabel: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  timerValue: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#007AFF',
  },
  expiringSoon: {
    color: '#ff3b30',
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
  expiredText: {
    color: '#ff3b30',
    textAlign: 'center',
    fontWeight: 'bold',
    marginTop: 10,
  },
  scannerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  scannerOverlay: {
    flex: 1,
    justifyContent: 'flex-end',
    alignItems: 'center',
    paddingBottom: 50,
  },
  scannerText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  timerText: {
    color: 'white',
    fontSize: 16,
    marginBottom: 20,
  },
  cancelButton: {
    backgroundColor: '#ff3b30',
    padding: 15,
    borderRadius: 10,
  },
  cancelButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
});