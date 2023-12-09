# ezblog

## Project Overview

EzBlog is a user-friendly android blogging application where users can easily create and publish content. The app supports cross authentication using OAUTH with Google and Facebook accounts apart from registering

## Problem Definition

The project addresses secure authorization using OAuth, allowing users to grant limited access to their resources without exposing sensitive credentials. The OAuth implementation involves client registration, authorization requests, user authorization, token requests, and access token usage.

## Project Analysis
Functionalities of various screen in the app

### Login/Sign Up Screen:
- The Login page allows users to log in using their email and password or through social media platforms like Google and Facebook. The Sign up page allows users to create new accounts using their email,  username, and password or through social media platforms like Google and Facebook.

### Bottom Tab Navigation:
- This navigation bar is used to switched between different sections of the app based on the selected icon. Each icon corresponds to a specific page: the HomePage displaying blog posts, the Search page for searching content, the CreateBlog page for composing new blog posts, and the ProfilePage presenting user information.
- IndexedStack is used to ensure efficient rendering by displaying only the selected
page while maintaining the state of other pages.

### Home Screen:
- The feed screen displaying blog posts in a scrollable list. It fetches blog data from Firestore and arranges them based on their publication date.
- Loading indicators are used to show that the data is being fetched from the backend

### Search Screen:
- Once the user submits their search query, the app fetches data from the Firestore, filtering blog posts by titles that match the entered text.
- The search results are now displayed as a list of clickable items, each representing a blog post. Tapping on a post navigates the user to a detailed view of that specific blog post, showing its title, the banner image and its content.

### Create Blog Screen:
- Used to create new blogs or update the existing blogs.
- Users can select images from their gallery or capture photos using their camera and use it as their banner image.
- Users can input the title and content of their blog posts via text fields provided on the screen. The title and content are saved as part of the blog post’s metadata.
- The Publish button to submit the composed blog post. It utilizes Firestore to either create a new blog post or update an existing one based on the entered content.
- User can also choose to clear the whole content and start over again

### Profile Screen:
- Used to display the user information such as the username, user email, user profile picture, user provider and the blogs published.

### Detailed Blog Screen:
- Used to display various components related to a specific blog post, including the author’s avatar, username, banner image, title, and content.

## Setup

Follow the below mentioned steps to set up EzBlog in your local machine

### Prerequisites

Make sure that the following softwares are installed in your machine

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Git Clone

```bash
git clone https://github.com/SaiTeja-002/ezblog.git
cd ezblog
```

### Get The Dependencies

Run the following command to get the required dependencies:

```bash
flutter pub get
```

### Developer Options and USB Debugging

Turn on developer options and ensure that USB debugging is enabled in your Android device.

### Run

Connect your Android device to your computer and run the app using the following command to build and install the app it on your connected Android device:

```bash
flutter run
```

### Build 

Use the following command to build the APK version of the app:

```bash
flutter build apk
```

The apk file will be located at `build/app/outputs/flutter-apk/`. Share this APK file to your android device and open it via the File Manager.
