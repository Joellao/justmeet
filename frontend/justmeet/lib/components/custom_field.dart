import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.hint,
    @required this.validator,
    @required this.onSaved,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final String hint;
  final Function(String) validator;
  final Function(String) onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.white54,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          onSaved: onSaved,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            prefixIcon: Icon(icon, color: Colors.white),
            focusColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}
