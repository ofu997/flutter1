import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget{
  final String price;

  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
      // print('price tag: $price.toString()');
      // print('title: $this.title');
      return Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                '\$$price',
                style: TextStyle(color: Colors.black),
              )
            );
  } 
}