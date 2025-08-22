import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator } from 'react-native';

// Types
interface SystemStatistics {
  total_users: number;
  total_students: number;
  total_teachers: number;
  total_staff: number;
  total_classes: number;
}

interface AttendanceStatistics {
  present_students: number;
  present_teachers: number;
  present_staff: number;
}

interface StatisticsWidgetProps {
  systemStatistics?: SystemStatistics;
  attendanceStatistics?: AttendanceStatistics;
  loading: boolean;
}

export const StatisticsWidget = ({
  systemStatistics,
  attendanceStatistics,
  loading
}: StatisticsWidgetProps) => {
  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>System Statistics</Text>
      
      <View style={styles.statsContainer}>
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{systemStatistics?.total_users || 0}</Text>
          <Text style={styles.statLabel}>Total Users</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{systemStatistics?.total_students || 0}</Text>
          <Text style={styles.statLabel}>Students</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{systemStatistics?.total_teachers || 0}</Text>
          <Text style={styles.statLabel}>Teachers</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{systemStatistics?.total_staff || 0}</Text>
          <Text style={styles.statLabel}>Staff</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{systemStatistics?.total_classes || 0}</Text>
          <Text style={styles.statLabel}>Classes</Text>
        </View>
      </View>
      
      <Text style={styles.title}>Today's Attendance</Text>
      
      <View style={styles.statsContainer}>
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{attendanceStatistics?.present_students || 0}</Text>
          <Text style={styles.statLabel}>Students Present</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{attendanceStatistics?.present_teachers || 0}</Text>
          <Text style={styles.statLabel}>Teachers Present</Text>
        </View>
        
        <View style={styles.statCard}>
          <Text style={styles.statValue}>{attendanceStatistics?.present_staff || 0}</Text>
          <Text style={styles.statLabel}>Staff Present</Text>
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