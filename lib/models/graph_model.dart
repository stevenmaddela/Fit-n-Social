import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/utilities/graphData.dart';
import 'package:google_fonts/google_fonts.dart';

class Graph extends StatelessWidget {
  final double height;
  final List<GraphData> values;
  final AnimationController animationController;

  Graph({this.animationController, this.height = 120, this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildBars(values),

      ),
    );
  }

  _buildBars(List<GraphData> values) {
    List<GraphBar> _bars = List();
    GraphData _maxGraphData = values.reduce(
            (current, next) => (next.compareTo(current) >= 1) ? next : current);
    values.forEach((graphData) {
      double percentage = graphData.value / _maxGraphData.value;
      _bars.add(GraphBar(height, percentage, animationController, graphData.label));
    });

    return _bars;
  }
}

class GraphBar extends StatefulWidget {
  final double height, percentage;
  final String value;
  final AnimationController _graphBarAnimationController;

  GraphBar(this.height, this.percentage, this._graphBarAnimationController, this.value);

  @override
  _GraphBarState createState() => _GraphBarState(value);
}

class _GraphBarState extends State<GraphBar> {
  Animation<double> _percentageAnimation;
  final String value;

  _GraphBarState(this.value);

  @override
  void initState() {
    super.initState();
    _percentageAnimation = Tween<double>(begin: 0, end: widget.percentage)
        .animate(widget._graphBarAnimationController);
    _percentageAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: BarPainter(_percentageAnimation.value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text(value,
            style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize:
                MediaQuery.of(context).size.width / 30),
          ),
        ),
      ],
    );
  }
}

class BarPainter extends CustomPainter {
  final double percentage;

  BarPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint greyPaint = Paint()
      ..color = Color(0xFFE6E6E6)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    Offset topPoint = Offset(0, 0);
    Offset bottomPoint = Offset(0, (size.height + 20));
    Offset centerPoint = Offset(0, (size.height + 20) / 2);

    canvas.drawLine(topPoint, bottomPoint, greyPaint);

    Paint filledPaint = Paint()
      ..shader = LinearGradient(
          colors: [Colors.pinkAccent, Colors.pink, Colors.purple.shade600],
          begin: Alignment.topCenter
      ).createShader(Rect.fromPoints(topPoint, bottomPoint))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    double filledHeight = percentage * size.height;
    double filledHalfHeight = filledHeight / 2;

    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy - filledHalfHeight), filledPaint);
    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy + filledHalfHeight), filledPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}