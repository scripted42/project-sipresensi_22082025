import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity, ScrollView, Alert, Picker } from 'react-native';

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

interface Role {
  id: number;
  name: string;
  description: string;
}

interface UserFormProps {
  user: User | null;
  roles: Role[];
  onSaveUser: (userData: any) => void;
  onCancel: () => void;
  loading: boolean;
}

export const UserForm = ({ user, roles, onSaveUser, onCancel, loading }: UserFormProps) => {
  const [nisnNipNik, setNisnNipNik] = useState(user?.nisn_nip_nik || '');
  const [name, setName] = useState(user?.name || '');
  const [email, setEmail] = useState(user?.email || '');
  const [phone, setPhone] = useState(user?.phone || '');
  const [roleId, setRoleId] = useState(user?.role_id?.toString() || '');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isActive, setIsActive] = useState(user?.is_active ?? true);

  useEffect(() => {
    if (user) {
      setNisnNipNik(user.nisn_nip_nik);
      setName(user.name);
      setEmail(user.email || '');
      setPhone(user.phone || '');
      setRoleId(user.role_id.toString());
      setIsActive(user.is_active);
    }
  }, [user]);

  const handleSave = () => {
    // Validate form
    if (!nisnNipNik.trim()) {
      Alert.alert('Validation Error', 'Please enter ID (NISN/NIP/NIK)');
      return;
    }

    if (!name.trim()) {
      Alert.alert('Validation Error', 'Please enter full name');
      return;
    }

    if (!roleId) {
      Alert.alert('Validation Error', 'Please select a role');
      return;
    }

    // Email validation if provided
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      Alert.alert('Validation Error', 'Please enter a valid email address');
      return;
    }

    // Password validation for new users
    if (!user && !password) {
      Alert.alert('Validation Error', 'Please enter a password for new users');
      return;
    }

    if (password && password.length < 6) {
      Alert.alert('Validation Error', 'Password must be at least 6 characters long');
      return;
    }

    if (password && password !== confirmPassword) {
      Alert.alert('Validation Error', 'Password and confirmation do not match');
      return;
    }

    const userData = {
      nisn_nip_nik: nisnNipNik.trim(),
      name: name.trim(),
      email: email.trim() || null,
      phone: phone.trim() || null,
      role_id: parseInt(roleId),
      is_active: isActive,
    };

    // Only include password for new users or when explicitly changing it
    if (!user && password) {
      (userData as any).password = password;
    }

    onSaveUser(userData);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>{user ? 'Edit User' : 'New User'}</Text>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>ID (NISN/NIP/NIK)</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter ID (NISN/NIP/NIK)"
          value={nisnNipNik}
          onChangeText={setNisnNipNik}
          editable={!user} // Cannot change ID for existing users
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Full Name</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter full name"
          value={name}
          onChangeText={setName}
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Email</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter email address"
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
          placeholder="Enter phone number"
          value={phone}
          onChangeText={setPhone}
          keyboardType="phone-pad"
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Role</Text>
        <Picker
          selectedValue={roleId}
          style={styles.picker}
          onValueChange={(itemValue) => setRoleId(itemValue)}
        >
          <Picker.Item label="Select a role" value="" />
          {roles.map((role) => (
            <Picker.Item key={role.id} label={role.name} value={role.id.toString()} />
          ))}
        </Picker>
      </View>
      
      {!user && ( // Only show password fields for new users
        <>
          <View style={styles.formGroup}>
            <Text style={styles.label}>Password</Text>
            <TextInput
              style={styles.input}
              placeholder="Enter password"
              value={password}
              onChangeText={setPassword}
              secureTextEntry={true}
            />
            <Text style={styles.hint}>Password must be at least 6 characters long</Text>
          </View>
          
          <View style={styles.formGroup}>
            <Text style={styles.label}>Confirm Password</Text>
            <TextInput
              style={styles.input}
              placeholder="Confirm password"
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              secureTextEntry={true}
            />
          </View>
        </>
      )}
      
      <View style={styles.formGroup}>
        <View style={styles.switchContainer}>
          <Text style={styles.label}>Active Status</Text>
          <Switch
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={isActive ? '#f5dd4b' : '#f4f3f4'}
            onValueChange={setIsActive}
            value={isActive}
          />
        </View>
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
          style={[styles.button, styles.saveButton, loading && styles.disabledButton]}
          onPress={handleSave}
          disabled={loading}
        >
          <Text style={styles.saveButtonText}>
            {loading ? 'Saving...' : (user ? 'Update' : 'Create')}
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
  picker: {
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
  switchContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
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
  saveButton: {
    backgroundColor: '#007AFF',
    marginLeft: 10,
  },
  saveButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});