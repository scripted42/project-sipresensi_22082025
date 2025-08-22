import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { apiClient } from '../../services/api';
import { ExpoCameraScanner as ScanQRSection } from './ExpoCameraScanner';
import { ManualInputSection } from './ManualInputSection';
import { ClassSelector } from './ClassSelector';
import { AttendanceResultModal } from './AttendanceResultModal';

// Types
interface Student {
  id: number;
  nisn_nip_nik: string;
  name: string;
}

interface Class {
  id: number;
  name: string;
  homeroom_teacher_id: number;
}

interface AttendanceResult {
  success: boolean;
  student?: Student;
  message: string;
}

export const StudentAttendanceScreen = () => {
  const navigation = useNavigation();
  const [selectedClass, setSelectedClass] = useState<Class | null>(null);
  const [classes, setClasses] = useState<Class[]>([]);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<AttendanceResult | null>(null);
  const [showResultModal, setShowResultModal] = useState(false);

  // Fetch classes when component mounts
  useEffect(() => {
    fetchClasses();
  }, []);

  const fetchClasses = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/classes');
      setClasses(response.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching classes:', error);
      Alert.alert('Error', 'Failed to fetch classes');
      setLoading(false);
    }
  };

  const handleQRScan = async (qrCode: string) => {
    if (!selectedClass) {
      Alert.alert('Error', 'Please select a class first');
      return;
    }

    try {
      setLoading(true);
      // In a real implementation, we would get location here
      const latitude = -6.123456; // Dummy value
      const longitude = 106.876543; // Dummy value
      
      const response = await apiClient.post('/student-attendance/scan-qr', {
        qr_code: qrCode,
        class_id: selectedClass.id,
        latitude,
        longitude,
      });

      setResult(response.data);
      setShowResultModal(true);
      setLoading(false);
    } catch (error: any) {
      console.error('Error scanning QR:', error);
      setResult({
        success: false,
        message: error.response?.data?.message || 'Failed to process QR scan',
      });
      setShowResultModal(true);
      setLoading(false);
    }
  };

  const handleManualInput = async (nisnNipNik: string) => {
    if (!selectedClass) {
      Alert.alert('Error', 'Please select a class first');
      return;
    }

    try {
      setLoading(true);
      // In a real implementation, we would get location here
      const latitude = -6.123456; // Dummy value
      const longitude = 106.876543; // Dummy value
      
      const response = await apiClient.post('/student-attendance/scan-qr', {
        nisn_nip_nik: nisnNipNik,
        class_id: selectedClass.id,
        latitude,
        longitude,
      });

      setResult(response.data);
      setShowResultModal(true);
      setLoading(false);
    } catch (error: any) {
      console.error('Error with manual input:', error);
      setResult({
        success: false,
        message: error.response?.data?.message || 'Failed to process manual input',
      });
      setShowResultModal(true);
      setLoading(false);
    }
  };

  const handleBulkAttendance = async () => {
    if (!selectedClass) {
      Alert.alert('Error', 'Please select a class first');
      return;
    }

    Alert.alert(
      'Confirm Bulk Attendance',
      `Are you sure you want to mark all students in ${selectedClass.name} as present?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Confirm',
          onPress: async () => {
            try {
              setLoading(true);
              const response = await apiClient.post('/student-attendance/bulk', {
                class_id: selectedClass.id,
              });

              Alert.alert(
                'Success',
                `Bulk attendance processed: ${response.data.data.newly_attended} students marked as present`
              );
              setLoading(false);
            } catch (error: any) {
              console.error('Error with bulk attendance:', error);
              Alert.alert(
                'Error',
                error.response?.data?.message || 'Failed to process bulk attendance'
              );
              setLoading(false);
            }
          },
        },
      ]
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Student Attendance</Text>
      
      <ClassSelector
        classes={classes}
        selectedClass={selectedClass}
        onSelectClass={setSelectedClass}
        loading={loading}
      />
      
      {selectedClass && (
        <>
          <ScanQRSection
            onQRScan={handleQRScan}
            loading={loading}
          />
          
          <ManualInputSection
            onManualInput={handleManualInput}
            loading={loading}
          />
          
          <View style={styles.bulkButtonContainer}>
            <Text
              style={[styles.bulkButton, loading && styles.disabledButton]}
              onPress={() => !loading && handleBulkAttendance()}
            >
              Bulk Attendance for {selectedClass.name}
            </Text>
          </View>
        </>
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
  bulkButtonContainer: {
    marginTop: 20,
    alignItems: 'center',
  },
  bulkButton: {
    backgroundColor: '#007AFF',
    color: 'white',
    padding: 15,
    borderRadius: 10,
    textAlign: 'center',
    fontWeight: 'bold',
    width: '100%',
  },
  disabledButton: {
    opacity: 0.5,
  },
});