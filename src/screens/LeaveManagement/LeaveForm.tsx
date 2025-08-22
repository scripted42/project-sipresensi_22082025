import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity, ScrollView, Alert } from 'react-native';
import DateTimePicker from '@react-native-community/datetimepicker';

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

interface LeaveFormProps {
  leave: Leave | null;
  onSaveLeave: (leaveData: any) => void;
  onCancel: () => void;
  loading: boolean;
}

export const LeaveForm = ({ leave, onSaveLeave, onCancel, loading }: LeaveFormProps) => {
  const [leaveType, setLeaveType] = useState<'izin' | 'cuti' | 'dinas_luar' | 'sakit'>(
    leave?.leave_type || 'izin'
  );
  const [startDate, setStartDate] = useState<Date>(
    leave?.start_date ? new Date(leave.start_date) : new Date()
  );
  const [endDate, setEndDate] = useState<Date>(
    leave?.end_date ? new Date(leave.end_date) : new Date()
  );
  const [reason, setReason] = useState(leave?.reason || '');
  const [showStartDatePicker, setShowStartDatePicker] = useState(false);
  const [showEndDatePicker, setShowEndDatePicker] = useState(false);

  useEffect(() => {
    if (leave) {
      setLeaveType(leave.leave_type);
      setStartDate(new Date(leave.start_date));
      setEndDate(new Date(leave.end_date));
      setReason(leave.reason);
    }
  }, [leave]);

  const handleSave = () => {
    // Validate form
    if (!reason.trim()) {
      Alert.alert('Validation Error', 'Please enter a reason for your leave');
      return;
    }

    if (startDate > endDate) {
      Alert.alert('Validation Error', 'End date must be after start date');
      return;
    }

    const leaveData = {
      leave_type: leaveType,
      start_date: startDate.toISOString().split('T')[0],
      end_date: endDate.toISOString().split('T')[0],
      reason: reason.trim(),
    };

    onSaveLeave(leaveData);
  };

  const onStartDateChange = (event: any, selectedDate?: Date) => {
    setShowStartDatePicker(false);
    if (selectedDate) {
      setStartDate(selectedDate);
    }
  };

  const onEndDateChange = (event: any, selectedDate?: Date) => {
    setShowEndDatePicker(false);
    if (selectedDate) {
      setEndDate(selectedDate);
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>{leave ? 'Edit Leave Request' : 'New Leave Request'}</Text>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Leave Type</Text>
        <View style={styles.typeContainer}>
          {(['izin', 'cuti', 'dinas_luar', 'sakit'] as const).map((type) => (
            <TouchableOpacity
              key={type}
              style={[
                styles.typeButton,
                leaveType === type && styles.selectedTypeButton,
              ]}
              onPress={() => setLeaveType(type)}
            >
              <Text
                style={[
                  styles.typeButtonText,
                  leaveType === type && styles.selectedTypeButtonText,
                ]}
              >
                {type.charAt(0).toUpperCase() + type.slice(1)}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Start Date</Text>
        <TouchableOpacity
          style={styles.dateButton}
          onPress={() => setShowStartDatePicker(true)}
        >
          <Text style={styles.dateButtonText}>{startDate.toDateString()}</Text>
        </TouchableOpacity>
        
        {showStartDatePicker && (
          <DateTimePicker
            value={startDate}
            mode="date"
            display="default"
            onChange={onStartDateChange}
          />
        )}
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>End Date</Text>
        <TouchableOpacity
          style={styles.dateButton}
          onPress={() => setShowEndDatePicker(true)}
        >
          <Text style={styles.dateButtonText}>{endDate.toDateString()}</Text>
        </TouchableOpacity>
        
        {showEndDatePicker && (
          <DateTimePicker
            value={endDate}
            mode="date"
            display="default"
            onChange={onEndDateChange}
          />
        )}
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Reason</Text>
        <TextInput
          style={styles.textArea}
          multiline
          numberOfLines={4}
          placeholder="Enter reason for leave..."
          value={reason}
          onChangeText={setReason}
        />
      </View>
      
      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[styles.button, styles.cancelButton]}
          onPress={onCancel}
          disabled={loading}
        >
          <Text style={styles.cancelButtonText}>Cancel</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, styles.saveButton, loading && styles.disabledButton]}
          onPress={handleSave}
          disabled={loading}
        >
          <Text style={styles.saveButtonText}>
            {loading ? 'Saving...' : (leave ? 'Update' : 'Submit')}
          </Text>
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
  formGroup: {
    marginBottom: 20,
  },
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  typeContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  typeButton: {
    backgroundColor: '#e0e0e0',
    paddingVertical: 10,
    paddingHorizontal: 15,
    borderRadius: 20,
    marginRight: 10,
    marginBottom: 10,
  },
  selectedTypeButton: {
    backgroundColor: '#007AFF',
  },
  typeButtonText: {
    color: '#333',
  },
  selectedTypeButtonText: {
    color: 'white',
  },
  dateButton: {
    backgroundColor: 'white',
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
  },
  dateButtonText: {
    fontSize: 16,
    color: '#333',
  },
  textArea: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
    textAlignVertical: 'top',
    height: 100,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 20,
  },
  button: {
    flex: 1,
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  cancelButton: {
    backgroundColor: '#f0f0f0',
    marginRight: 10,
  },
  cancelButtonText: {
    color: '#333',
    fontWeight: 'bold',
  },
  saveButton: {
    backgroundColor: '#007AFF',
    marginLeft: 10,
  },
  saveButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  disabledButton: {
    opacity: 0.6,
  },
});