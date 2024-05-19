# Todo App

## Features

- **Login Page**:
  - Lets you log in.
  - Saves your token, image, userId, and username using `shared_preferences` package.
  - Takes you to the `My Tasks Page` after logging in.

- **MyTasks Page**:
  - Shows all your tasks.
  - Lets you update and delete tasks.
  - And if you want to add you go the second tab from the bottom navigation bar.
  - Uses `sqflite` for storing tasks so you can view and add new ones offline.

- **Add Task**:
  - Access this through the second tab in the bottom navigation bar.
  - Lets you add new tasks.

- **App Bar Buttons**:
  - In the same page:  
  - **Right Button**: Refreshes your token.
  - **Left Button**: Opens your profile page.

- **Profile Page**:
  - Fetches and displays your information and a random todo.
  - Has a button to fetch a new random todo.

- **Pagination**:
  - Implemented on the third page to load tasks in parts.
  - Loads more tasks as you scroll down.

## Design Decisions

- **State Management**:
  - Used the BLoC pattern to manage the app's state.

- **Data Persistence**:
  - Used `shared_preferences` for session data.
  - Used `sqflite` for local storage of tasks.

- **Offline Capabilities**:
  - You can view and add tasks even when offline.

## Unit Tests

- **Login**:
  - Tests for login functionality.
- **CRUD Operations**:
  - Tests for creating, reading, updating, and deleting my tasks.
- **State Management**:
  - Tests using the `bloc_test` package to ensure BLoC state transitions are correct.

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/Salim-Jabbour/todos
