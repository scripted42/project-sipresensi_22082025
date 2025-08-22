import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, FlatList, RefreshControl } from 'react-native';

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

interface LeaveListProps {
  leaves: Leave[];
  loading: boolean;
  refreshing: boolean;
  onRefresh: () => void;
  onCreateLeave: () => void;
  onEditLeave: (leave: Leave) => void;
  onViewLeave: (leave: Leave) => void;
  onDeleteLeave: (leaveId: number) => void;
  getUserById: (userId: number) => User | undefined;
}

export const LeaveList = ({
  leaves,
  loading,
  refreshing,
  onRefresh,
  onCreateLeave,
  onEditLeave,
  onViewLeave,
  onDeleteLeave,
  getUserById
}: LeaveListProps) => {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'disetujui':
        return '#34C759';
      case 'ditolak':
        return '#ff3b30';
      default:
        return '#ff9500';
    }
  };

  const getLeaveTypeLabel = (type: string) => {
    switch (type) {
      case 'izin':
        return 'Izin';
      case 'cuti':
        return 'Cuti';
      case 'dinas_luar':
        return 'Dinas Luar';
      case 'sakit':
        return 'Sakit';
      default:
        return type;
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const renderLeaveItem = ({ item }: { item: Leave }) => {
    const user = getUserById(item.user_id);
    
    return (
      <View style={styles.leaveItem}>
        <View style={styles.leaveItemHeader}>
          <Text style={styles.leaveItemType}>{getLeaveTypeLabel(item.leave_type)}</Text>
          <Text style={[styles.leaveItemStatus, { color: getStatusColor(item.status) }]}>
            {item.status}
          </Text>
        </View>
        
        <Text style={styles.leaveItemUser}>{user ? user.name : `User ID: ${item.user_id}`}</Text>
        
        <View style={styles.leaveItemDates}>
          <Text style={styles.leaveItemDateLabel}>From:</Text>
          <Text style={styles.leaveItemDateValue}>{formatDate(item.start_date)}</Text>
          <Text style={styles.leaveItemDateLabel}>To:</Text>
          <Text style={styles.leaveItemDateValue}>{formatDate(item.end_date)}</Text>
        </View>
        
        <Text numberOfLines={2} style={styles.leaveItemReason}>
          {item.reason}
        </Text>
        
        <View style={styles.leaveItemActions}>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => onViewLeave(item)}
          >
            <Text style={styles.actionButtonText}>View</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, styles.editButton]}
            onPress={() => onEditLeave(item)}
          >
            <Text style={styles.actionButtonText}>Edit</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, styles.deleteButton]}
            onPress={() => onDeleteLeave(item.id)}
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
        <Text style={styles.title}>Leave Requests</Text>
        <TouchableOpacity
          style={styles.createButton}
          onPress={onCreateLeave}
        >
          <Text style={styles.createButtonText}>+ New Leave</Text>
        </TouchableOpacity>
      </View>
      
      {leaves.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>No leave requests found</Text>
          <TouchableOpacity
            style={styles.createButton}
            onPress={onCreateLeave}
          >
            <Text style={styles.createButtonText}>Create Your First Leave</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={leaves}
          renderItem={renderLeaveItem}
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
  leaveItem: {
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
  leaveItemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  leaveItemType: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  leaveItemStatus: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  leaveItemUser: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
  },
  leaveItemDates: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  leaveItemDateLabel: {
    fontSize: 12,
    color: '#999',
  },
  leaveItemDateValue: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  leaveItemReason: {
    fontSize: 14,
    color: '#333',
    marginBottom: 15,
  },
  leaveItemActions: {
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