import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity, ScrollView, Alert } from 'react-native';

// Types
interface User {
  id: number;
  nisn_nip_nik: string;
  name: string;
  email: string;
  phone: string;
  role_id: number;
  photo_path: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

interface EditProfileFormProps {
  user: User;
  onUpdateProfile: (profileData: any) => void;
  onCancel: () => void;
  loading: boolean;
}

export const EditProfileForm = ({ user, onUpdateProfile, onCancel, loading }: EditProfileFormProps) => {
  const [name, setName] = useState(user.name);
  const [email, setEmail] = useState(user.email || '');
  const [phone, setPhone] = useState(user.phone || '');

  useEffect(() => {
    setName(user.name);
    setEmail(user.email || '');
    setPhone(user.phone || '');
  }, [user]);

  const handleUpdate = () => {
    // Validate form
    if (!name.trim()) {
      Alert.alert('Validation Error', 'Please enter your name');
      return;
    }

    // Simple email validation
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      Alert.alert('Validation Error', 'Please enter a valid email address');
      return;
    }

    const profileData = {
      name: name.trim(),
      email: email.trim() || null,
      phone: phone.trim() || null,
    };

    onUpdateProfile(profileData);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>Edit Profile</Text>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>ID (Cannot be changed)</Text>
        <TextInput
          style={[styles.input, styles.disabledInput]}
          value={user.nisn_nip_nik}
          editable={false}
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Full Name</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter your full name"
          value={name}
          onChangeText={setName}
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Email</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter your email address"
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Phone</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter your phone number"
          value={phone}
          onChangeText={setPhone}
          keyboardType="phone-pad"
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
          style={[styles.button, styles.updateButton, loading && styles.disabledButton]}
          onPress={handleUpdate}
          disabled={loading}
        >
          <Text style={styles.updateButtonText}>
            {loading ? 'Updating...' : 'Update Profile'}
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
  disabledInput: {
    backgroundColor: '#f0f0f0',
    color: '#999',
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
  updateButton: {
    backgroundColor: '#007AFF',
    marginLeft: 10,
  },
  updateButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});