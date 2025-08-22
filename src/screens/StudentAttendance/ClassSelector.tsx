import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Modal, ScrollView } from 'react-native';

// Types
interface Class {
  id: number;
  name: string;
  homeroom_teacher_id: number;
}

interface ClassSelectorProps {
  classes: Class[];
  selectedClass: Class | null;
  onSelectClass: (classObj: Class) => void;
  loading: boolean;
}

export const ClassSelector = ({ classes, selectedClass, onSelectClass, loading }: ClassSelectorProps) => {
  const [modalVisible, setModalVisible] = useState(false);

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Select Class:</Text>
      <TouchableOpacity
        style={[styles.selectorButton, loading && styles.disabledButton]}
        onPress={() => !loading && setModalVisible(true)}
        disabled={loading}
      >
        <Text style={styles.selectorText}>
          {selectedClass ? selectedClass.name : 'Choose a class...'}
        </Text>
      </TouchableOpacity>

      <Modal
        animationType="slide"
        transparent={true}
        visible={modalVisible}
        onRequestClose={() => setModalVisible(false)}
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Select a Class</Text>
            <ScrollView>
              {classes.map((classObj) => (
                <TouchableOpacity
                  key={classObj.id}
                  style={styles.classItem}
                  onPress={() => {
                    onSelectClass(classObj);
                    setModalVisible(false);
                  }}
                >
                  <Text style={styles.classItemText}>{classObj.name}</Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
            <TouchableOpacity
              style={styles.closeButton}
              onPress={() => setModalVisible(false)}
            >
              <Text style={styles.closeButtonText}>Close</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 20,
  },
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 5,
  },
  selectorButton: {
    backgroundColor: 'white',
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  disabledButton: {
    opacity: 0.6,
  },
  selectorText: {
    fontSize: 16,
    color: '#333',
  },
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalContent: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 20,
    width: '80%',
    maxHeight: '60%',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
    textAlign: 'center',
  },
  classItem: {
    padding: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  classItemText: {
    fontSize: 16,
    color: '#333',
  },
  closeButton: {
    marginTop: 15,
    padding: 10,
    backgroundColor: '#ff3b30',
    borderRadius: 5,
    alignItems: 'center',
  },
  closeButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
});