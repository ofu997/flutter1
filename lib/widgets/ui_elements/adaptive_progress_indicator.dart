import 'package:flutter_web/material.dart';
import 'package:flutter_web/cupertino.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }
}