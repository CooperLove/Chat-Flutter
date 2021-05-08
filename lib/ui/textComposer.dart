import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo),
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                final PickedFile imgFile =
                    await picker.getImage(source: ImageSource.gallery);

                if (imgFile == null) return;
                File file = File(imgFile.path);
                bool fileExist = file.existsSync();
                if (!fileExist) return;
                widget.sendMessage(imgFile: file);
              }),
          Expanded(
              child: TextField(
            controller: controller,
            decoration:
                InputDecoration.collapsed(hintText: "Escreva uma mensagem"),
            onSubmitted: (text) {
              widget.sendMessage(text: text);
              setState(() {
                controller.clear();
              });
            },
            onChanged: (text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
          )),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () {
                      widget.sendMessage(text: controller.text);
                      setState(() {
                        controller.clear();
                      });
                    }
                  : null)
        ],
      ),
    );
  }
}
