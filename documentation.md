# ACME Solutions

ACME Solutions is a Flutter application designed specifically for freelancers who manage multiple tasks daily. It provides a robust offline-first experience with seamless synchronization to online services when available. This app is ideal for users who need reliable access to their task management functionalities without consistent internet connectivity.

## Getting Started

To run this project, clone the repository and switch to the appropriate branch.


### Prerequisites

- Flutter (latest version)
- Dart (latest version)
- An IDE (Android Studio or VS Code)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/clintonksang/tushop.git


2. Switch to directory
 cd tushop

3. Install all packages

flutter pub get

5. Run the application

flutter run.


## Documentation on how it works

This application is a task management system that integrates local storage (Hive) with Firebase Firestore for seamless data synchronization. It enables users to:

1. Add, edit, delete, and view tasks.
2. Work offline with local storage and sync data to Firebase when online.
3. Monitor network connectivity and trigger automatic synchronization.
4. Resolve conflicts between local and remote data.
5. Authenticate users using Firebase Authentication (Phone, Email, and Password).

### Task Management

- **Add Task**: Users can add tasks with fields such as title, description, date, and status.
- **Edit Task**: Modify existing tasks.
- **Delete Task**: Remove tasks individually or clear all tasks.
- **View Tasks**: View tasks sorted by status (e.g., "Pending" tasks appear first).

### Offline-First Capability

- Tasks are saved locally using Hive.
- Tasks added offline are marked as unsynced and queued for synchronization when the network is available.

### Firebase Integration

- Synchronization with Firebase Firestore ensures tasks are backed up and available across devices.
- Fetches tasks from Firestore and merges them with local storage.

### User Authentication

- **Phone Authentication**: Users can log in using their phone numbers.
- **Email and Password Authentication**: Users can sign up and log in with their email addresses and passwords.
- Authentication ensures tasks are associated with specific users, enabling personalized task management.

### Connectivity Monitoring

- Real-time network status detection.
- Displays online/offline status with color-coded indicators.
- Automatically syncs unsynced tasks when the app goes online.

### Auto-Synchronization

#### Online Behavior

- When the app detects an active internet connection, it automatically:
  - Syncs any unsynced tasks from Hive to Firebase Firestore.
  - Fetches the latest tasks from Firebase and merges them with local data.
  - Resolves conflicts by retaining the task with the latest `updatedAt` timestamp.

#### Offline Behavior

- If the network is unavailable:
  - Tasks are stored locally in Hive with `isSynced = false`.
  - A visual indicator shows the app is offline.
  - Once the network is restored, pending tasks are synced automatically, and a progress bar appears to indicate the synchronization process.

---

## Application Flow

### Startup

- The app initializes Hive and opens the `tasks` box.
- Firebase Firestore is set up for remote storage.
- Firebase Authentication initializes to manage user sessions.

### User Authentication

- **Sign Up**: Users can create accounts using their email and password.
- **Sign In**: Users can log in using email/password or phone authentication.
- **Sign Out**: Users can log out, clearing session-specific data.

### Adding a Task

- Users can add tasks via the "Create New Task" button.
- Tasks are saved locally in Hive.
- If the network is available, tasks are immediately synced to Firebase.

### Viewing Tasks

- Tasks are displayed in a list, sorted by status and date.
- Tasks marked as "Pending" appear first, followed by "Done" tasks.

### Editing a Task

- Users can edit a task by tapping on it.
- Changes are updated locally and synced to Firebase if the network is available.

### Deleting Tasks

- Users can delete individual tasks or clear all tasks.
- Deletions are applied locally and synced to Firebase.

### Synchronization

- The app listens to Firebase for real-time updates using Firestore streams.
- On detecting new remote tasks, the app merges them with local data.
- Conflicts are resolved by comparing the `updatedAt` timestamp.

---

## Technical Details

### Local Storage (Hive)

- **Box Name**: `tasks`
- **Model**: `TaskModel`
  ```dart
  class TaskModel {
    String id;
    String title;
    String taskStatus;
    String description;
    DateTime date;
    DateTime updatedAt;
    bool isSynced;
  }
  ```

### Firebase Firestore

- **Collection Name**: `tasks`
- **Structure**:
  ```json
  {
    "id": "string",
    "title": "string",
    "taskStatus": "string",
    "description": "string",
    "date": "ISODate",
    "updatedAt": "ISODate"
  }
  ```

### Firebase Authentication

- Authentication methods:
  - **Phone Authentication**: Sends an OTP for verification.
  - **Email/Password Authentication**: Standard sign-up and sign-in process.
- Authenticated users have tasks associated with their user ID.

### Network Monitoring

- Uses the `connectivity_plus` package to detect network status.
- Online status triggers automatic task synchronization.

### Synchronization Logic

- **Sync to Firebase**:
  - Iterates over local tasks marked as `isSynced = false`.
  - Sends them to Firestore and updates `isSynced` on success.
- **Fetch from Firebase**:
  - Fetches tasks from Firestore.
  - Merges with local data, updating only if the remote task is newer.

---

## Key Components

### Home Screen

- Displays all tasks.
- Shows online/offline status.
- Triggers synchronization via a refresh button.

### Task Form

- Used for adding or editing tasks.
- Validates inputs and supports date selection.

### Task Card

- Represents individual tasks in the list.
- Allows status updates and navigation to the edit screen.

### Hive Repository

- Handles all Hive operations (add, update, delete, fetch).

### TaskSyncService

- Manages synchronization between Hive and Firestore.
- Detects unsynced tasks and resolves conflicts.

### AuthenticationService

- Manages user authentication and session handling.
- Associates tasks with user accounts.

---

## Example Usage

### Adding a Task

1. Log in using your preferred authentication method.
2. Tap the "Create New Task" button.
3. Fill in the title, description, and date.
4. Save the task.
5. If online, the task is synced to Firebase immediately.

### Resolving Conflicts

- If a task exists in both local and remote storage, the app keeps the version with the latest `updatedAt` timestamp.

### Viewing Network Status

- The app displays a green indicator for "Online" and a red indicator for "Offline."

---

## Packages Used

- **Hive**: Local storage.
- **Hive Flutter**: Flutter integration for Hive.
- **Firebase Firestore**: Remote database.
- **Firebase Authentication**: User authentication.
- **Connectivity Plus**: Network status detection.

---

## Future Improvements

- Add advanced user settings and profile management.
- Add analytics to track user activity.
 