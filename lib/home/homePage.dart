import 'dart:io';

import 'package:file_storage_mini_project/home/appTheme/theme_const_for_storage.dart';
import 'package:file_storage_mini_project/home/file_service/creat_new_or_rename_file_dialog.dart';
import 'package:file_storage_mini_project/home/file_service/create_new_or_rename_folder_dialog.dart';
import 'package:file_storage_mini_project/home/file_service/delete_dialog.dart';
import 'package:file_storage_mini_project/home/file_service/file_service.dart';
import 'package:file_storage_mini_project/note_pad_screen.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({
    super.key,
    required this.themeChange,
  });

  final Function(String onChanged) themeChange;

  @override
  State<Homepage> createState() =>
      _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _fileService = FileService();

  List<Directory> _listOfFolder = [];

  List<File> _listofFile = [];
  String _currentLocation = "";

  void _deleteFolder({
    required String folderLocation,
    required String folderName,
    required BuildContext context,
  }) async {
    try {
      await _fileService.deleteFolder(
        folderLocation,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Delete success $folderName",
            ),
          ),
        );
      }
      _loadFileandFolder(_currentLocation);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Delete Failed $folderName",
            ),
          ),
        );
      }
    }
  }

  void _deleteFile({
    required String fileLocation,
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      await _fileService.deleteFile(fileLocation);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Delete success $fileName",
            ),
          ),
        );
      }
      _loadFileandFolder(_currentLocation);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Delete Failed $fileName",
            ),
          ),
        );
      }
    }
  }

  void _loadFileandFolder(String path) async {
    _listOfFolder = await _fileService
        .getListOfFolder(path);
    _listofFile = await _fileService
        .getListOfFile(path);
    print("lenght ${_listofFile.length}");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFileandFolder(_currentLocation);
  }

  void _createNewFolder() async {
    bool isOk = await showDialog(
      context: context,
      builder: (context) {
        return CreateorRenameNewFolderDialog(
          currentLocation: "$_currentLocation/",
        );
      },
    );
    if (isOk == true) {
      _loadFileandFolder(_currentLocation);
    }
  }

  void _renameFolder(String oldName) async {
    bool isOk = await showDialog(
      context: context,
      builder: (context) {
        return CreateorRenameNewFolderDialog(
          currentLocation: "$_currentLocation/",
          oldName: oldName,
        );
      },
    );
    if (isOk) {
      _loadFileandFolder(_currentLocation);
    }
  }

  void _renameFile(String oldName) async {
    bool isOk = await showDialog(
      context: context,
      builder: (context) {
        return CreateNewOrRenameFileDialog(
          currentLocation: "$_currentLocation/",
          oldName: oldName,
        );
      },
    );
    if (isOk) {
      _loadFileandFolder(_currentLocation);
    }
  }

  void _createNewFile() async {
    print(_currentLocation);
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateNewOrRenameFileDialog(
          currentLocation: '$_currentLocation/',
        );
      },
    );
    if (isOK) {
      _loadFileandFolder(_currentLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController =
        ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("File Explorer"),
        actions: [
          IconButton(
            tooltip: "Create new folder",
            onPressed: () async {
              _createNewFolder();
              // await _fileService.createFolder(
              //   "This is testing${DateTime.now().millisecondsSinceEpoch}",
              // );
              // _loadFileandFolder(
              //   _currentLocation,
              // );
            },
            icon: Icon(Icons.create_new_folder),
          ),
          IconButton(
            tooltip: "Create new file",
            onPressed: () async {
              _createNewFile();
            },
            icon: Icon(Icons.note_add_outlined),
          ),
          PopupMenuButton(
            onSelected: (str) {
              widget.themeChange(str);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    "Successfully Changed to $str theme",
                  ),
                ),
              );
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value:
                      themeMode[AppThemeMode
                          .light],
                  child: Text("Light"),
                ),
                PopupMenuItem(
                  value:
                      themeMode[AppThemeMode
                          .dark],
                  child: Text("Dark"),
                ),
                PopupMenuItem(
                  value:
                      themeMode[AppThemeMode
                          .system],
                  child: Text("System"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Scrollbar(
        interactive: true,
        notificationPredicate: (_) => true,
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ListTile(
                leading: IconButton(
                  onPressed:
                      _currentLocation == ""
                      ? null
                      : () {
                          print(
                            "first $_currentLocation",
                          );
                          final List<String> dir =
                              _currentLocation
                                  .split("/");
                          dir.removeLast();
                          _currentLocation = dir
                              .join("/");
                          print(
                            "second $_currentLocation",
                          );
                          _loadFileandFolder(
                            _currentLocation,
                          );
                        },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
                title: Text(
                  _currentLocation.isEmpty
                      ? "/"
                      : _currentLocation,
                ),
              ),
            ),
            SliverList.builder(
              itemBuilder: (_, index) {
                final Directory directory =
                    _listOfFolder[index];
                String foldername = directory.path
                    .split("/")
                    .last;
                String folderlocation =
                    "$_currentLocation/$foldername";

                return ListTile(
                  trailing: PopupMenuButton(
                    onSelected: (str) async {
                      if (str == "delete") {
                        _deleteFolder(
                          folderLocation:
                              folderlocation,
                          folderName: foldername,
                          context: context,
                        );
                      }
                      if (str == "rename") {
                        _renameFolder(foldername);
                      }
                    },
                    itemBuilder: (_) {
                      return [
                        PopupMenuItem(
                          child: Text("Rename"),
                          value: "rename",
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: "delete",
                        ),
                      ];
                    },
                  ),
                  onTap: () {
                    print(directory.path);
                    _currentLocation =
                        folderlocation;
                    _loadFileandFolder(
                      _currentLocation,
                    );
                  },
                  leading: Icon(
                    Icons.folder_copy_outlined,
                  ),
                  title: Text(
                    directory.path
                        .split("/")
                        .last,
                  ),
                  subtitle: Text(
                    directory
                        .statSync()
                        .changed
                        .toString(),
                  ),
                );
              },
              itemCount: _listOfFolder.length,
            ),
            SliverToBoxAdapter(child: Divider()),
            SliverList.builder(
              itemBuilder: (_, index) {
                final File file =
                    _listofFile[index];
                final fileName = file.path
                    .split("/")
                    .last;
                return ListTile(
                  onTap: () {
                    print(
                      "locattion $_currentLocation",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotePadScreen(
                              currentfileLocation:
                                  "$_currentLocation/$fileName",
                            ),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.file_copy_outlined,
                  ),
                  title: Text(
                    file.path.split("/").last,
                  ),
                  subtitle: Text(
                    file
                        .statSync()
                        .changed
                        .toString(),
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (String str) {
                      if (str == "delete") {
                        _deleteFile(
                          fileLocation:
                              "$_currentLocation/$fileName",
                          fileName: fileName,
                          context: context,
                        );
                      }
                      if (str == "rename") {
                        _renameFile(fileName);
                      } else {
                        _exportfile(
                          fileName,
                          file,
                        );
                      }
                    },
                    itemBuilder: (_) {
                      return [
                        PopupMenuItem(
                          child: Text("Rename"),
                          value: "rename",
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: "delete",
                        ),
                        PopupMenuItem(
                          child: Text("Export"),
                          value: "export",
                        ),
                      ];
                    },
                  ),
                );
              },
              itemCount: _listofFile.length,
            ),
          ],
        ),
      ),
    );
  }

  void _exportfile(String name, File file) async {
    final result = await _fileService.exportFile(
      name,
      file,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "File have Saved at $result",
        ),
      ),
    );
  }
}
