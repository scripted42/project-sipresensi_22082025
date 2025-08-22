import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity, ScrollView, Alert, Switch } from 'react-native';

// Types
interface Announcement {
  id: number;
  title: string;
  content: string;
  author_id: number;
  is_published: boolean;
  published_at: string | null;
  created_at: string;
  updated_at: string;
}

interface AnnouncementFormProps {
  announcement: Announcement | null;
  onSaveAnnouncement: (announcementData: any) => void;
  onCancel: () => void;
  loading: boolean;
}

export const AnnouncementForm = ({ announcement, onSaveAnnouncement, onCancel, loading }: AnnouncementFormProps) => {
  const [title, setTitle] = useState(announcement?.title || '');
  const [content, setContent] = useState(announcement?.content || '');
  const [isPublished, setIsPublished] = useState(announcement?.is_published || false);

  useEffect(() => {
    if (announcement) {
      setTitle(announcement.title);
      setContent(announcement.content);
      setIsPublished(announcement.is_published);
    }
  }, [announcement]);

  const handleSave = () => {
    // Validate form
    if (!title.trim()) {
      Alert.alert('Validation Error', 'Please enter a title for the announcement');
      return;
    }

    if (!content.trim()) {
      Alert.alert('Validation Error', 'Please enter content for the announcement');
      return;
    }

    const announcementData = {
      title: title.trim(),
      content: content.trim(),
      is_published: isPublished,
    };

    onSaveAnnouncement(announcementData);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>{announcement ? 'Edit Announcement' : 'New Announcement'}</Text>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Title</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter announcement title..."
          value={title}
          onChangeText={setTitle}
        />
      </View>
      
      <View style={styles.formGroup}>
        <Text style={styles.label}>Content</Text>
        <TextInput
          style={styles.textArea}
          multiline
          numberOfLines={6}
          placeholder="Enter announcement content..."
          value={content}
          onChangeText={setContent}
        />
      </View>
      
      <View style={styles.formGroup}>
        <View style={styles.switchContainer}>
          <Text style={styles.label}>Publish Immediately</Text>
          <Switch
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={isPublished ? '#f5dd4b' : '#f4f3f4'}
            onValueChange={setIsPublished}
            value={isPublished}
          />
        </View>
        <Text style={styles.switchDescription}>
          {isPublished 
            ? 'This announcement will be visible to all users immediately after saving.' 
            : 'This announcement will be saved as a draft and can be published later.'}
        </Text>
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
            {loading ? 'Saving...' : (announcement ? 'Update' : 'Create')}
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
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
  },
  textArea: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
    textAlignVertical: 'top',
    height: 150,
  },
  switchContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  switchDescription: {
    fontSize: 14,
    color: '#666',
    fontStyle: 'italic',
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