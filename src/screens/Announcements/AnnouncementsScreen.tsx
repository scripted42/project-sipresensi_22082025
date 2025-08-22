import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { AnnouncementList } from './AnnouncementList';
import { AnnouncementForm } from './AnnouncementForm';
import { AnnouncementDetail } from './AnnouncementDetail';
import { apiClient } from '../../services/api';

// Types
interface Announcement {
  id: number;
  title: string;
  content: string;
  author_id: number;
  is_published: boolean;
  published_at: string | null;
  created_at: string;
  updated_at: string;
}

interface User {
  id: number;
  name: string;
}

export const AnnouncementsScreen = () => {
  const [announcements, setAnnouncements] = useState<Announcement[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [selectedAnnouncement, setSelectedAnnouncement] = useState<Announcement | null>(null);
  const [view, setView] = useState<'list' | 'form' | 'detail'>('list');
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);

  // Fetch announcements and users when component mounts
  useEffect(() => {
    fetchAnnouncements();
    fetchUsers();
  }, []);

  const fetchAnnouncements = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/announcements');
      setAnnouncements(response.data.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching announcements:', error);
      Alert.alert('Error', 'Failed to fetch announcements');
      setLoading(false);
    }
  };

  const fetchUsers = async () => {
    try {
      // For simplicity, we're fetching all users, but in a real app you might want to fetch only authors
      const response = await apiClient.get('/users');
      setUsers(response.data.data.data);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchAnnouncements();
    setRefreshing(false);
  };

  const handleCreateAnnouncement = () => {
    setSelectedAnnouncement(null);
    setView('form');
  };

  const handleEditAnnouncement = (announcement: Announcement) => {
    setSelectedAnnouncement(announcement);
    setView('form');
  };

  const handleViewAnnouncement = (announcement: Announcement) => {
    setSelectedAnnouncement(announcement);
    setView('detail');
  };

  const handleSaveAnnouncement = async (announcementData: any) => {
    try {
      setLoading(true);
      
      if (selectedAnnouncement) {
        // Update existing announcement
        await apiClient.put(`/announcements/${selectedAnnouncement.id}`, announcementData);
        Alert.alert('Success', 'Announcement updated successfully');
      } else {
        // Create new announcement
        await apiClient.post('/announcements', announcementData);
        Alert.alert('Success', 'Announcement created successfully');
      }
      
      // Refresh the list
      await fetchAnnouncements();
      setView('list');
      setLoading(false);
    } catch (error: any) {
      console.error('Error saving announcement:', error);
      Alert.alert('Error', error.response?.data?.message || 'Failed to save announcement');
      setLoading(false);
    }
  };

  const handleDeleteAnnouncement = async (announcementId: number) => {
    Alert.alert(
      'Confirm Delete',
      'Are you sure you want to delete this announcement?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: async () => {
            try {
              setLoading(true);
              await apiClient.delete(`/announcements/${announcementId}`);
              Alert.alert('Success', 'Announcement deleted successfully');
              
              // Refresh the list
              await fetchAnnouncements();
              setLoading(false);
            } catch (error: any) {
              console.error('Error deleting announcement:', error);
              Alert.alert('Error', error.response?.data?.message || 'Failed to delete announcement');
              setLoading(false);
            }
          },
        },
      ]
    );
  };

  const getUserById = (userId: number): User | undefined => {
    return users.find(user => user.id === userId);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Announcements</Text>
      
      {view === 'list' && (
        <AnnouncementList
          announcements={announcements}
          loading={loading}
          refreshing={refreshing}
          onRefresh={handleRefresh}
          onCreateAnnouncement={handleCreateAnnouncement}
          onEditAnnouncement={handleEditAnnouncement}
          onViewAnnouncement={handleViewAnnouncement}
          onDeleteAnnouncement={handleDeleteAnnouncement}
          getUserById={getUserById}
        />
      )}
      
      {view === 'form' && (
        <AnnouncementForm
          announcement={selectedAnnouncement}
          onSaveAnnouncement={handleSaveAnnouncement}
          onCancel={() => setView('list')}
          loading={loading}
        />
      )}
      
      {view === 'detail' && selectedAnnouncement && (
        <AnnouncementDetail
          announcement={selectedAnnouncement}
          onEditAnnouncement={handleEditAnnouncement}
          onDeleteAnnouncement={handleDeleteAnnouncement}
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