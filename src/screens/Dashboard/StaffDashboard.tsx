import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { PersonalAttendanceWidget } from './PersonalAttendanceWidget';
import { RecentAnnouncementsWidget } from './RecentAnnouncementsWidget';
import { ActivityFeedWidget } from './ActivityFeedWidget';
import { DatePickerSlider } from './DatePickerSlider';

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
  attendance_statistics?: {
    present_students: number;
    present_teachers: number;
    present_staff: number;
  };
  recent_announcements?: any[];
  activity_feed?: any[];
  // Add staff-specific data here if needed
}

interface StaffDashboardProps {
  dashboardData: DashboardData;
  loading: boolean;
  refreshing: boolean;
  onRefresh: () => void;
  selectedDate: string;
  onDateChange: (date: string) => void;
}

export const StaffDashboard = ({
  dashboardData,
  loading,
  refreshing,
  onRefresh,
  selectedDate,
  onDateChange
}: StaffDashboardProps) => {
  return (
    <View style={styles.container}>
      <Text style={styles.welcomeText}>Welcome, {dashboardData.user.name}!</Text>
      
      <DatePickerSlider
        selectedDate={selectedDate}
        onDateChange={onDateChange}
      />
      
      <PersonalAttendanceWidget
        attendanceStatistics={dashboardData.attendance_statistics}
        loading={loading}
      />
      
      <RecentAnnouncementsWidget
        announcements={dashboardData.recent_announcements}
        loading={loading}
      />
      
      <ActivityFeedWidget
        activities={dashboardData.activity_feed}
        loading={loading}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  welcomeText: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 20,
    textAlign: 'center',
  },
});