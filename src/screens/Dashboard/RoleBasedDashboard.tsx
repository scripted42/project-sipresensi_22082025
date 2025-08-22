import React from 'react';
import { View, Text, StyleSheet, ScrollView, RefreshControl } from 'react-native';
import { AdminDashboard } from './AdminDashboard';
import { TeacherDashboard } from './TeacherDashboard';
import { StudentDashboard } from './StudentDashboard';
import { StaffDashboard } from './StaffDashboard';
import { HeadmasterDashboard } from './HeadmasterDashboard';

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

interface RoleBasedDashboardProps {
  dashboardData: DashboardData;
  loading: boolean;
  refreshing: boolean;
  onRefresh: () => void;
  selectedDate: string;
  onDateChange: (date: string) => void;
}

export const RoleBasedDashboard = ({
  dashboardData,
  loading,
  refreshing,
  onRefresh,
  selectedDate,
  onDateChange
}: RoleBasedDashboardProps) => {
  const { user } = dashboardData;

  const renderDashboardByRole = () => {
    switch (user.role_id) {
      case 1: // Student
        return (
          <StudentDashboard
            dashboardData={dashboardData}
            loading={loading}
            refreshing={refreshing}
            onRefresh={onRefresh}
            selectedDate={selectedDate}
            onDateChange={onDateChange}
          />
        );
      case 2: // Teacher
        return (
          <TeacherDashboard
            dashboardData={dashboardData}
            loading={loading}
            refreshing={refreshing}
            onRefresh={onRefresh}
            selectedDate={selectedDate}
            onDateChange={onDateChange}
          />
        );
      case 3: // Staff
        return (
          <StaffDashboard
            dashboardData={dashboardData}
            loading={loading}
            refreshing={refreshing}
            onRefresh={onRefresh}
            selectedDate={selectedDate}
            onDateChange={onDateChange}
          />
        );
      case 4: // Headmaster
        return (
          <HeadmasterDashboard
            dashboardData={dashboardData}
            loading={loading}
            refreshing={refreshing}
            onRefresh={onRefresh}
            selectedDate={selectedDate}
            onDateChange={onDateChange}
          />
        );
      case 5: // Admin
        return (
          <AdminDashboard
            dashboardData={dashboardData}
            loading={loading}
            refreshing={refreshing}
            onRefresh={onRefresh}
            selectedDate={selectedDate}
            onDateChange={onDateChange}
          />
        );
      default:
        return (
          <View style={styles.defaultContainer}>
            <Text style={styles.defaultText}>Welcome, {user.name}!</Text>
            <Text style={styles.defaultText}>Your role is not recognized.</Text>
          </View>
        );
    }
  };

  return (
    <ScrollView
      style={styles.container}
      refreshControl={
        <RefreshControl refreshing={refreshing || loading} onRefresh={onRefresh} />
      }
    >
      {renderDashboardByRole()}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  defaultContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  defaultText: {
    fontSize: 18,
    color: '#666',
    marginBottom: 10,
    textAlign: 'center',
  },
});