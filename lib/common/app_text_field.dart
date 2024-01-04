import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppTextField extends StatefulWidget {
  final String? errorText;
  AppTextField({
    super.key,
    required TextEditingController Controller,
    String lableText = 'Enter your Lable',
    this.errorText,
    // required ,
    void Function(bool)? onTap,
    bool obscureText = false,
  })  : _lableText = lableText,
        _Controller = Controller,
        _obscureText = obscureText,
        _onTap = onTap;
  // final void Function(bool value)? onTap;
  final void Function(bool)? _onTap;
  final bool _obscureText;
  final TextEditingController _Controller;
  final String _lableText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    bool hasFocus = _focusNode.hasFocus;
    if (widget._onTap != null) {
      widget._onTap!(hasFocus);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget._obscureText,
      focusNode: _focusNode,
      validator: widget.errorText == null
          ? null
          : (value) {
              if (value!.isEmpty) {
                return widget.errorText;
              }
              return null;
            },
      controller: widget._Controller,
      decoration: InputDecoration(
        labelText: widget._lableText,
        labelStyle: const TextStyle(fontSize: 17),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: PallateColor.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300)),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: PallateColor.blue)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey.withOpacity(0.5)),
        ),
      ),
    );
  }
}
