import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert } from 'react-native';

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

interface AnnouncementDetailProps {
  announcement: Announcement;
  onEditAnnouncement: (announcement: Announcement) => void;
  onDeleteAnnouncement: (announcementId: number) => void;
  onCancel: () => void;
  loading: boolean;
  getUserById: (userId: number) => User | undefined;
}

export const AnnouncementDetail = ({
  announcement,
  onEditAnnouncement,
  onDeleteAnnouncement,
  onCancel,
  loading,
  getUserById
}: AnnouncementDetailProps) => {
  const formatDate = (dateString: string | null) => {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleString();
  };

  const handleDelete = () => {
    Alert.alert(
      'Confirm Delete',
      'Are you sure you want to delete this announcement?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => onDeleteAnnouncement(announcement.id),
        },
      ]
    );
  };

  const author = getUserById(announcement.author_id);

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>Announcement Details</Text>
      
      <View style={styles.card}>
        <View style={styles.header}>
          <Text style={styles.announcementTitle}>{announcement.title}</Text>
          <Text style={[styles.status, announcement.is_published ? styles.published : styles.draft]}>
            {announcement.is_published ? 'Published' : 'Draft'}
          </Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Author:</Text>
          <Text style={styles.value}>{author ? author.name : `User ID: ${announcement.author_id}`}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Created:</Text>
          <Text style={styles.value}>{formatDate(announcement.created_at)}</Text>
        </View>
        
        {announcement.is_published && (
          <View style={styles.detailRow}>
            <Text style={styles.label}>Published:</Text>
            <Text style={styles.value}>{formatDate(announcement.published_at)}</Text>
          </View>
        )}
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Last Updated:</Text>
          <Text style={styles.value}>{formatDate(announcement.updated_at)}</Text>
        </View>
        
        <View style={styles.contentContainer}>
          <Text style={styles.contentLabel}>Content:</Text>
          <Text style={styles.content}>{announcement.content}</Text>
        </View>
      </View>
      
      <View style={styles.actionButtons}>
        <TouchableOpacity
          style={[styles.button, styles.editButton]}
          onPress={() => onEditAnnouncement(announcement)}
        >
          <Text style={styles.editButtonText}>Edit</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.deleteButton]}
          onPress={handleDelete}
        >
          <Text style={styles.deleteButtonText}>Delete</Text>
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
  announcementTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    flex: 1,
  },
  status: {
    fontSize: 12,
    fontWeight: 'bold',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 10,
  },
  published: {
    backgroundColor: '#34C759',
    color: 'white',
  },
  draft: {
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
  contentContainer: {
    marginTop: 20,
  },
  contentLabel: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
  },
  content: {
    fontSize: 16,
    color: '#333',
    lineHeight: 22,
  },
  actionButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  button: {
    flex: 1,
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    marginHorizontal: 5,
  },
  editButton: {
    backgroundColor: '#34C759',
  },
  editButtonText: {
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
});