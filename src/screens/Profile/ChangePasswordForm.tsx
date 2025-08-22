import React, { useState } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity, ScrollView, Alert } from 'react-native';

interface ChangePasswordFormProps {
  onChangePassword: (passwordData: any) => void;
  onCancel: () => void;
  loading: boolean;
}

export const ChangePasswordForm = ({ onChangePassword, onCancel, loading }: ChangePasswordFormProps) => {
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const handleChangePassword = () => {
    // Validate form
    if (!currentPassword) {
      Alert.alert('Validation Error', 'Please enter your current password');
      return;
    }

    if (!newPassword) {
      Alert.alert('Validation Error', 'Please enter a new password');
      return;
    }

    if (newPassword.length < 6) {
      Alert.alert('Validation Error', 'Password must be at least 6 characters long');
      return;
    }

    if (newPassword !== confirmPassword) {
      Alert.alert('Validation Error', 'New password and confirmation do not match');
      return;
    }

    const passwordData = {
      current_password: currentPassword,
      new_password: newPassword,
      new_password_confirmation: confirmPassword,
    };

    onChangePassword(passwordData);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>Change Password</Text>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Current Password</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter your current password"
          value={currentPassword}
          onChangeText={setCurrentPassword}
          secureTextEntry={true}
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>New Password</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter your new password"
          value={newPassword}
          onChangeText={setNewPassword}
          secureTextEntry={true}
        />
        <Text style={styles.hint}>Password must be at least 6 characters long</Text>
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Confirm New Password</Text>
        <TextInput
          style={styles.input}
          placeholder="Confirm your new password"
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry={true}
        />
      </View>
      
      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[styles.button, styles.cancelButton]}
          onPress={onCancel}
          disabled={loading}
        >
          <Text style={styles.cancelButtonText}>Cancel</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.changeButton, loading && styles.disabledButton]}
          onPress={handleChangePassword}
          disabled={loading}
        >
          <Text style={styles.changeButtonText}>
            {loading ? 'Changing...' : 'Change Password'}
          </Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 20,
    textAlign: 'center',
  },
  formGroup: {
    marginBottom: 20,
  },
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
  },
  hint: {
    fontSize: 12,
    color: '#666',
    marginTop: 5,
    fontStyle: 'italic',
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 20,
  },
  button: {
    flex: 1,
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  cancelButton: {
    backgroundColor: '#f0f0f0',
    marginRight: 10,
  },
  cancelButtonText: {
    color: '#333',
    fontWeight: 'bold',
  },
  changeButton: {
    backgroundColor: '#34C759',
    marginLeft: 10,
  },
  changeButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});