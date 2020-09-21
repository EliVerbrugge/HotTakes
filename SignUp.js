import React, { useState, useContext } from 'react';
import { AuthContext } from './AuthProvider';
import { StyleSheet, Text, TextInput, View, Button } from 'react-native';
import { event } from 'react-native-reanimated';

class SignUp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }


  register = useContext(AuthContext);

  render() {
    return (
      <View style={styles.container}>
        <Text style={{ fontSize: 18, marginBottom: 10}}>
        Display Name:
        </Text>
        <TextInput
              style={{ height: 40, borderColor: 'gray', borderWidth: 1, width: 200, marginBottom: 10 }}
              onChangeText={text => this.onChangeHandler('displayName', text)}
              value={this.props.displayName}
        />      
        <Text style={{ fontSize: 18, marginBottom: 10}}>
        Email:
        </Text>
        <TextInput
              style={{ height: 40, borderColor: 'gray', borderWidth: 1, width: 200, marginBottom: 10 }}
              onChangeText={text => this.onChangeHandler('userEmail', text)}
              value={this.props.email}
        />      
        <Text style={{ fontSize: 18}}>
          Password:
        </Text>
        <TextInput
              style={{ height: 40, borderColor: 'gray', borderWidth: 1, width: 200, marginBottom: 10 }}
              onChangeText={text => this.onChangeHandler('userPassword', text)}
              value={this.props.password}
        />      
        <Button
          onPress= {(event) => register(this.props.email, this.props.password)}
          title="Sign up"
          color="#C62828"
        />
        <Text> or </Text>
        <Button 
          title="Sign in with Google"
          color="#00C853"
        />
        <Text  style={{}}>
          Already have an account?  
          <Text style={{color: 'blue'}}
            onPress={() => this.props.navigation.navigate('SignUp')}>
            {" Sign up here"}
          </Text>
        </Text> 
      </View>
    );
  }
}

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#f5f5f5',
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
      },
      text: {
        fontSize: 24,
        marginBottom: 10
      },
});

export default SignUp;