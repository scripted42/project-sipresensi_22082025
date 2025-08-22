import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator } from 'react-native';

// Types
interface AttendanceStatistics {
  present_students: number;
  present_teachers: number;
  present_staff: number;
}

interface PersonalAttendanceWidgetProps {
  attendanceStatistics?: AttendanceStatistics;
  loading: boolean;
}

export const PersonalAttendanceWidget = ({ attendanceStatistics, loading }: PersonalAttendanceWidgetProps) => {
  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Your Attendance Status</Text>
      
      <View style={styles.statusContainer}>
        <View style={styles.statusCard}>
          <Text style={styles.statusText}>Today's Status</Text>
          <Text style={styles.statusValue}>Present</Text>
          <Text style={styles.statusTime}>Checked in at 08:15 AM</Text>
        </View>
      </View>
      
      <View style={styles.statsContainer}>
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{attendanceStatistics?.present_students || 0}</Text>
          <Text style={styles.statLabel}>Days Present</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>2</Text>
          <Text style={styles.statLabel}>Days Late</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>1</Text>
          <Text style={styles.statLabel}>Days Absent</Text>
        </View>
      </View>
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
  statusContainer: {
    marginBottom: 20,
  },
  statusCard: {
    backgroundColor: '#34C759',
    borderRadius: 10,
    padding: 20,
    alignItems: 'center',
  },
  statusText: {
    fontSize: 16,
    color: 'white',
    marginBottom: 5,
  },
  statusValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 5,
  },
  statusTime: {
    fontSize: 14,
    color: 'white',
  },
  statsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  statCard: {
    width: '30%',
    backgroundColor: '#f0f0f0',
    borderRadius: 10,
    padding: 15,
    marginBottom: 15,
    alignItems: 'center',
  },
  statValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#007AFF',
  },
  statLabel: {
    fontSize: 12,
    color: '#666',
    textAlign: 'center',
  },
});