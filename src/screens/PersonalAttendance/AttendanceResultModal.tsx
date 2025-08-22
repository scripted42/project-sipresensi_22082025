import React from 'react';
import { View, Text, StyleSheet, Modal, TouchableOpacity } from 'react-native';

// Types
interface AttendanceResult {
  success: boolean;
  message: string;
  data?: any;
}

interface AttendanceResultModalProps {
  visible: boolean;
  result: AttendanceResult | null;
  onClose: () => void;
}

export const AttendanceResultModal = ({ visible, result, onClose }: AttendanceResultModalProps) => {
  if (!result) {
    return null;
  }

  return (
    <Modal
      animationType="slide"
      transparent={true}
      visible={visible}
      onRequestClose={onClose}
    >
      <View style={styles.centeredView}>
        <View style={[styles.modalView, result.success ? styles.successModal : styles.errorModal]}>
          <Text style={[styles.modalTitle, result.success ? styles.successText : styles.errorText]}>
            {result.success ? 'Success' : 'Error'}
          </Text>
          
          <Text style={styles.message}>{result.message}</Text>
          
          {result.data && (
            <View style={styles.dataContainer}>
              <Text style={styles.dataLabel}>Attendance ID:</Text>
              <Text style={styles.dataValue}>{result.data.id}</Text>
              
              <Text style={styles.dataLabel}>Type:</Text>
              <Text style={styles.dataValue}>{result.data.type}</Text>
              
              <Text style={styles.dataLabel}>Timestamp:</Text>
              <Text style={styles.dataValue}>{new Date(result.data.timestamp).toLocaleString()}</Text>
            </View>
          )}
          
          <TouchableOpacity
            style={[styles.button, result.success ? styles.successButton : styles.errorButton]}
            onPress={onClose}
          >
            <Text style={styles.buttonText}>Close</Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalView: {
    margin: 20,
    backgroundColor: 'white',
    borderRadius: 20,
    padding: 35,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
    width: '80%',
  },
  successModal: {
    borderColor: '#34C759',
    borderWidth: 2,
  },
  errorModal: {
    borderColor: '#ff3b30',
    borderWidth: 2,
  },
  modalTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  successText: {
    color: '#34C759',
  },
  errorText: {
    color: '#ff3b30',
  },
  message: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 20,
  },
  dataContainer: {
    width: '100%',
    marginBottom: 20,
  },
  dataLabel: {
    fontSize: 14,
    fontWeight: 'bold',
    marginTop: 10,
  },
  dataValue: {
    fontSize: 14,
    color: '#666',
  },
  button: {
    borderRadius: 10,
    padding: 10,
    elevation: 2,
    width: '100%',
  },
  successButton: {
    backgroundColor: '#34C759',
  },
  errorButton: {
    backgroundColor: '#ff3b30',
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  },
});