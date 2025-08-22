import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, FlatList, RefreshControl } from 'react-native';

// Types
interface AttendanceRecord {
  id: number;
  type: 'checkin' | 'checkout';
  timestamp: string;
  status: string;
}

interface AttendanceHistoryProps {
  history: AttendanceRecord[];
  loading: boolean;
  onRefresh: () => void;
}

export const AttendanceHistory = ({ history, loading, onRefresh }: AttendanceHistoryProps) => {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleString();
  };

  const getTypeColor = (type: string) => {
    return type === 'checkin' ? '#34C759' : '#ff9500';
  };

  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case 'hadir':
        return '#34C759';
      case 'terlambat':
        return '#ff9500';
      case 'izin':
      case 'sakit':
        return '#007AFF';
      default:
        return '#ff3b30';
    }
  };

  const renderAttendanceItem = ({ item }: { item: AttendanceRecord }) => (
    <View style={styles.historyItem}>
      <View style={styles.historyItemHeader}>
        <Text style={[styles.historyItemType, { color: getTypeColor(item.type) }]}>
          {item.type.toUpperCase()}
        </Text>
        <Text style={[styles.historyItemStatus, { color: getStatusColor(item.status) }]}>
          {item.status}
        </Text>
      </View>
      <Text style={styles.historyItemTimestamp}>{formatDate(item.timestamp)}</Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Attendance History</Text>
        <TouchableOpacity
          style={styles.refreshButton}
          onPress={onRefresh}
          disabled={loading}
        >
          <Text style={styles.refreshButtonText}>Refresh</Text>
        </TouchableOpacity>
      </View>
      
      {history.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>No attendance records found</Text>
        </View>
      ) : (
        <FlatList
          data={history}
          renderItem={renderAttendanceItem}
          keyExtractor={(item) => item.id.toString()}
          refreshControl={
            <RefreshControl refreshing={loading} onRefresh={onRefresh} />
          }
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  refreshButton: {
    padding: 5,
  },
  refreshButtonText: {
    color: '#007AFF',
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
  },
  historyItem: {
    padding: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  historyItemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 5,
  },
  historyItemType: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  historyItemStatus: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  historyItemTimestamp: {
    fontSize: 14,
    color: '#666',
  },
});