import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  const ImageInput({
    Key? key,
    required this.onSelectImage,
  }) : super(key: key);

  final Function onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final saveImage = await _storedImage!.copy('${appDir.path}/$fileName');
    await widget.onSelectImage(saveImage);
  }

  Future<void> _pickPicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final saveImage = await _storedImage!.copy('${appDir.path}/$fileName');
    await widget.onSelectImage(saveImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text('No Image Taken', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              showBottomSheet(
                enableDrag: true,
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _takePicture.call();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.camera),
                          label: const Text('from camera'),
                          style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _pickPicture.call();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.photo),
                          label: const Text('from gallery'),
                          style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.image),
            label: const Text('add Image'),
            style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
