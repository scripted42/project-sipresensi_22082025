import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { apiClient, setAuthToken } from '../services/api';

interface LoginScreenProps {
  onLoginSuccess: () => void;
}

export const LoginScreen = ({ onLoginSuccess }: LoginScreenProps) => {
  const [nisnNipNik, setNisnNipNik] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    // Basic validation
    if (!nisnNipNik.trim()) {
      Alert.alert('Validation Error', 'Please enter your ID (NISN/NIP/NIK)');
      return;
    }

    if (!password) {
      Alert.alert('Validation Error', 'Please enter your password');
      return;
    }

    try {
      setLoading(true);
      console.log('Attempting login with:', {
        nisn_nip_nik: nisnNipNik.trim(),
        password: '****', // Don't log the actual password
      });
      
      const response = await apiClient.post('/auth/login', {
        nisn_nip_nik: nisnNipNik.trim(),
        password,
      });

      console.log('Login response:', response.data);
      
      // Save the token
      await setAuthToken(response.data.data.token);
      
      // Notify parent component of successful login
      onLoginSuccess();
      
      setLoading(false);
    } catch (error: any) {
      setLoading(false);
      console.error('Login error:', error);
      
      if (error.response) {
        console.log('Error response:', error.response.data);
        Alert.alert('Login Failed', error.response.data.message || 'Invalid credentials');
      } else {
        console.log('Network error:', error.message);
        Alert.alert('Connection Error', `Unable to connect to the server. Please check your network connection. Error: ${error.message}`);
      }
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>SiPresensi</Text>
      <Text style={styles.subtitle}>Sistem Presensi Digital Sekolah</Text>
      
      <View style={styles.formContainer}>
        <View style={styles.inputGroup}>
          <Text style={styles.label}>ID (NISN/NIP/NIK)</Text>
          <TextInput
            style={styles.input}
            placeholder="Enter your ID"
            value={nisnNipNik}
            onChangeText={setNisnNipNik}
            keyboardType="numeric"
            autoCapitalize="none"
            editable={!loading}
          />
        </View>
        
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Password</Text>
          <TextInput
            style={styles.input}
            placeholder="Enter your password"
            value={password}
            onChangeText={setPassword}
            secureTextEntry={true}
            editable={!loading}
          />
        </View>
        
        <TouchableOpacity
          style={[styles.loginButton, loading && styles.disabledButton]}
          onPress={handleLogin}
          disabled={loading}
        >
          <Text style={styles.loginButtonText}>
            {loading ? 'Logging in...' : 'Login'}
          </Text>
        </TouchableOpacity>
      </View>
      
      <View style={styles.footer}>
        <Text style={styles.footerText}>© 2025 SiPresensi - All rights reserved</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#007AFF',
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
    color: '#666',
    marginBottom: 40,
  },
  formContainer: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  inputGroup: {
    marginBottom: 20,
  },
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
  },
  loginButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    marginTop: 10,
  },
  disabledButton: {
    opacity: 0.6,
  },
  loginButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
  footer: {
    marginTop: 40,
    alignItems: 'center',
  },
  footerText: {
    fontSize: 12,
    color: '#999',
  },
});