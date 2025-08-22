import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { UserList } from './UserList';
import { UserForm } from './UserForm';
import { UserDetails } from './UserDetails';
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

export const UserManagementScreen = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [roles, setRoles] = useState<Role[]>([]);
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [view, setView] = useState<'list' | 'form' | 'details'>('list');
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);

  // Fetch users and roles when component mounts
  useEffect(() => {
    fetchUsers();
    fetchRoles();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/users');
      setUsers(response.data.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching users:', error);
      Alert.alert('Error', 'Failed to fetch users');
      setLoading(false);
    }
  };

  const fetchRoles = async () => {
    try {
      const response = await apiClient.get('/roles');
      setRoles(response.data.data);
    } catch (error) {
      console.error('Error fetching roles:', error);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchUsers();
    setRefreshing(false);
  };

  const handleCreateUser = () => {
    setSelectedUser(null);
    setView('form');
  };

  const handleEditUser = (user: User) => {
    setSelectedUser(user);
    setView('form');
  };

  const handleViewUser = (user: User) => {
    setSelectedUser(user);
    setView('details');
  };

  const handleSaveUser = async (userData: any) => {
    try {
      setLoading(true);
      
      if (selectedUser) {
        // Update existing user
        await apiClient.put(`/users/${selectedUser.id}`, userData);
        Alert.alert('Success', 'User updated successfully');
      } else {
        // Create new user
        await apiClient.post('/users', userData);
        Alert.alert('Success', 'User created successfully');
      }
      
      // Refresh the list
      await fetchUsers();
      setView('list');
      setLoading(false);
    } catch (error: any) {
      console.error('Error saving user:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to save user');
      setLoading(false);
    }
  };

  const handleDeleteUser = async (userId: number) => {
    Alert.alert(
      'Confirm Delete',
      'Are you sure you want to delete this user?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: async () => {
            try {
              setLoading(true);
              await apiClient.delete(`/users/${userId}`);
              Alert.alert('Success', 'User deleted successfully');
              
              // Refresh the list
              await fetchUsers();
              setLoading(false);
            } catch (error: any) {
              console.error('Error deleting user:', error);
              Alert.alert('Error', error.response?.data?.message || 'Failed to delete user');
              setLoading(false);
            }
          },
        },
      ]
    );
  };

  const handleToggleUserStatus = async (userId: number, isActive: boolean) => {
    try {
      setLoading(true);
      await apiClient.put(`/users/${userId}`, { is_active: isActive });
      
      Alert.alert('Success', `User ${isActive ? 'activated' : 'deactivated'} successfully`);
      
      // Refresh the list
      await fetchUsers();
      setLoading(false);
    } catch (error: any) {
      console.error('Error toggling user status:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to update user status');
      setLoading(false);
    }
  };

  const getRoleById = (roleId: number): Role | undefined => {
    return roles.find(role => role.id === roleId);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>User Management</Text>
      
      {view === 'list' && (
        <UserList
          users={users}
          roles={roles}
          loading={loading}
          refreshing={refreshing}
          onRefresh={handleRefresh}
          onCreateUser={handleCreateUser}
          onEditUser={handleEditUser}
          onViewUser={handleViewUser}
          onDeleteUser={handleDeleteUser}
          onToggleUserStatus={handleToggleUserStatus}
          getRoleById={getRoleById}
        />
      )}
      
      {view === 'form' && (
        <UserForm
          user={selectedUser}
          roles={roles}
          onSaveUser={handleSaveUser}
          onCancel={() => setView('list')}
          loading={loading}
        />
      )}
      
      {view === 'details' && selectedUser && (
        <UserDetails
          user={selectedUser}
          role={getRoleById(selectedUser.role_id)}
          onEditUser={handleEditUser}
          onDeleteUser={handleDeleteUser}
          onToggleUserStatus={handleToggleUserStatus}
          onCancel={() => setView('list')}
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