import "package:flutter/material.dart";

class Product{
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  //final String dateTime;

  Product(
    {@required this.id,
    @required this.title, 
    @required this.description, 
    @required this.price, 
    @required this.image,
    @required this.userEmail,
    @required this.userId,
    //@required this.dateTime,
    this.isFavorite = false}
  );
}