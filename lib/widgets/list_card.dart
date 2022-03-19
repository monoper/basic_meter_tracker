import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  const ListCard({Key? key, required this.cardContent, this.cardElevation = 5})
      : super(key: key);
  final Widget cardContent;
  final double cardElevation;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: cardElevation,
        child: Material(type: MaterialType.transparency, child: cardContent));
  }
}
