import 'package:flutter/material.dart';
import './products.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Center(
          child: RaisedButton(
              child: Text('Log In'),
              onPressed: () {// pushReplacement -> pushReplacementnamed. change parameter to route
                Navigator.pushReplacementNamed(
                  context, '/',
                );
              }
          ),
        )
    );
  }
}
