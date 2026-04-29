# File Explorer

## Project Discussion

This project is a minimalist File Explorer application built with Flutter. The main goal of this project is to demonstrate how to manage file and folder operations using only setState and StatefulWidget, without leveraging any advanced state management solutions.

### Key Features

- **Create Folder**: Users can create new folders in the app's document directory.
- **Create Text File**: Users can create simple text files within folders.
- **Delete**: Both files and folders can be deleted (including non-empty folders with confirmation).
- **Rename**: Users can rename any file or folder.
- **Export**: Files and folders can be exported from the application's document directory (e.g., sharing or moving outside the app scope).

All data (folders and text files) is managed directly in the application's document directory using standard Dart file IO APIs.

### Technical Scope and Decisions

- **State Management**: All UX updates (e.g., after create/delete/rename) are handled through setState inside StatefulWidget. There is no use of Providers, Bloc, Riverpod, or other external state management solutions. This keeps the architecture simple and maximally transparent, ideal for beginners or educational contexts.
- **Storage**: The app reads from and writes to the OS-provided application document directory, creating a real local file/folder structure.
- **Supported Operations**:  
  - Creating folders and text files  
  - Deleting files and folders  
  - Renaming files and folders  
  - Exporting contents

### Why only setState and StatefulWidget?

By using only setState and StatefulWidget:
- The logic remains easy to follow for those new to Flutter.
- There's no overhead from external dependencies or advanced state management.
- The teaching focus is purely on fundamental UI and file operations.

### Example Use Case

1. Open the app and see the current folder structure.
2. Tap to create a new folder ("Homework").
3. Enter the folder, create a new file ("notes.txt"), and add some text.
4. Rename the file to "math_notes.txt".
5. Export the file via share or move action.
6. If no longer needed, delete the folder.

### Considerations & Limitations

- Since only setState is used, as complexity grows, you may need to refactor into more fine-grained widgets to avoid rebuilding unnecessary parts of the tree.
- There is no built-in sync to cloud or backup—files are local to the app's sandbox.

---

*This project is ideal for those wanting to learn core Flutter concepts around state, file operations, and user interface design—all in a single, understandable codebase.*
