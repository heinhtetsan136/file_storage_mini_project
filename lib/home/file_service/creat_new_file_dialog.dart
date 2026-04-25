import 'package:file_storage_mini_project/home/file_service/file_service.dart';
import 'package:flutter/material.dart';

class CreateNewFileDialog extends StatefulWidget {
  const CreateNewFileDialog({
    super.key,
    required this.currentLocation,
  });

  final String currentLocation;

  @override
  State<CreateNewFileDialog> createState() =>
      _CreateNewFileDialogState();
}

class _CreateNewFileDialogState
    extends State<CreateNewFileDialog> {
  final TextEditingController _controller =
      TextEditingController();
  final FileService _fileService = FileService();

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
          onPressed: () async {
            try {
              await _fileService.writeFile(
                status: (status) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(status),
                    ),
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
                    content: Text(
                      "Failed to Create",
                    ),
                  ),
                );
              }
            }
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
