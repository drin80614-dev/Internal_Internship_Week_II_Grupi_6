# FinalProjectTaskManager

FinalProjectTaskManager is a clean, responsive Flutter application for organizing everyday tasks. It brings together Flutter fundamentals from the previous days, including widgets, forms, state, navigation, models, and user feedback.

## Main features

- Add tasks with a required title, optional description, and optional due date.
- Edit and delete existing tasks.
- Mark tasks as completed or active.
- Open a dedicated details screen for each task.
- See live totals for all, active, and completed tasks.
- Receive SnackBar confirmation messages after important actions.
- Store tasks locally in an in-memory `List` managed by `TaskService`.
- Use a responsive layout that remains readable on narrow and wide screens.

## How to run

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and a supported emulator or device.
2. Open a terminal in `Day5/FinalProjectTaskManager`.
3. If platform folders are not present, generate them once with:

   ```bash
   flutter create .
   ```

4. Download dependencies and run the app:

   ```bash
   flutter pub get
   flutter run
   ```

5. Run the automated checks with:

   ```bash
   flutter analyze
   flutter test
   ```

## Screenshots

Screenshots can be added here after running the app on an emulator or physical device.

Suggested screenshots:

- Empty home screen
- Home screen with active and completed tasks
- Add/edit task form
- Task details screen

## Technical reflection

The app supports the complete task workflow: create, read, update, delete, and status changes. `HomeScreen` owns the UI state and uses `setState`, while `TaskService` keeps list operations separate from the widgets. Typed results returned through `Navigator.pop` make screen-to-screen actions clear, and validation prevents blank task titles.

Tasks currently live only in memory, so they reset when the app closes. A future version could persist them with SQLite or shared preferences, add categories and search, support notifications for due dates, and introduce a larger-scale state-management solution if the app grows.
