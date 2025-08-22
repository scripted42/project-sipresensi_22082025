import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

interface DatePickerSliderProps {
  selectedDate: string;
  onDateChange: (date: string) => void;
}

export const DatePickerSlider = ({ selectedDate, onDateChange }: DatePickerSliderProps) => {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
  };

  const navigateDate = (direction: 'prev' | 'next') => {
    const currentDate = new Date(selectedDate);
    const newDate = new Date(currentDate);
    
    if (direction === 'prev') {
      newDate.setDate(currentDate.getDate() - 1);
    } else {
      newDate.setDate(currentDate.getDate() + 1);
    }
    
    // Limit to today or before
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (newDate <= today) {
      onDateChange(newDate.toISOString().split('T')[0]);
    }
  };

  const goToToday = () => {
    const today = new Date();
    onDateChange(today.toISOString().split('T')[0]);
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.navButton} onPress={() => navigateDate('prev')}>
        <Text style={styles.navButtonText}>‹</Text>
      </TouchableOpacity>
      
      <View style={styles.dateDisplay}>
        <Text style={styles.dateText}>{formatDate(selectedDate)}</Text>
        <TouchableOpacity onPress={goToToday}>
          <Text style={styles.todayText}>Today</Text>
        </TouchableOpacity>
      </View>
      
      <TouchableOpacity style={styles.navButton} onPress={() => navigateDate('next')}>
        <Text style={styles.navButtonText}>›</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 15,
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
  navButton: {
    padding: 10,
  },
  navButtonText: {
    fontSize: 24,
    color: '#007AFF',
    fontWeight: 'bold',
  },
  dateDisplay: {
    alignItems: 'center',
  },
  dateText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
  },
  todayText: {
    fontSize: 12,
    color: '#007AFF',
    marginTop: 5,
  },
});