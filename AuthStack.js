import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import SignIn from './SignIn';
import SignUp from './SignUp';
const Stack = createStackNavigator();
export default function AuthStack() {
  return (
    <Stack.Navigator initialRouteName='SignIn'>
      <Stack.Screen
        name='SignIn'
        component={SignIn}
        options={{ header: () => null }}
      />
      <Stack.Screen 
        name='SignUp'
        component={SignUp} 
      />
    </Stack.Navigator>
  );
}