import 'package:file_storage_mini_project/home/file_service/file_service.dart';
import 'package:flutter/material.dart';

class CreateNewOrRenameFileDialog
    extends StatefulWidget {
  const CreateNewOrRenameFileDialog({
    super.key,
    required this.currentLocation,
    this.oldName,
  });

  final String? oldName;
  final String currentLocation;

  @override
  State<CreateNewOrRenameFileDialog>
  createState() =>
      _CreateNewOrRenameFileDialogState();
}

class _CreateNewOrRenameFileDialogState
    extends State<CreateNewOrRenameFileDialog> {
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
    return AlertDialog(
      title: Text("Create New File"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter new file name"),
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

  void _rename() async {
    if (_controller.text == widget.oldName)
      return;
    try {
      await _fileService.renameFile(
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
      print("error is $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text("Failed to rename $e"),
          ),
        );
      }
    }
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void _createNew() async {
    try {
      await _fileService.writeFile(
        status: (status) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(content: Text(status)),
          );
        },
        "",
        "${widget.currentLocation}${_controller.text}",
      );
    } catch (e) {
      print("error is $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text("Failed to Create"),
          ),
        );
      }
    }
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }
}
