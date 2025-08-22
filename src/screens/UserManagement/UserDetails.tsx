import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert } from 'react-native';

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

interface UserDetailsProps {
  user: User;
  role: Role | undefined;
  onEditUser: (user: User) => void;
  onDeleteUser: (userId: number) => void;
  onToggleUserStatus: (userId: number, isActive: boolean) => void;
  onCancel: () => void;
  loading: boolean;
}

export const UserDetails = ({
  user,
  role,
  onEditUser,
  onDeleteUser,
  onToggleUserStatus,
  onCancel,
  loading
}: UserDetailsProps) => {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleString();
  };

  const handleDelete = () => {
    Alert.alert(
      'Confirm Delete',
      'Are you sure you want to delete this user?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => onDeleteUser(user.id),
        },
      ]
    );
  };

  const handleToggleStatus = () => {
    Alert.alert(
      'Confirm Status Change',
      `Are you sure you want to ${user.is_active ? 'deactivate' : 'activate'} this user?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: user.is_active ? 'Deactivate' : 'Activate',
          style: user.is_active ? 'destructive' : 'default',
          onPress: () => onToggleUserStatus(user.id, !user.is_active),
        },
      ]
    );
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>User Details</Text>
      
      <View style={styles.card}>
        <View style={styles.header}>
          <Text style={styles.userName}>{user.name}</Text>
          <Text style={[styles.userStatus, user.is_active ? styles.active : styles.inactive]}>
            {user.is_active ? 'Active' : 'Inactive'}
          </Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>ID:</Text>
          <Text style={styles.value}>{user.nisn_nip_nik}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Role:</Text>
          <Text style={styles.value}>{role ? role.name : `Role ID: ${user.role_id}`}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Email:</Text>
          <Text style={styles.value}>{user.email || 'Not provided'}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Phone:</Text>
          <Text style={styles.value}>{user.phone || 'Not provided'}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Joined:</Text>
          <Text style={styles.value}>{formatDate(user.created_at)}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Last Updated:</Text>
          <Text style={styles.value}>{formatDate(user.updated_at)}</Text>
        </View>
      </View>
      
      <View style={styles.actionButtons}>
        <TouchableOpacity
          style={[styles.button, styles.editButton]}
          onPress={() => onEditUser(user)}
        >
          <Text style={styles.editButtonText}>Edit User</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[
            styles.button,
            user.is_active ? styles.deactivateButton : styles.activateButton,
            loading && styles.disabledButton
          ]}
          onPress={handleToggleStatus}
          disabled={loading}
        >
          <Text style={styles.statusText}>
            {loading ? 'Updating...' : (user.is_active ? 'Deactivate User' : 'Activate User')}
          </Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.deleteButton]}
          onPress={handleDelete}
        >
          <Text style={styles.deleteButtonText}>Delete User</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.cancelButton]}
          onPress={onCancel}
        >
          <Text style={styles.cancelButtonText}>Back</Text>
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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  userName: {
    fontSize: 18,
    fontWeight: 'bold',
    flex: 1,
  },
  userStatus: {
    fontSize: 12,
    fontWeight: 'bold',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 10,
  },
  active: {
    backgroundColor: '#34C759',
    color: 'white',
  },
  inactive: {
    backgroundColor: '#ff9500',
    color: 'white',
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 15,
  },
  label: {
    fontSize: 14,
    color: '#666',
    flex: 1,
  },
  value: {
    fontSize: 14,
    fontWeight: 'bold',
    flex: 2,
    textAlign: 'right',
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
  activateButton: {
    backgroundColor: '#34C759',
  },
  deactivateButton: {
    backgroundColor: '#ff9500',
  },
  statusText: {
    color: 'white',
    fontWeight: 'bold',
  },
  deleteButton: {
    backgroundColor: '#ff3b30',
  },
  deleteButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  cancelButton: {
    backgroundColor: '#f0f0f0',
  },
  cancelButtonText: {
    color: '#333',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});