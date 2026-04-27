import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  final FileSaver _fileSaver = FileSaver.instance;

  Future<String?> exportFile(
    String name,
    File file,
  ) async {
    final result = await _fileSaver.saveAs(
      bytes: file.readAsBytesSync(),
      name: name,
      fileExtension: "txt",
      mimeType: MimeType.text,
    );
    return result;
  }

  Future<Directory> getDirectory() {
    return getApplicationDocumentsDirectory();
  }

  Future<Directory> createFolder(
    String folderName, {
    Function(String status)? status,
  }) async {
    final Directory root = await getDirectory();
    final myfolder = Directory(
      "${root.path}/$folderName",
    );
    final bool isExist = await myfolder.exists();
    if (!isExist) {
      final path = await myfolder.create(
        recursive: true,
      );
      debugPrint("$path");
      status?.call("Folder Created");
    } else {
      status?.call("Folder Already Exist");
    }
    return myfolder;
  }

  Future<File> writeFile(
    String contents,
    String folderName, {
    Function(String status)? status,
  }) async {
    final Directory root = await getDirectory();
    final myfolder = File(
      "${root.path}/$folderName",
    );
    final bool isExist = await myfolder.exists();
    if (!isExist) {
      final path = await myfolder.create(
        recursive: true,
      );
      debugPrint("$path");
      status?.call("File Created");
    } else {
      status?.call("File Already Exist");
    }
    await myfolder.writeAsString(contents);
    return myfolder;
  }

  Future<List<Directory>> getListOfFolder(
    String path,
  ) async {
    final Directory root = await getDirectory();
    final currentFolder = Directory(
      "${root.path}/$path",
    );
    final list = currentFolder.list();
    return list
        .where((entity) => entity is Directory)
        .cast<Directory>()
        .toList();
  }

  Future<List<File>> getListOfFile(
    String path,
  ) async {
    final Directory root = await getDirectory();
    final currentFolder = Directory(
      "${root.path}/$path",
    );
    final list = currentFolder.list();
    return list
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
  }

  Future<String> readFile(String path) async {
    final Directory root = await getDirectory();
    final file = File("${root.path}/$path");
    final String text = await file.readAsString();
    return text;
  }

  Future<void> deleteFile(String path) async {
    final Directory root = await getDirectory();
    final currentFile = File(
      "${root.path}/$path",
    );
    currentFile.delete(recursive: true);
  }

  Future<void> deleteFolder(String path) async {
    final Directory root = await getDirectory();
    final currentFolder = Directory(
      "${root.path}/$path",
    );
    currentFolder.delete(recursive: true);
  }

  Future<void> renameFile(
    String oldPath,
    String newPath, {
    required Function(String str) status,
  }) async {
    final Directory root = await getDirectory();
    final currentFile = File(
      "${root.path}/$oldPath",
    );
    final String newFileName =
        "${root.path}/$newPath";
    final newFile = File(newFileName);
    if (newFile.existsSync()) {
      throw Exception("Folder already exists");
    }
    final directory = await currentFile.rename(
      newFileName,
    );
    print("new directory=$directory");
  }

  Future<void> renameFolder(
    String oldPath,
    String newPath, {
    required Function(String str) status,
  }) async {
    final Directory root = await getDirectory();
    final currentFolder = Directory(
      "${root.path}/$oldPath",
    );
    final String newFolderPath =
        "${root.path}/$newPath";
    final newFolder = Directory(newFolderPath);
    if (newFolder.existsSync()) {
      throw Exception("Folder already exists");
    }
    final directory = await currentFolder.rename(
      newFolderPath,
    );
    print("new directory=$directory");
  }
}
