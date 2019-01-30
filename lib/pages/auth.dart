import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}



class _AuthPage extends State<AuthPage> {
  String userName;
  String password;
  bool _acceptTerms = false;

  DecorationImage _buildBackgroundImage(){
  return DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.09), BlendMode.dstATop),
              fit: BoxFit.fill,
              image: AssetImage('assets/background.jpg'),
            );
  }

Widget _buildEmailTextfield(){
  return  TextField(
                decoration: InputDecoration(labelText: 'User Name', filled: true, fillColor: Colors.white),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  setState(() {
                    userName = value;
                  });
                },
              );
  }

  Widget _buildPassword(){
  return  TextField(
                decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white),
                maxLines: 4,
                obscureText: true,
                keyboardType: TextInputType.text,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              );
}

Widget _buildSwitch(){
  return  SwitchListTile(
                value: _acceptTerms,
                onChanged: (bool value) {
                  setState(() {
                    _acceptTerms = value;
                  });
                },
                title: Text('accept terms'),
              );
}

void _submitForm(){

                  final Map<String, dynamic> userInfo = {
                    'name': userName,
                    'description': password,
                  };
                  print(userName + password);
                  print(userInfo.toString());
                  //widget.addProduct(product);
                  Navigator.pushReplacementNamed(context,
                      '/products'); // gives you no option of going back
}

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth *0.95;
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column( 
                  children: <Widget>[
                    _buildEmailTextfield(),
                    SizedBox(
                      height: 11.0
                    ),
                    _buildPassword(),
                    _buildSwitch(),
                    SizedBox(
                      height: 25.0,
                    ),
                    RaisedButton (
                      textColor: Colors.brown,
                      color: Theme.of(context).primaryColorLight,
                      child: Text('submit'),
                      onPressed: _submitForm,
                    )
                  ],
                ),
              )
            )
          ),
        )
      );
  }
}

/* pushReplacementNamed: replace the route by pushing the route named routeName 
and then disposing the previous route once the new route has finished animating in.*/

