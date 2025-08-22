import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

interface LocationVerificationProps {
  onVerify: () => void;
  loading: boolean;
  locationVerified: boolean;
}

export const LocationVerification = ({ onVerify, loading, locationVerified }: LocationVerificationProps) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Location Verification</Text>
      <Text style={styles.description}>
        Your location needs to be verified to ensure you are at the school premises.
      </Text>
      
      <View style={styles.statusContainer}>
        <Text style={styles.statusLabel}>Status:</Text>
        <Text style={[styles.statusValue, locationVerified ? styles.verified : styles.notVerified]}>
          {locationVerified ? 'Verified' : 'Not Verified'}
        </Text>
      </View>
      
      <TouchableOpacity
        style={[styles.verifyButton, loading && styles.disabledButton]}
        onPress={onVerify}
        disabled={loading}
      >
        <Text style={styles.verifyButtonText}>
          {locationVerified ? 'Re-verify Location' : 'Verify Location'}
        </Text>
      </TouchableOpacity>
      
      {locationVerified && (
        <Text style={styles.successText}>
          ✓ Location verified successfully. You can now proceed with attendance.
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
  statusContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  statusLabel: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  statusValue: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  verified: {
    color: '#34C759',
  },
  notVerified: {
    color: '#ff9500',
  },
  verifyButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    marginBottom: 10,
  },
  disabledButton: {
    opacity: 0.6,
  },
  verifyButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
  successText: {
    color: '#34C759',
    textAlign: 'center',
    fontWeight: 'bold',
  },
});