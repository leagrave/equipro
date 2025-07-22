import 'dart:io';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class AddFileWidget extends StatefulWidget {
  final String userId;
  final VoidCallback? onUploadSuccess;

  const AddFileWidget({Key? key, required this.userId, this.onUploadSuccess}) : super(key: key);

  @override
  State<AddFileWidget> createState() => _AddFileWidgetState();
}

class _AddFileWidgetState extends State<AddFileWidget> {
  File? _selectedFile;
  bool _isUploading = false;
  String? _uploadMessage;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _uploadMessage = null;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      setState(() {
        _uploadMessage = 'Veuillez sélectionner un fichier d\'abord.';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadMessage = null;
    });

    try {
      String fileName = _selectedFile!.path.split('/').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_selectedFile!.path, filename: fileName),
        'userId': widget.userId,
      });

      final response = await Dio().post(
        '${Constants.apiBaseUrl}/upload', 
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 201) {
        setState(() {
          _uploadMessage = 'Fichier uploadé avec succès !';
          _selectedFile = null;
        });
        if (widget.onUploadSuccess != null) {
          widget.onUploadSuccess!();
        }
      } else {
        setState(() {
          _uploadMessage = 'Erreur lors de l\'upload: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'Exception: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.attach_file),
          label: const Text('Sélectionner un fichier'),
          onPressed: _isUploading ? null : _pickFile,
        ),
        if (_selectedFile != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Fichier sélectionné : ${_selectedFile!.path.split('/').last}'),
          ),
        ElevatedButton.icon(
          icon: _isUploading ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.upload_file),
          label: Text(_isUploading ? 'Upload en cours...' : 'Uploader'),
          onPressed: _isUploading ? null : _uploadFile,
        ),
        if (_uploadMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              _uploadMessage!,
              style: TextStyle(
                color: _uploadMessage!.contains('succès') ? Colors.green : Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
