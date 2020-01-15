import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.hint,
    @required this.validator,
    @required this.onSaved,
    @required this.obscureText,
    this.onTap,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final String hint;
  final bool obscureText;
  final Function(String) validator;
  final Function(String) onSaved;
  final Function onTap;
  final String initialValue;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    TextInputType type;
    switch (label) {
      case "Email":
        type = TextInputType.emailAddress;
        break;
      case "Data di nascita":
        type = TextInputType.datetime;
        break;
      case "Data evento":
        type = TextInputType.datetime;
        break;
      case "Massimo numero partecipanti":
        type = TextInputType.number;
        break;
      default:
        type = TextInputType.text;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colori.grigio,
            shadows: [
              Shadow(
                color: Colori.grigio,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: this.controller,
          obscureText: label == "Password" ? true : false,
          readOnly: label == "Data di nascita" ? true : false,
          onTap: this.onTap,
          onSaved: onSaved,
          keyboardType: type,
          style: TextStyle(
            color: Colori.grigio,
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
                color: Colori.grigio,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colori.grigio,
              ),
            ),
            prefixIcon: Icon(icon, color: Colori.grigio),
            focusColor: Colori.grigio,
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
