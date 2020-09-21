import React, { useContext } from 'react';
import { View, Text, StyleSheet, Button } from 'react-native';
import { AuthContext } from './AuthProvider';
export default function HomeScreen() {
  const { user, logout } = useContext(AuthContext);
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Welcome user {user.uid}</Text>
      <Button title='Logout' onPress={() => logout()} />
    </View>
  );
}
// styles remain same