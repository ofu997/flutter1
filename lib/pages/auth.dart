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
              onPressed: () {// pushReplacement -> pushReplacementNamed. change parameter to route
                Navigator.pushReplacementNamed(
                  context, '/',
                );
              }
          ),
        )
    );
  }
}

/* pushReplacementNamed: replace the route by pushing the route named routeName 
and then disposing the previous route once the new route has finished animating in.*/