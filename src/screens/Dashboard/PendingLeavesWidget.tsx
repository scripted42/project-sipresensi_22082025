import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList } from 'react-native';

// Types
interface Leave {
  id: number;
  user_id: number;
  leave_type: string;
  start_date: string;
  end_date: string;
  reason: string;
  status: string;
  created_at: string;
  // Add other properties as needed
}

interface PendingLeavesWidgetProps {
  pendingLeaves?: Leave[];
  loading: boolean;
}

export const PendingLeavesWidget = ({ pendingLeaves, loading }: PendingLeavesWidgetProps) => {
  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  const renderLeaveItem = ({ item }: { item: Leave }) => (
    <View style={styles.leaveItem}>
      <View style={styles.leaveHeader}>
        <Text style={styles.leaveType}>{item.leave_type}</Text>
        <Text style={styles.leaveDate}>
          {new Date(item.start_date).toLocaleDateString()} - {new Date(item.end_date).toLocaleDateString()}
        </Text>
      </View>
      <Text style={styles.leaveReason} numberOfLines={2}>
        {item.reason}
      </Text>
      <Text style={styles.leaveStatus}>Status: {item.status}</Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Pending Leave Requests</Text>
      
      {pendingLeaves && pendingLeaves.length > 0 ? (
        <FlatList
          data={pendingLeaves}
          renderItem={renderLeaveItem}
          keyExtractor={(item) => item.id.toString()}
          scrollEnabled={false}
        />
      ) : (
        <Text style={styles.noDataText}>No pending leave requests</Text>
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
  leaveItem: {
    backgroundColor: '#f9f9f9',
    borderRadius: 8,
    padding: 15,
    marginBottom: 10,
  },
  leaveHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 5,
  },
  leaveType: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#007AFF',
  },
  leaveDate: {
    fontSize: 12,
    color: '#666',
  },
  leaveReason: {
    fontSize: 14,
    color: '#333',
    marginBottom: 5,
  },
  leaveStatus: {
    fontSize: 12,
    color: '#ff9500',
    fontWeight: 'bold',
  },
  noDataText: {
    textAlign: 'center',
    color: '#666',
    fontStyle: 'italic',
  },
});