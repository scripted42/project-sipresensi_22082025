import React, { useState } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity } from 'react-native';

interface ManualInputSectionProps {
  onManualInput: (nisnNipNik: string) => void;
  loading: boolean;
}

export const ManualInputSection = ({ onManualInput, loading }: ManualInputSectionProps) => {
  const [inputValue, setInputValue] = useState('');

  const handleInput = () => {
    if (!inputValue.trim()) {
      return;
    }
    
    onManualInput(inputValue.trim());
    setInputValue('');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Manual Input</Text>
      <Text style={styles.description}>
        Enter student's NISN/NIP/NIK if QR code is not available
      </Text>
      
      <TextInput
        style={styles.input}
        placeholder="Enter NISN/NIP/NIK"
        value={inputValue}
        onChangeText={setInputValue}
        editable={!loading}
        keyboardType="numeric"
      />
      
      <TouchableOpacity
        style={[styles.submitButton, (loading || !inputValue.trim()) && styles.disabledButton]}
        onPress={handleInput}
        disabled={loading || !inputValue.trim()}
      >
        <Text style={styles.submitButtonText}>Submit</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 20,
    padding: 20,
    backgroundColor: 'white',
    borderRadius: 10,
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
    marginBottom: 10,
    textAlign: 'center',
  },
  description: {
    fontSize: 14,
    color: '#666',
    marginBottom: 15,
    textAlign: 'center',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
    marginBottom: 15,
  },
  submitButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  disabledButton: {
    opacity: 0.6,
  },
  submitButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
});