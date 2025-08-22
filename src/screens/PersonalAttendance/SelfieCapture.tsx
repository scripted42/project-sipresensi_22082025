import React, { useState, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { Camera, CameraType } from 'expo-camera';

interface SelfieCaptureProps {
  onCapture: (uri: string) => void;
  loading: boolean;
}

export const SelfieCapture = ({ onCapture, loading }: SelfieCaptureProps) => {
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [cameraType] = useState(CameraType.front);
  const cameraRef = useRef<Camera>(null);

  const requestCameraPermission = async () => {
    const { status } = await Camera.requestCameraPermissionsAsync();
    setHasPermission(status === 'granted');
    
    if (status !== 'granted') {
      Alert.alert('Permission required', 'Camera permission is needed to take a selfie');
    }
  };

  const takePicture = async () => {
    if (loading || !cameraRef.current) return;
    
    if (hasPermission === null) {
      await requestCameraPermission();
      return;
    } else if (hasPermission === false) {
      Alert.alert('No camera permission', 'Please enable camera permission in settings');
      return;
    }
    
    try {
      const photo = await cameraRef.current.takePictureAsync({
        quality: 0.5, // Medium quality to reduce file size
      });
      
      if (photo.uri) {
        onCapture(photo.uri);
      } else {
        throw new Error('Failed to capture photo');
      }
    } catch (error) {
      console.error('Error taking picture:', error);
      Alert.alert('Error', 'Failed to capture photo. Please try again.');
    }
  };

  if (hasPermission === false) {
    return (
      <View style={styles.container}>
        <Text style={styles.title}>Selfie Capture</Text>
        <Text style={styles.description}>
          Camera permission is required to take a selfie for attendance verification.
        </Text>
        <TouchableOpacity
          style={styles.permissionButton}
          onPress={requestCameraPermission}
        >
          <Text style={styles.permissionButtonText}>Grant Camera Permission</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Take a Selfie</Text>
      <Text style={styles.description}>
        Please take a clear selfie for attendance verification.
      </Text>
      
      <View style={styles.cameraContainer}>
        {hasPermission === null ? (
          <View style={styles.cameraPlaceholder}>
            <Text>Requesting camera permission...</Text>
            <TouchableOpacity
              style={styles.permissionButton}
              onPress={requestCameraPermission}
            >
              <Text style={styles.permissionButtonText}>Allow Camera Access</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <Camera
            style={styles.cameraPreview}
            type={cameraType}
            ref={cameraRef}
          />
        )}
      </View>
      
      <TouchableOpacity
        style={[styles.captureButton, loading && styles.disabledButton]}
        onPress={takePicture}
        disabled={loading}
      >
        <Text style={styles.captureButtonText}>
          {loading ? 'Processing...' : 'Capture Selfie'}
        </Text>
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
    marginBottom: 10,
    textAlign: 'center',
  },
  description: {
    fontSize: 14,
    color: '#666',
    marginBottom: 20,
    textAlign: 'center',
  },
  cameraContainer: {
    height: 300,
    marginBottom: 20,
    borderRadius: 10,
    overflow: 'hidden',
    backgroundColor: '#000',
  },
  cameraPlaceholder: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f0f0f0',
  },
  cameraPreview: {
    flex: 1,
  },
  captureButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  disabledButton: {
    opacity: 0.6,
  },
  captureButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
  permissionButton: {
    backgroundColor: '#007AFF',
    padding: 10,
    borderRadius: 5,
    marginTop: 10,
  },
  permissionButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
});