import 'dart:io';

import 'package:file_storage_mini_project/home/file_service/creat_new_file_dialog.dart';
import 'package:file_storage_mini_project/home/file_service/create_new_folder_dialog.dart';
import 'package:file_storage_mini_project/home/file_service/file_service.dart';
import 'package:file_storage_mini_project/note_pad_screen.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() =>
      _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _fileService = FileService();

  List<Directory> _listOfFolder = [];

  List<File> _listofFile = [];
  String _currentLocation = "";

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
        return CreateNewFolderDialog(
          currentLocation: "$_currentLocation/",
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
        return CreateNewFileDialog(
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
                );
              },
              itemCount: _listofFile.length,
            ),
          ],
        ),
      ),
    );
  }
}
