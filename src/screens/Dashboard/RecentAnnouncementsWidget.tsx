import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList } from 'react-native';

// Types
interface Announcement {
  id: number;
  title: string;
  content: string;
  author_id: number;
  is_published: boolean;
  published_at: string | null;
  created_at: string;
  // Add other properties as needed
}

interface RecentAnnouncementsWidgetProps {
  announcements?: Announcement[];
  loading: boolean;
}

export const RecentAnnouncementsWidget = ({ announcements, loading }: RecentAnnouncementsWidgetProps) => {
  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  const renderAnnouncementItem = ({ item }: { item: Announcement }) => (
    <View style={styles.announcementItem}>
      <Text style={styles.announcementTitle} numberOfLines={1}>
        {item.title}
      </Text>
      <Text style={styles.announcementContent} numberOfLines={2}>
        {item.content}
      </Text>
      <Text style={styles.announcementDate}>
        {item.published_at 
          ? new Date(item.published_at).toLocaleDateString()
          : new Date(item.created_at).toLocaleDateString()}
      </Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Recent Announcements</Text>
      
      {announcements && announcements.length > 0 ? (
        <FlatList
          data={announcements}
          renderItem={renderAnnouncementItem}
          keyExtractor={(item) => item.id.toString()}
          scrollEnabled={false}
        />
      ) : (
        <Text style={styles.noDataText}>No recent announcements</Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
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
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  announcementItem: {
    backgroundColor: '#f9f9f9',
    borderRadius: 8,
    padding: 15,
    marginBottom: 10,
  },
  announcementTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 5,
  },
  announcementContent: {
    fontSize: 14,
    color: '#666',
    marginBottom: 5,
  },
  announcementDate: {
    fontSize: 12,
    color: '#999',
  },
  noDataText: {
    textAlign: 'center',
    color: '#666',
    fontStyle: 'italic',
  },
});