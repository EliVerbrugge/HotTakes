import firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";

const firebaseConfig = {
  apiKey: 'AIzaSyDO1ZWxUe7c8WHiMn2w3UEVbbalH6inQLE',
  authDomain: 'hottakes-1a324.firebaseapp.com',
  databaseURL: 'https://hottakes-1a324.firebaseio.com',
  projectId: 'hottakes-1a324',
  storageBucket: 'hottakes-1a324.appspot.com',
  messagingSenderId: '807979845276',
  appId: "1:807979845276:android:9f3c827a749b66c181cf59"
};

firebase.initializeApp(firebaseConfig);
export const auth = firebase.auth();
export const firestore = firebase.firestore();