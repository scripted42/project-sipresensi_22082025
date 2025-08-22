import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { LeaveList } from './LeaveList';
import { LeaveForm } from './LeaveForm';
import { LeaveDetail } from './LeaveDetail';
import { apiClient } from '../../services/api';

// Types
interface Leave {
  id: number;
  user_id: number;
  leave_type: 'izin' | 'cuti' | 'dinas_luar' | 'sakit';
  start_date: string;
  end_date: string;
  reason: string;
  attachment_path: string | null;
  status: 'menunggu' | 'disetujui' | 'ditolak';
  approved_by: number | null;
  approval_comment: string | null;
  approved_at: string | null;
  created_at: string;
  updated_at: string;
}

interface User {
  id: number;
  name: string;
}

export const LeaveManagementScreen = () => {
  const [leaves, setLeaves] = useState<Leave[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [selectedLeave, setSelectedLeave] = useState<Leave | null>(null);
  const [view, setView] = useState<'list' | 'form' | 'detail'>('list');
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);

  // Fetch leaves and users when component mounts
  useEffect(() => {
    fetchLeaves();
    fetchUsers();
  }, []);

  const fetchLeaves = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/leaves');
      setLeaves(response.data.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching leaves:', error);
      Alert.alert('Error', 'Failed to fetch leaves');
      setLoading(false);
    }
  };

  const fetchUsers = async () => {
    try {
      const response = await apiClient.get('/users');
      setUsers(response.data.data.data);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchLeaves();
    setRefreshing(false);
  };

  const handleCreateLeave = () => {
    setSelectedLeave(null);
    setView('form');
  };

  const handleEditLeave = (leave: Leave) => {
    setSelectedLeave(leave);
    setView('form');
  };

  const handleViewLeave = (leave: Leave) => {
    setSelectedLeave(leave);
    setView('detail');
  };

  const handleSaveLeave = async (leaveData: any) => {
    try {
      setLoading(true);
      
      if (selectedLeave) {
        // Update existing leave
        await apiClient.put(`/leaves/${selectedLeave.id}`, leaveData);
        Alert.alert('Success', 'Leave updated successfully');
      } else {
        // Create new leave
        await apiClient.post('/leaves', leaveData);
        Alert.alert('Success', 'Leave created successfully');
      }
      
      // Refresh the list
      await fetchLeaves();
      setView('list');
      setLoading(false);
    } catch (error: any) {
      console.error('Error saving leave:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to save leave');
      setLoading(false);
    }
  };

  const handleDeleteLeave = async (leaveId: number) => {
    Alert.alert(
      'Confirm Delete',
      'Are you sure you want to delete this leave request?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: async () => {
            try {
              setLoading(true);
              await apiClient.delete(`/leaves/${leaveId}`);
              Alert.alert('Success', 'Leave deleted successfully');
              
              // Refresh the list
              await fetchLeaves();
              setLoading(false);
            } catch (error: any) {
              console.error('Error deleting leave:', error);
              Alert.alert('Error', error.response?.data?.message || 'Failed to delete leave');
              setLoading(false);
            }
          },
        },
      ]
    );
  };

  const handleApproveLeave = async (leaveId: number, comment: string) => {
    try {
      setLoading(true);
      await apiClient.put(`/leaves/${leaveId}`, {
        status: 'disetujui',
        approval_comment: comment,
      });
      
      Alert.alert('Success', 'Leave approved successfully');
      
      // Refresh the list
      await fetchLeaves();
      
      // If we're viewing the detail, go back to list
      if (view === 'detail') {
        setView('list');
      }
      
      setLoading(false);
    } catch (error: any) {
      console.error('Error approving leave:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to approve leave');
      setLoading(false);
    }
  };

  const handleRejectLeave = async (leaveId: number, comment: string) => {
    try {
      setLoading(true);
      await apiClient.put(`/leaves/${leaveId}`, {
        status: 'ditolak',
        approval_comment: comment,
      });
      
      Alert.alert('Success', 'Leave rejected successfully');
      
      // Refresh the list
      await fetchLeaves();
      
      // If we're viewing the detail, go back to list
      if (view === 'detail') {
        setView('list');
      }
      
      setLoading(false);
    } catch (error: any) {
      console.error('Error rejecting leave:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to reject leave');
      setLoading(false);
    }
  };

  const getUserById = (userId: number): User | undefined => {
    return users.find(user => user.id === userId);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Leave Management</Text>
      
      {view === 'list' && (
        <LeaveList
          leaves={leaves}
          loading={loading}
          refreshing={refreshing}
          onRefresh={handleRefresh}
          onCreateLeave={handleCreateLeave}
          onEditLeave={handleEditLeave}
          onViewLeave={handleViewLeave}
          onDeleteLeave={handleDeleteLeave}
          getUserById={getUserById}
        />
      )}
      
      {view === 'form' && (
        <LeaveForm
          leave={selectedLeave}
          onSaveLeave={handleSaveLeave}
          onCancel={() => setView('list')}
          loading={loading}
        />
      )}
      
      {view === 'detail' && selectedLeave && (
        <LeaveDetail
          leave={selectedLeave}
          onApproveLeave={handleApproveLeave}
          onRejectLeave={handleRejectLeave}
          onEditLeave={handleEditLeave}
          onDeleteLeave={handleDeleteLeave}
          onCancel={() => setView('list')}
          loading={loading}
          getUserById={getUserById}
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