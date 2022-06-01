import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  String? label = "";
  TextInputType? textInputType = TextInputType.text;
  bool? isPassword = false;
  TextEditingController textEditingController;
  bool? textError = false;

  TextFieldComponent(
      {Key? key,
      required this.textEditingController,
      this.label,
      this.textInputType,
      this.isPassword,
      this.textError})
      : super(key: key);

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword ?? false,
      keyboardType: widget.textInputType,
      controller: widget.textEditingController,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: const OutlineInputBorder(),
          label: Text(
            widget.label ?? "",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          errorText: (widget.textError ?? false) ? "harap diisi" : null,
          errorBorder: (widget.textError ?? false)
              ? const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                )
              : null),
    );
  }
}
