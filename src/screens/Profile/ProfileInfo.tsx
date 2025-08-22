import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';

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

interface ProfileInfoProps {
  user: User;
  role: Role | null;
  onEditProfile: () => void;
  onChangePassword: () => void;
  onLogout: () => void;
  loading: boolean;
}

export const ProfileInfo = ({
  user,
  role,
  onEditProfile,
  onChangePassword,
  onLogout,
  loading
}: ProfileInfoProps) => {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  return (
    <View style={styles.container}>
      <View style={styles.profileHeader}>
        <View style={styles.avatarContainer}>
          {user.photo_path ? (
            <Image source={{ uri: user.photo_path }} style={styles.avatar} />
          ) : (
            <View style={styles.avatarPlaceholder}>
              <Text style={styles.avatarPlaceholderText}>
                {user.name.charAt(0).toUpperCase()}
              </Text>
            </View>
          )}
        </View>
        
        <Text style={styles.profileName}>{user.name}</Text>
        <Text style={styles.profileRole}>{role?.name || 'Role not available'}</Text>
      </View>
      
      <View style={styles.card}>
        <Text style={styles.sectionTitle}>Personal Information</Text>
        
        <View style={styles.infoRow}>
          <Text style={styles.infoLabel}>ID:</Text>
          <Text style={styles.infoValue}>{user.nisn_nip_nik}</Text>
        </View>
        
        <View style={styles.infoRow}>
          <Text style={styles.infoLabel}>Email:</Text>
          <Text style={styles.infoValue}>{user.email || 'Not provided'}</Text>
        </View>
        
        <View style={styles.infoRow}>
          <Text style={styles.infoLabel}>Phone:</Text>
          <Text style={styles.infoValue}>{user.phone || 'Not provided'}</Text>
        </View>
        
        <View style={styles.infoRow}>
          <Text style={styles.infoLabel}>Status:</Text>
          <Text style={[styles.infoValue, user.is_active ? styles.active : styles.inactive]}>
            {user.is_active ? 'Active' : 'Inactive'}
          </Text>
        </View>
        
        <View style={styles.infoRow}>
          <Text style={styles.infoLabel}>Member Since:</Text>
          <Text style={styles.infoValue}>{formatDate(user.created_at)}</Text>
        </View>
      </View>
      
      <View style={styles.actionButtons}>
        <TouchableOpacity
          style={[styles.button, styles.editButton, loading && styles.disabledButton]}
          onPress={onEditProfile}
          disabled={loading}
        >
          <Text style={styles.editButtonText}>Edit Profile</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.passwordButton, loading && styles.disabledButton]}
          onPress={onChangePassword}
          disabled={loading}
        >
          <Text style={styles.passwordButtonText}>Change Password</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.logoutButton, loading && styles.disabledButton]}
          onPress={onLogout}
          disabled={loading}
        >
          <Text style={styles.logoutButtonText}>Logout</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  profileHeader: {
    alignItems: 'center',
    marginBottom: 30,
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
  avatarContainer: {
    marginBottom: 15,
  },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 50,
  },
  avatarPlaceholder: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: '#007AFF',
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarPlaceholderText: {
    color: 'white',
    fontSize: 40,
    fontWeight: 'bold',
  },
  profileName: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 5,
  },
  profileRole: {
    fontSize: 16,
    color: '#666',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 20,
    marginBottom: 20,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 15,
  },
  infoLabel: {
    fontSize: 16,
    color: '#666',
    flex: 1,
  },
  infoValue: {
    fontSize: 16,
    fontWeight: 'bold',
    flex: 2,
    textAlign: 'right',
  },
  active: {
    color: '#34C759',
  },
  inactive: {
    color: '#ff9500',
  },
  actionButtons: {
    flexDirection: 'column',
  },
  button: {
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    marginBottom: 15,
  },
  editButton: {
    backgroundColor: '#007AFF',
  },
  editButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  passwordButton: {
    backgroundColor: '#34C759',
  },
  passwordButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  logoutButton: {
    backgroundColor: '#ff3b30',
  },
  logoutButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});