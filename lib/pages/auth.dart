import 'package:flutter/material.dart';
// import './products.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  String userName;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'User Name'),
                onChanged: (String value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                maxLines: 4,
                keyboardType:TextInputType.text,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColorLight,
                child: Text('Save'),
                onPressed: () {
                  final Map<String, dynamic> userInfo = {
                    'name': userName,
                    'description': password,
                  };
                  print(userInfo.toString());
                  //widget.addProduct(product);
                  Navigator.pushReplacementNamed(context,
                      '/products'); // gives you no option of going back
                },
              )
            ],
          ),
        )
        //  Center(
        //   child: RaisedButton(
        //       child: Text('Log In'),
        //       onPressed: () {// pushReplacement -> pushReplacementNamed. change parameter to route
        //         Navigator.pushReplacementNamed(
        //           context, '/',
        //         );
        //       }
        //   ),
        // ),

        );
  }
}

/* pushReplacementNamed: replace the route by pushing the route named routeName 
and then disposing the previous route once the new route has finished animating in.*/
