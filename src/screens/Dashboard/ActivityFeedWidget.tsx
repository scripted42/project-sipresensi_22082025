import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList } from 'react-native';

// Types
interface Activity {
  id: number;
  user_id: number;
  action_type: string;
  description: string;
  timestamp: string;
  // Add other properties as needed
}

interface ActivityFeedWidgetProps {
  activities?: Activity[];
  loading: boolean;
}

export const ActivityFeedWidget = ({ activities, loading }: ActivityFeedWidgetProps) => {
  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  const renderActivityItem = ({ item }: { item: Activity }) => (
    <View style={styles.activityItem}>
      <Text style={styles.activityDescription}>{item.description}</Text>
      <Text style={styles.activityTime}>
        {new Date(item.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
      </Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Recent Activity</Text>
      
      {activities && activities.length > 0 ? (
        <FlatList
          data={activities}
          renderItem={renderActivityItem}
          keyExtractor={(item) => item.id.toString()}
          scrollEnabled={false}
        />
      ) : (
        <Text style={styles.noDataText}>No recent activity</Text>
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
  activityItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: '#f9f9f9',
    borderRadius: 8,
    padding: 15,
    marginBottom: 10,
  },
  activityDescription: {
    fontSize: 14,
    color: '#333',
    flex: 1,
  },
  activityTime: {
    fontSize: 12,
    color: '#999',
    marginLeft: 10,
  },
  noDataText: {
    textAlign: 'center',
    color: '#666',
    fontStyle: 'italic',
  },
});