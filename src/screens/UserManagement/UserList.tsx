import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, FlatList, RefreshControl } from 'react-native';

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

interface Role {
  id: number;
  name: string;
  description: string;
}

interface UserListProps {
  users: User[];
  roles: Role[];
  loading: boolean;
  refreshing: boolean;
  onRefresh: () => void;
  onCreateUser: () => void;
  onEditUser: (user: User) => void;
  onViewUser: (user: User) => void;
  onDeleteUser: (userId: number) => void;
  onToggleUserStatus: (userId: number, isActive: boolean) => void;
  getRoleById: (roleId: number) => Role | undefined;
}

export const UserList = ({
  users,
  roles,
  loading,
  refreshing,
  onRefresh,
  onCreateUser,
  onEditUser,
  onViewUser,
  onDeleteUser,
  onToggleUserStatus,
  getRoleById
}: UserListProps) => {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const renderUserItem = ({ item }: { item: User }) => {
    const role = getRoleById(item.role_id);
    
    return (
      <View style={styles.userItem}>
        <View style={styles.userItemHeader}>
          <Text style={styles.userItemName} numberOfLines={1}>
            {item.name}
          </Text>
          <Text style={[styles.userItemStatus, item.is_active ? styles.active : styles.inactive]}>
            {item.is_active ? 'Active' : 'Inactive'}
          </Text>
        </View>
        
        <Text style={styles.userItemId}>ID: {item.nisn_nip_nik}</Text>
        
        <Text style={styles.userItemRole}>
          {role ? role.name : `Role ID: ${item.role_id}`}
        </Text>
        
        <Text style={styles.userItemContact}>
          {item.email || 'No email'} • {item.phone || 'No phone'}
        </Text>
        
        <Text style={styles.userItemDate}>
          Joined: {formatDate(item.created_at)}
        </Text>
        
        <View style={styles.userItemActions}>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => onViewUser(item)}
          >
            <Text style={styles.actionButtonText}>View</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, styles.editButton]}
            onPress={() => onEditUser(item)}
          >
            <Text style={styles.actionButtonText}>Edit</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[
              styles.actionButton,
              item.is_active ? styles.deactivateButton : styles.activateButton
            ]}
            onPress={() => onToggleUserStatus(item.id, !item.is_active)}
          >
            <Text style={styles.actionButtonText}>
              {item.is_active ? 'Deactivate' : 'Activate'}
            </Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, styles.deleteButton]}
            onPress={() => onDeleteUser(item.id)}
          >
            <Text style={styles.actionButtonText}>Delete</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Users</Text>
        <TouchableOpacity
          style={styles.createButton}
          onPress={onCreateUser}
        >
          <Text style={styles.createButtonText}>+ New User</Text>
        </TouchableOpacity>
      </View>
      
      {users.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>No users found</Text>
          <TouchableOpacity
            style={styles.createButton}
            onPress={onCreateUser}
          >
            <Text style={styles.createButtonText}>Create Your First User</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={users}
          renderItem={renderUserItem}
          keyExtractor={(item) => item.id.toString()}
          refreshControl={
            <RefreshControl refreshing={refreshing || loading} onRefresh={onRefresh} />
          }
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  createButton: {
    backgroundColor: '#007AFF',
    paddingVertical: 8,
    paddingHorizontal: 15,
    borderRadius: 20,
  },
  createButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  emptyText: {
    fontSize: 16,
    color: '#666',
    marginBottom: 20,
  },
  userItem: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 15,
    marginBottom: 15,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  userItemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  userItemName: {
    fontSize: 16,
    fontWeight: 'bold',
    flex: 1,
  },
  userItemStatus: {
    fontSize: 12,
    fontWeight: 'bold',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 10,
  },
  active: {
    backgroundColor: '#34C759',
    color: 'white',
  },
  inactive: {
    backgroundColor: '#ff9500',
    color: 'white',
  },
  userItemId: {
    fontSize: 14,
    color: '#666',
    marginBottom: 5,
  },
  userItemRole: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#007AFF',
    marginBottom: 5,
  },
  userItemContact: {
    fontSize: 12,
    color: '#999',
    marginBottom: 10,
  },
  userItemDate: {
    fontSize: 12,
    color: '#999',
    marginBottom: 15,
  },
  userItemActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  actionButton: {
    backgroundColor: '#007AFF',
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 5,
  },
  editButton: {
    backgroundColor: '#34C759',
  },
  activateButton: {
    backgroundColor: '#34C759',
  },
  deactivateButton: {
    backgroundColor: '#ff9500',
  },
  deleteButton: {
    backgroundColor: '#ff3b30',
  },
  actionButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 10,
  },
});