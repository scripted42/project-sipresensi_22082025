import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { RoleBasedDashboard } from './RoleBasedDashboard';
import { apiClient } from '../../services/api';

// Types
interface User {
  id: number;
  nisn_nip_nik: string;
  name: string;
  email: string;
  phone: string;
  role_id: number;
  photo_path: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

interface DashboardData {
  user: User;
  system_statistics?: {
    total_users: number;
    total_students: number;
    total_teachers: number;
    total_staff: number;
    total_classes: number;
  };
  attendance_statistics?: {
    present_students: number;
    present_teachers: number;
    present_staff: number;
  };
  pending_leaves?: any[];
  recent_announcements?: any[];
  activity_feed?: any[];
}

export const DashboardScreen = () => {
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [selectedDate, setSelectedDate] = useState<string>(new Date().toISOString().split('T')[0]);

  // Fetch dashboard data when component mounts
  useEffect(() => {
    fetchDashboardData();
  }, [selectedDate]);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      const response = await apiClient.get('/dashboard');
      setDashboardData(response.data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      Alert.alert('Error', 'Failed to fetch dashboard data');
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchDashboardData();
    setRefreshing(false);
  };

  const handleDateChange = (date: string) => {
    setSelectedDate(date);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Dashboard</Text>
      
      {dashboardData && (
        <RoleBasedDashboard
          dashboardData={dashboardData}
          loading={loading}
          refreshing={refreshing}
          onRefresh={handleRefresh}
          selectedDate={selectedDate}
          onDateChange={handleDateChange}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
    textAlign: 'center',
  },
});