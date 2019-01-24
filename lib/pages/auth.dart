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
  bool _acceptTerms=false;
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
                keyboardType:TextInputType.emailAddress,
                onChanged: (String value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                maxLines: 4,
                obscureText: true,
                keyboardType:TextInputType.text,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SwitchListTile(
                value: _acceptTerms, onChanged:(bool value){
                  setState(() {
                    _acceptTerms = value;
                  });
                },title:Text('accept terms'),),
              SizedBox(
                height: 25.0,
              ),
              RaisedButton(
                textColor: Colors.brown,
                color: Theme.of(context).primaryColorLight,
                child: Text('Save'),
                onPressed: () {
                  final Map<String, dynamic> userInfo = {
                    'name': userName,
                    'description': password,
                  };
                  print(userName+password);
                  print(userInfo.toString());
                  //widget.addProduct(product);
                  Navigator.pushReplacementNamed(context,
                      '/products'); // gives you no option of going back
                },
              )
            ],
          ),
        )


        );
  }
}

/* pushReplacementNamed: replace the route by pushing the route named routeName 
and then disposing the previous route once the new route has finished animating in.*/


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

// solution after AppBar
// ListView(
//   children: <Widget>[
//     TextField(),
//     RaisedButton(onPressed: ,)
//   ]
// )