import 'package:file_storage_mini_project/home/file_service/file_service.dart';
import 'package:flutter/material.dart';

class CreateorRenameNewFolderDialog
    extends StatefulWidget {
  const CreateorRenameNewFolderDialog({
    super.key,
    required this.currentLocation,
    this.oldName,
  });

  final String? oldName;
  final String currentLocation;

  @override
  State<CreateorRenameNewFolderDialog>
  createState() =>
      _CreateorRenameNewFolderDialogState();
}

class _CreateorRenameNewFolderDialogState
    extends State<CreateorRenameNewFolderDialog> {
  final TextEditingController _controller =
      TextEditingController();
  final FileService _fileService = FileService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.oldName != null) {
      _controller.text = widget.oldName!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widgetoldpath ${widget.oldName}");
    return AlertDialog(
      title: Text("Create New Folder"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter new folder name"),
          SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: widget.oldName == null
              ? _createNew
              : _rename,
          child: Text("OK"),
        ),
      ],
    );
  }

  void _createNew() async {
    print("create new");
    try {
      await _fileService.createFolder(
        status: (status) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(content: Text(status)),
          );
        },

        "${widget.currentLocation}${_controller.text}",
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text("Failed to Create $e"),
          ),
        );
      }
    }
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void _rename() async {
    if (_controller.text == widget.oldName)
      return;
    try {
      await _fileService.renameFolder(
        "${widget.currentLocation}${widget.oldName}",
        "${widget.currentLocation}${_controller.text}",
        status: (status) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(content: Text(status)),
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text("Failed to Rename"),
          ),
        );
      }
    }
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }
}
