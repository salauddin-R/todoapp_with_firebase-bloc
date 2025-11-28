# Flutter ToDo App

A simple ToDo/task management app built with **Flutter**, using **Firebase** as the backend and **flutter_bloc** (BLoC) for state management. The app supports creating, editing, and deleting tasks. It also includes an image asset located at `assets/images/img.png` used in the UI.

---

## Features

* Add new tasks
* Edit existing tasks
* Delete tasks
* Persist tasks using **Cloud Firestore** (Firebase)
* State management with **BLoC (flutter_bloc)**
* Uses a local image asset at `assets/images/img.png`

---

## Project structure (example)

```
/lib
  ├─ main.dart
  ├─ HomePage.dart
  ├─ CubitPage.dart        # BLoC / Cubit implementation
  ├─ pages/
  │   ├─ add_edit_task.dart
  │   └─ task_list.dart
  └─ widgets/
      └─ task_tile.dart
/assets
  └─ images
      └─ img.png           # Provided image asset
pubspec.yaml
README.md
```

---

## Required dependencies

Add the following (or similar) to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.0.0
  cloud_firestore: ^4.0.0
  flutter_bloc: ^8.0.0
  bloc: ^8.0.0
```

Also register the image asset in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/img.png
```

---

## Firebase setup (quick)

1. Create a Firebase project at the Firebase console.
2. Add an Android and/or iOS app to the Firebase project and follow the platform-specific steps.
3. Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them into the platform folders as instructed by Firebase.
4. Add Firebase SDK configuration in your app (see snippet below).

**Initialize Firebase** (example `main.dart`):

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

---

## Cubit / BLoC (example)

A minimal Cubit that listens to a Firestore collection and emits a list of tasks:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<List<Map<String, dynamic>>> {
  TaskCubit() : super([]);
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void fetchData() {
    _db.collection('items').snapshots().listen((snapshot) {
      final items = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      emit(items);
    });
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    await _db.collection('items').add(task);
  }

  Future<void> updateTask(String id, Map<String, dynamic> updated) async {
    await _db.collection('items').doc(id).update(updated);
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('items').doc(id).delete();
  }
}
```

Use a `BlocProvider` in `main.dart` and a `BlocBuilder`/`BlocListener` in the UI to react to state changes.

---

## Example: Showing tasks in UI

Use a `BlocBuilder<TaskCubit, List<Map<String, dynamic>>>` and `ListView.builder`.

```dart
BlocBuilder<TaskCubit, List<Map<String, dynamic>>>(
  builder: (context, state) {
    return ListView.builder(
      itemCount: state.length,
      itemBuilder: (context, index) {
        final task = state[index];
        return ListTile(
          title: Text(task['name'] ?? 'No title'),
          subtitle: Text(task['description'] ?? ''),
        );
      },
    );
  },
)
```

---

## Asset usage

Make sure the image is placed at `assets/images/img.png` and declared in `pubspec.yaml`. Use it in the UI like this:

```dart
Image.asset('assets/images/img.png');
```

---

## Running the app

1. Ensure Firebase configuration files are in place (`google-services.json` / `GoogleService-Info.plist`).
2. Run `flutter pub get`.
3. Launch the app with `flutter run` or from your IDE.

---

## Troubleshooting

* **No data shown**: Ensure your Cubit emits the list after listening to Firestore snapshots (use `emit(items)` inside the listener). Also confirm collection name (`items`) and field names (for example `name`) match your Firestore documents.
* **Missing image**: Confirm the `assets/images/img.png` path is correct and that it is listed under `flutter.assets` in `pubspec.yaml`.
* **Firebase errors**: Verify Firebase initialization completed successfully and platform configuration files are correctly placed.

---

## Notes

* This README is a simple, copy-paste friendly guide. You can expand it with screenshots, CI instructions, or more advanced Firebase security rules and structure as needed.

---

## License

MIT License — feel free to use and modify.

