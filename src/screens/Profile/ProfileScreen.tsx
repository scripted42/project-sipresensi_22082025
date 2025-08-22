import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { ProfileInfo } from './ProfileInfo';
import { EditProfileForm } from './EditProfileForm';
import { ChangePasswordForm } from './ChangePasswordForm';
import { apiClient } from '../../services/api';

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

export const ProfileScreen = () => {
  const [user, setUser] = useState<User | null>(null);
  const [role, setRole] = useState<Role | null>(null);
  const [view, setView] = useState<'info' | 'edit' | 'changePassword'>('info');
  const [loading, setLoading] = useState(false);

  // Fetch user profile when component mounts
  useEffect(() => {
    fetchUserProfile();
  }, []);

  const fetchUserProfile = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/user');
      const userData = response.data.data.user;
      setUser(userData);
      
      // Fetch role details
      const roleResponse = await apiClient.get(`/roles/${userData.role_id}`);
      setRole(roleResponse.data.data);
      
      setLoading(false);
    } catch (error) {
      console.error('Error fetching user profile:', error);
      Alert.alert('Error', 'Failed to fetch user profile');
      setLoading(false);
    }
  };

  const handleUpdateProfile = async (profileData: any) => {
    try {
      setLoading(true);
      const response = await apiClient.put('/profile', profileData);
      
      // Update local user state
      if (user) {
        setUser({
          ...user,
          ...response.data.data,
        });
      }
      
      Alert.alert('Success', 'Profile updated successfully');
      setView('info');
      setLoading(false);
    } catch (error: any) {
      console.error('Error updating profile:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to update profile');
      setLoading(false);
    }
  };

  const handleChangePassword = async (passwordData: any) => {
    try {
      setLoading(true);
      await apiClient.put('/profile/password', passwordData);
      
      Alert.alert('Success', 'Password changed successfully');
      setView('info');
      setLoading(false);
    } catch (error: any) {
      console.error('Error changing password:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to change password');
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    Alert.alert(
      'Confirm Logout',
      'Are you sure you want to logout?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Logout',
          style: 'destructive',
          onPress: async () => {
            try {
              await apiClient.post('/auth/logout');
              // In a real app, you would clear the auth token and navigate to login screen
              Alert.alert('Success', 'You have been logged out successfully');
            } catch (error: any) {
              console.error('Error logging out:', error);
              Alert.alert('Error', error.response?.data?.message || 'Failed to logout');
            }
          },
        },
      ]
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>My Profile</Text>
      
      {view === 'info' && user && (
        <ProfileInfo
          user={user}
          role={role}
          onEditProfile={() => setView('edit')}
          onChangePassword={() => setView('changePassword')}
          onLogout={handleLogout}
          loading={loading}
        />
      )}
      
      {view === 'edit' && user && (
        <EditProfileForm
          user={user}
          onUpdateProfile={handleUpdateProfile}
          onCancel={() => setView('info')}
          loading={loading}
        />
      )}
      
      {view === 'changePassword' && (
        <ChangePasswordForm
          onChangePassword={handleChangePassword}
          onCancel={() => setView('info')}
          loading={loading}
        />
      )}
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