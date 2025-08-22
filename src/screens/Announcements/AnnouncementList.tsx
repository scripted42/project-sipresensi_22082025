import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, FlatList, RefreshControl } from 'react-native';

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

interface AnnouncementListProps {
  announcements: Announcement[];
  loading: boolean;
  refreshing: boolean;
  onRefresh: () => void;
  onCreateAnnouncement: () => void;
  onEditAnnouncement: (announcement: Announcement) => void;
  onViewAnnouncement: (announcement: Announcement) => void;
  onDeleteAnnouncement: (announcementId: number) => void;
  getUserById: (userId: number) => User | undefined;
}

export const AnnouncementList = ({
  announcements,
  loading,
  refreshing,
  onRefresh,
  onCreateAnnouncement,
  onEditAnnouncement,
  onViewAnnouncement,
  onDeleteAnnouncement,
  getUserById
}: AnnouncementListProps) => {
  const formatDate = (dateString: string | null) => {
    if (!dateString) return 'Not published';
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const renderAnnouncementItem = ({ item }: { item: Announcement }) => {
    const author = getUserById(item.author_id);
    
    return (
      <View style={styles.announcementItem}>
        <View style={styles.announcementItemHeader}>
          <Text style={styles.announcementItemTitle} numberOfLines={1}>
            {item.title}
          </Text>
          <Text style={[styles.announcementItemStatus, item.is_published ? styles.published : styles.draft]}>
            {item.is_published ? 'Published' : 'Draft'}
          </Text>
        </View>
        
        <Text style={styles.announcementItemAuthor}>
          {author ? author.name : `Author ID: ${item.author_id}`}
        </Text>
        
        <Text style={styles.announcementItemDate}>
          {item.is_published 
            ? `Published: ${formatDate(item.published_at)}` 
            : `Created: ${formatDate(item.created_at)}`}
        </Text>
        
        <Text numberOfLines={2} style={styles.announcementItemContent}>
          {item.content}
        </Text>
        
        <View style={styles.announcementItemActions}>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => onViewAnnouncement(item)}
          >
            <Text style={styles.actionButtonText}>View</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, styles.editButton]}
            onPress={() => onEditAnnouncement(item)}
          >
            <Text style={styles.actionButtonText}>Edit</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, styles.deleteButton]}
            onPress={() => onDeleteAnnouncement(item.id)}
          >
            <Text style={styles.actionButtonText}>Delete</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>School Announcements</Text>
        <TouchableOpacity
          style={styles.createButton}
          onPress={onCreateAnnouncement}
        >
          <Text style={styles.createButtonText}>+ New Announcement</Text>
        </TouchableOpacity>
      </View>
      
      {announcements.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>No announcements found</Text>
          <TouchableOpacity
            style={styles.createButton}
            onPress={onCreateAnnouncement}
          >
            <Text style={styles.createButtonText}>Create Your First Announcement</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={announcements}
          renderItem={renderAnnouncementItem}
          keyExtractor={(item) => item.id.toString()}
          refreshControl={
            <RefreshControl refreshing={refreshing || loading} onRefresh={onRefresh} />
          }
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  createButton: {
    backgroundColor: '#007AFF',
    paddingVertical: 8,
    paddingHorizontal: 15,
    borderRadius: 20,
  },
  createButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  emptyText: {
    fontSize: 16,
    color: '#666',
    marginBottom: 20,
  },
  announcementItem: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 15,
    marginBottom: 15,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  announcementItemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  announcementItemTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    flex: 1,
  },
  announcementItemStatus: {
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
  announcementItemAuthor: {
    fontSize: 14,
    color: '#666',
    marginBottom: 5,
  },
  announcementItemDate: {
    fontSize: 12,
    color: '#999',
    marginBottom: 10,
  },
  announcementItemContent: {
    fontSize: 14,
    color: '#333',
    marginBottom: 15,
  },
  announcementItemActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  actionButton: {
    backgroundColor: '#007AFF',
    paddingVertical: 8,
    paddingHorizontal: 15,
    borderRadius: 5,
  },
  editButton: {
    backgroundColor: '#34C759',
  },
  deleteButton: {
    backgroundColor: '#ff3b30',
  },
  actionButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 12,
  },
});