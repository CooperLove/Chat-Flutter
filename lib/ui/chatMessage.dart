import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          !widget.mine
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage: widget.data["senderPhotoUrl"] != null
                        ? NetworkImage(widget.data["senderPhotoUrl"])
                        : NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE1lNuQFDKXF_-VkBuS-c_4fkyF8pCBjJef2D8F5zezUmvZ8XjVk4eeCGyT7I5aB3PDS4&usqp=CAU"),
                  ),
                )
              : Container(),
          Expanded(
              child: Column(
            crossAxisAlignment:
                widget.mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              widget.data["imgUrl"] != null
                  ? Image.network(
                      widget.data["imgUrl"],
                      width: 250,
                    )
                  : Text(widget.data["text"],
                      textAlign: widget.mine ? TextAlign.end : TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(
                widget.data["senderName"] ?? "Sem nome",
                style: TextStyle(fontSize: 10),
              )
            ],
          )),
          widget.mine
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundImage: widget.data["senderPhotoUrl"] != null
                        ? NetworkImage(widget.data["senderPhotoUrl"])
                        : NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE1lNuQFDKXF_-VkBuS-c_4fkyF8pCBjJef2D8F5zezUmvZ8XjVk4eeCGyT7I5aB3PDS4&usqp=CAU"),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
