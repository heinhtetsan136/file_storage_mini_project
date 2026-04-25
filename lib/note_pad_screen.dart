import 'package:file_storage_mini_project/home/file_service/file_service.dart';
import 'package:flutter/material.dart';

class NotePadScreen extends StatefulWidget {
  final String currentfileLocation;

  NotePadScreen({
    super.key,
    required this.currentfileLocation,
  });

  @override
  State<NotePadScreen> createState() =>
      _NotePadScreenState();
}

class _NotePadScreenState
    extends State<NotePadScreen> {
  final TextEditingController
  _textEditingController =
      TextEditingController();
  final FileService fileService = FileService();
  bool _hasEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileService
        .readFile(widget.currentfileLocation)
        .then((str) {
          _textEditingController.text = str;
          setState(() {});
        });
    _textEditingController.addListener(() {
      if (!_hasEdit) {
        setState(() {
          _hasEdit = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.currentfileLocation
              .split("/")
              .last,
        ),
        actions: [
          IconButton(
            onPressed: _hasEdit
                ? () async {
                    print(
                      "this is location ${widget.currentfileLocation}",
                    );
                    try {
                      await fileService.writeFile(
                        _textEditingController
                            .text,
                        widget
                            .currentfileLocation,
                        status: (status) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Colors.green,
                                content: Text(
                                  "File saved successfully",
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                Colors.red,
                            content: Text(
                              "Failed to save file: $e",
                            ),
                          ),
                        );
                      }
                    }
                  }
                : null,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _textEditingController,
          maxLines: 30,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
