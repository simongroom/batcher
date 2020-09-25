fetch('configs/firebase_config.json')
    .then(response => response.json())
    .then(data => {
        // Initialize Firebase
        firebase.initializeApp(data);
    });
