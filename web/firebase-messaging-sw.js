// firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.16.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.16.0/firebase-messaging-compat.js');

const firebaseConfig = {
  apiKey: "AIzaSyCFMlxGiBTx497V5mP7AT9I_8nlkOb_T34",
  authDomain: "joke-app-web.firebaseapp.com",
  projectId: "joke-app-web",
  storageBucket: "joke-app-web.firebasestorage.app",
  messagingSenderId: "354114895059",
  appId: "1:354114895059:web:5ba9e132f57ecdc97e2826",
  measurementId: "G-QT12CJ38T1"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});