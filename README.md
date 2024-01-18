# Indrieye

<center>
  <img src="readme/Indrieye.png" width="200px" />
</center

Indrieye is an object detection application that can help with vision and guide them through their activities. We utilize smartphone cameras to replace vision, and voice support to guide their daily activities.

## Features

### Obstacle Detection
Detect obstacles in front of the user and warn them with voice support. Coarse classification categories supported: home goods, fashion goods, food, plants, and places.

### Text Reader
Recognize text in front of the user and read it out loud.

## Team GreyBox
### Hustler:
- Anak Agung Gde Pradnyana
### Hipster:
- Ari Ziddan Nugraha
### Hacker:
- Muhammad Luthfi Khusyasy
- Raditya Aydin


## Tech Stack

### Flutter

<img src="https://storage.googleapis.com/cms-storage-bucket/847ae81f5430402216fd.svg" alt="Flutter" style="width:200px">

- Flutter allows us to do fast prototyping and development.
- Save a lot of time and cost by using built-in widgets and packages available in the Flutter community.

### Firebase

<img src="https://firebase.google.com/static/images/brand-guidelines/logo-standard.png" alt="Firebase" style="width:200px">

- We use Firebase because it is easy to integrate with Flutter.
- Firebase also provides a lot of features and allows for easy scaling.
- We used Firebase Authentication to authenticate users. And planning to use Firebase ML to deploy and manage our machine learning model.

### TensorFlow Lite + Google ML Kit

<div>
    <img src="https://developers.google.com/static/ml-kit/images/homepage/hero.png" alt="MlKit" style="width:100px">
    <img src="https://www.tensorflow.org/static/site-assets/images/project-logos/tensorflow-lite-logo-social.png" alt="TFLite" style="width:150px">
</div>

- TensorFlow Lite to run machine learning models on mobile devices for real-time object detection.
- Google ML Kit to use pre-trained machine learning models from Google for object detection and text recognition.
- We are planning to build our own model for the specific use case of detecting obstacles.

## APK Download

If you just want to try this app without running the development environtment, kindly download the apk using this download link

<img src="readme/bit.ly_Indrieye.png" width="150px" alt="QR Code" />

[Download Link](https://bit.ly/Indrieye)


## Screenshots

<div>
    <img src="readme/splash.jpg" width="200px" alt="Splash Screen" />
    <img src="readme/landing.jpg" width="200px" alt="Landing Page" />
</div>

### Register

<img src="readme/register.jpg" width="200px" alt="Login Page" />


### Login

<img src="readme/login.jpg" width="200px" alt="Login Page" />

### Obstacle Detection

<div>
    <img src="readme/obstacle-1.jpg" width="200px" alt="Obstacle Detection Start" />
    <img src="readme/obstacle-2.jpg" width="200px" alt="Obstacle Detection Warning" />
</div>

### Text Reader

<div>
    <img src="readme/reader-1.jpg" width="200px" alt="Text Reader Start" />
    <img src="readme/reader-2.jpg" width="200px" alt="Text Reader Result" />
</div>

## How to Run Development

### Prerequisites
- Flutter 3.16.7
- Android SDK
- Android Emulator

### Building Step
- Clone the repository
- Run `flutter pub get` on terminal
- Launch your emulator or connect your device
- Run debug using `F5` or `flutter run`
