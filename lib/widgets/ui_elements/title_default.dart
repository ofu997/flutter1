import 'package:flutter_web/material.dart';
class TitleDefault extends StatelessWidget{
  final String title;

  TitleDefault(this.title);
  @override
  Widget build(BuildContext context) {
    final deviceWidth=MediaQuery.of(context).size.width;
    return Text(
      title,
      softWrap: true,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: deviceWidth>700?
          22.0
          :16.0,
        fontWeight: FontWeight.w100,
        fontFamily: 'NotoSans'
      ), //
    );
  }
}
