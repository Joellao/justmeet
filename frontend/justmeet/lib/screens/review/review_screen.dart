import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/creates/ReviewCreate.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/review.dart';
import 'package:justmeet/components/widgets/review_widget.dart';
import 'package:justmeet/components/widgets/star_rating.dart';
import 'package:justmeet/controller/EventController.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final Event event;

  const ReviewScreen({Key key, this.event}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  String _body;
  int _stars;

  Future<LinkedHashMap<String, dynamic>> _createReview() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      ReviewCreate create =
          new ReviewCreate(body: this._body, stars: this._stars);
      return await Provider.of<EventController>(context, listen: false)
          .reviewEvent(token, this.widget.event.id, create);
    }
    return null;
  }

  bool refresh;

  add(value, review) {
    print(this.widget.event.reviews);
    this.widget.event.reviews.add(review);
    setState(() {
      refresh = value;
    });
  }

  remove(value, index) {
    print(this.widget.event.reviews.length);
    this.widget.event.reviews.removeAt(index);
    setState(() {
      refresh = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.event.name),
        backgroundColor: Colori.bluScuro,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colori.bluScuro,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormField<int>(
                        initialValue: 1,
                        autovalidate: true,
                        builder: (state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StarRating(
                                onChanged: state.didChange,
                                value: state.value,
                              ),
                            ],
                          );
                        },
                        validator: (value) =>
                            value < 1 ? 'Voto troppo basso' : null,
                        onSaved: (value) => this._stars = value,
                      ),
                      CustomField(
                        icon: Icons.comment,
                        label: '',
                        hint: "Aggiungi recensione",
                        validator: (name) => name.length <= 0
                            ? 'La recensione non può essere vuota'
                            : null,
                        onSaved: (name) => this._body = name,
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    LinkedHashMap<String, dynamic> rev = await _createReview();
                    add(true, rev);
                  },
                  child: Icon(
                    Icons.send,
                    color: Colori.grigio,
                    size: 40,
                  ),
                ),
                Column(
                  children:
                      List.generate(this.widget.event.reviews.length, (index) {
                    Review r = Review.fromJson(
                        this.widget.event.reviews.elementAt(index));
                    return ReviewWidget(
                      review: r,
                      func: remove,
                      index: index,
                    );
                  }),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
