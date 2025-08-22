import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { StatisticsWidget } from './StatisticsWidget';
import { PendingLeavesWidget } from './PendingLeavesWidget';
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

interface HeadmasterDashboardProps {
  dashboardData: DashboardData;
  loading: boolean;
  refreshing: boolean;
  onRefresh: () => void;
  selectedDate: string;
  onDateChange: (date: string) => void;
}

export const HeadmasterDashboard = ({
  dashboardData,
  loading,
  refreshing,
  onRefresh,
  selectedDate,
  onDateChange
}: HeadmasterDashboardProps) => {
  return (
    <View style={styles.container}>
      <Text style={styles.welcomeText}>Welcome, {dashboardData.user.name}!</Text>
      
      <DatePickerSlider
        selectedDate={selectedDate}
        onDateChange={onDateChange}
      />
      
      <StatisticsWidget
        systemStatistics={dashboardData.system_statistics}
        attendanceStatistics={dashboardData.attendance_statistics}
        loading={loading}
      />
      
      <PendingLeavesWidget
        pendingLeaves={dashboardData.pending_leaves}
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