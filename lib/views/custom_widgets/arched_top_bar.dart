import 'package:flutter/material.dart';


class ArchedTopBar extends StatelessWidget{
  final double height;
  final Color shapeColor;

  ArchedTopBar({this.height,this.shapeColor});
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

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.5, size.height*0.5, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    paint.color = _shapeColor;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}