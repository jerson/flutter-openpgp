import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    Key? key,
    required this.result,
    required this.title,
    this.subtitle,
    required Function(TextEditingController) this.onPressed,
  }) : super(key: key);

  final Function(TextEditingController) onPressed;
  final String title;
  final String? subtitle;
  final String result;

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final _controller = TextEditingController();
  FocusNode? _focusNode;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller.text = "";
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          if (widget.subtitle != null) Text(widget.subtitle!),
          TextField(
            autofocus: false,
            focusNode: _focusNode,
            decoration: InputDecoration(labelText: "Message"),
            controller: _controller,
            key: Key("message"),
          ),
          ElevatedButton(
            child: Text(widget.title),
            onPressed: () async {
              _focusNode!.unfocus();
              await widget.onPressed(_controller);
              setState(() {
                _loading = false;
              });
            },
            key: Key("button"),
          ),
          (_loading)
              ? Text(
                  widget.result,
                  key: Key("loading"),
                )
              : Text(
                  widget.result,
                  key: Key("result"),
                )
        ],
      ),
    );
  }
}
