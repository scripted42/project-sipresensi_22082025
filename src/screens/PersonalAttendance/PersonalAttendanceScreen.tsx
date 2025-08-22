import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert, Platform } from 'react-native';
import * as Location from 'expo-location';
import { PersonalQRScanner } from './PersonalQRScanner';
import { AttendanceHistory } from './AttendanceHistory';
import { LocationVerification } from './LocationVerification';
import { SelfieCapture } from './SelfieCapture';
import { AttendanceResultModal } from './AttendanceResultModal';
import { apiClient } from '../../services/api';

// Types
interface AttendanceRecord {
  id: number;
  type: 'checkin' | 'checkout';
  timestamp: string;
  status: string;
}

interface QRToken {
  token: string;
  expires_at: string;
}

interface AttendanceResult {
  success: boolean;
  message: string;
  data?: any;
}

export const PersonalAttendanceScreen = () => {
  const [currentStep, setCurrentStep] = useState<'location' | 'qr' | 'selfie' | 'history'>('location');
  const [locationVerified, setLocationVerified] = useState(false);
  const [userLocation, setUserLocation] = useState<Location.LocationObject | null>(null);
  const [qrToken, setQrToken] = useState<QRToken | null>(null);
  const [selfieUri, setSelfieUri] = useState<string | null>(null);
  const [attendanceHistory, setAttendanceHistory] = useState<AttendanceRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<AttendanceResult | null>(null);
  const [showResultModal, setShowResultModal] = useState(false);

  // Fetch attendance history when component mounts
  useEffect(() => {
    fetchAttendanceHistory();
  }, []);

  const fetchAttendanceHistory = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/attendance/history');
      setAttendanceHistory(response.data.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching attendance history:', error);
      Alert.alert('Error', 'Failed to fetch attendance history');
      setLoading(false);
    }
  };

  const verifyLocation = async () => {
    try {
      setLoading(true);
      
      // Request location permission
      const { status } = await Location.requestForegroundPermissionsAsync();
      if (status !== 'granted') {
        Alert.alert('Permission denied', 'Location permission is required for attendance');
        setLoading(false);
        return;
      }

      // Get current location
      const location = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.High,
      });
      
      setUserLocation(location);
      
      // In a real implementation, we would verify the location against school coordinates
      // For now, we'll just simulate verification
      setLocationVerified(true);
      setCurrentStep('qr');
      setLoading(false);
    } catch (error) {
      console.error('Error getting location:', error);
      Alert.alert('Error', 'Failed to get your location');
      setLoading(false);
    }
  };

  const fetchQRToken = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/qrcode/dynamic');
      setQrToken(response.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching QR token:', error);
      Alert.alert('Error', 'Failed to fetch QR token');
      setLoading(false);
    }
  };

  const handleQRScan = async (token: string) => {
    if (!userLocation) {
      Alert.alert('Error', 'Location not available');
      return;
    }

    try {
      setLoading(true);
      
      // Verify the scanned token matches the fetched token
      if (qrToken && token !== qrToken.token) {
        throw new Error('Invalid QR token');
      }
      
      setCurrentStep('selfie');
      setLoading(false);
    } catch (error: any) {
      console.error('Error scanning QR:', error);
      setResult({
        success: false,
        message: error.message || 'Failed to process QR scan',
      });
      setShowResultModal(true);
      setLoading(false);
    }
  };

  const handleSelfieCapture = (uri: string) => {
    setSelfieUri(uri);
    submitAttendance(uri);
  };

  const submitAttendance = async (photoUri: string | null) => {
    if (!userLocation || !qrToken) {
      Alert.alert('Error', 'Required data missing');
      return;
    }

    try {
      setLoading(true);
      
      // Convert photo to base64 if available
      let photoBase64 = null;
      if (photoUri) {
        // In a real implementation, we would convert the image to base64
        // For now, we'll use a placeholder
        photoBase64 = 'base64_image_data_placeholder';
      }
      
      // Determine if this is checkin or checkout
      // In a real implementation, we would check the user's last attendance record
      const attendanceType = 'checkin'; // Placeholder
      
      const response = await apiClient.post('/qrcode/verify', {
        user_id: 1, // This would come from user context
        type: attendanceType,
        qr_token: qrToken.token,
        latitude: userLocation.coords.latitude,
        longitude: userLocation.coords.longitude,
        accuracy: userLocation.coords.accuracy,
        photo: photoBase64,
      });

      setResult({
        success: true,
        message: response.data.message,
        data: response.data.data,
      });
      setShowResultModal(true);
      
      // Refresh attendance history
      fetchAttendanceHistory();
      
      // Reset to first step
      setCurrentStep('location');
      setLocationVerified(false);
      setQrToken(null);
      setSelfieUri(null);
      setLoading(false);
    } catch (error: any) {
      console.error('Error submitting attendance:', error);
      setResult({
        success: false,
        message: error.response?.data?.message || 'Failed to submit attendance',
      });
      setShowResultModal(true);
      setLoading(false);
    }
  };

  const handleCheckIn = async () => {
    if (!locationVerified) {
      await verifyLocation();
    } else {
      await fetchQRToken();
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Personal Attendance</Text>
      
      {currentStep === 'location' && (
        <LocationVerification
          onVerify={handleCheckIn}
          loading={loading}
          locationVerified={locationVerified}
        />
      )}
      
      {currentStep === 'qr' && qrToken && (
        <PersonalQRScanner
          qrToken={qrToken}
          onScan={handleQRScan}
          loading={loading}
        />
      )}
      
      {currentStep === 'selfie' && (
        <SelfieCapture
          onCapture={handleSelfieCapture}
          loading={loading}
        />
      )}
      
      {currentStep === 'history' && (
        <AttendanceHistory
          history={attendanceHistory}
          loading={loading}
          onRefresh={fetchAttendanceHistory}
        />
      )}
      
      <AttendanceResultModal
        visible={showResultModal}
        result={result}
        onClose={() => setShowResultModal(false)}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
    textAlign: 'center',
  },
});