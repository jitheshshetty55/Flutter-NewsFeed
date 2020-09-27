import 'package:flutter/material.dart';


class TopBar extends StatelessWidget{
  final double height;
  final Color shapeColor;

  TopBar({this.height,this.shapeColor});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        child: Container(
        height: this.height,
    ),
      painter: _TopBarPainter(this.shapeColor),
    );
  }

}


class _TopBarPainter extends CustomPainter{
  final Color _shapeColor;
  _TopBarPainter(this._shapeColor);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(size.width* 0.10, 0);
    path.quadraticBezierTo(
        size.width * 0.21, size.height*0.75, size.width * 0.7, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.95, size.height*0.7, size.width , size.height);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = _shapeColor;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}