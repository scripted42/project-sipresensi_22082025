import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert, TextInput } from 'react-native';

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

interface LeaveDetailProps {
  leave: Leave;
  onApproveLeave: (leaveId: number, comment: string) => void;
  onRejectLeave: (leaveId: number, comment: string) => void;
  onEditLeave: (leave: Leave) => void;
  onDeleteLeave: (leaveId: number) => void;
  onCancel: () => void;
  loading: boolean;
  getUserById: (userId: number) => User | undefined;
}

export const LeaveDetail = ({
  leave,
  onApproveLeave,
  onRejectLeave,
  onEditLeave,
  onDeleteLeave,
  onCancel,
  loading,
  getUserById
}: LeaveDetailProps) => {
  const [approvalComment, setApprovalComment] = useState('');

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

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleString();
  };

  const handleApprove = () => {
    onApproveLeave(leave.id, approvalComment);
  };

  const handleReject = () => {
    Alert.alert(
      'Confirm Rejection',
      'Are you sure you want to reject this leave request?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Reject',
          style: 'destructive',
          onPress: () => onRejectLeave(leave.id, approvalComment),
        },
      ]
    );
  };

  const handleDelete = () => {
    Alert.alert(
      'Confirm Delete',
      'Are you sure you want to delete this leave request?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => onDeleteLeave(leave.id),
        },
      ]
    );
  };

  const user = getUserById(leave.user_id);
  const approver = leave.approved_by ? getUserById(leave.approved_by) : null;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Leave Request Details</Text>
      
      <View style={styles.card}>
        <View style={styles.header}>
          <Text style={styles.leaveType}>{getLeaveTypeLabel(leave.leave_type)}</Text>
          <Text style={[styles.status, { color: getStatusColor(leave.status) }]}>
            {leave.status}
          </Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Requested By:</Text>
          <Text style={styles.value}>{user ? user.name : `User ID: ${leave.user_id}`}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Start Date:</Text>
          <Text style={styles.value}>{formatDate(leave.start_date)}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>End Date:</Text>
          <Text style={styles.value}>{formatDate(leave.end_date)}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Reason:</Text>
          <Text style={styles.value}>{leave.reason}</Text>
        </View>
        
        <View style={styles.detailRow}>
          <Text style={styles.label}>Submitted:</Text>
          <Text style={styles.value}>{formatDate(leave.created_at)}</Text>
        </View>
        
        {leave.status !== 'menunggu' && (
          <>
            <View style={styles.detailRow}>
              <Text style={styles.label}>Approved/Rejected By:</Text>
              <Text style={styles.value}>
                {approver ? approver.name : `User ID: ${leave.approved_by}`}
              </Text>
            </View>
            
            <View style={styles.detailRow}>
              <Text style={styles.label}>Approved/Rejected At:</Text>
              <Text style={styles.value}>{formatDate(leave.approved_at || '')}</Text>
            </View>
            
            {leave.approval_comment && (
              <View style={styles.detailRow}>
                <Text style={styles.label}>Comment:</Text>
                <Text style={styles.value}>{leave.approval_comment}</Text>
              </View>
            )}
          </>
        )}
      </View>
      
      {leave.status === 'menunggu' && (
        <View style={styles.approvalSection}>
          <Text style={styles.sectionTitle}>Approval</Text>
          
          <TextInput
            style={styles.commentInput}
            placeholder="Add a comment (optional)..."
            value={approvalComment}
            onChangeText={setApprovalComment}
            multiline
            numberOfLines={3}
          />
          
          <View style={styles.approvalButtons}>
            <TouchableOpacity
              style={[styles.button, styles.rejectButton, loading && styles.disabledButton]}
              onPress={handleReject}
              disabled={loading}
            >
              <Text style={styles.rejectButtonText}>Reject</Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[styles.button, styles.approveButton, loading && styles.disabledButton]}
              onPress={handleApprove}
              disabled={loading}
            >
              <Text style={styles.approveButtonText}>Approve</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}
      
      <View style={styles.actionButtons}>
        <TouchableOpacity
          style={[styles.button, styles.editButton]}
          onPress={() => onEditLeave(leave)}
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
    </View>
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
  leaveType: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  status: {
    fontSize: 16,
    fontWeight: 'bold',
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
  approvalSection: {
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
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  commentInput: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
    marginBottom: 20,
    textAlignVertical: 'top',
    height: 80,
  },
  approvalButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
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
  approveButton: {
    backgroundColor: '#34C759',
  },
  approveButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  rejectButton: {
    backgroundColor: '#ff3b30',
  },
  rejectButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});