import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final List<double> onTimeData;
  final List<double> lateData;
  final List<double> izinData;
  final String activeFilter;
  final String touchedCategory;
  final double maxY;

  ChartPainter({
    required this.onTimeData,
    required this.lateData,
    required this.izinData,
    required this.activeFilter,
    required this.maxY,
    required this.touchedCategory,
  });

  final double leftPadding = 40.0;
  final double bottomPadding = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (onTimeData.length < 2 || maxY <= 0) return;

    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;
    final double stepX = chartWidth / (onTimeData.length - 1);

    _drawYAxisLabels(canvas, size, chartHeight);

    _drawDataSeries(
        canvas, chartHeight, izinData, stepX, Colors.orange, 'Izin');
    _drawDataSeries(canvas, chartHeight, lateData, stepX, Colors.red, 'Late');
    _drawDataSeries(
        canvas, chartHeight, onTimeData, stepX, Colors.green, 'On Time');
  }

  void _drawDataSeries(Canvas canvas, double chartHeight, List<double> data,
      double stepX, Color color, String categoryName) {
    bool showValues = false;

    if (activeFilter != 'All') {
      if (activeFilter == categoryName) showValues = true;
    } else {
      if (touchedCategory == categoryName) showValues = true;
    }

    double opacity = 1.0;
    String currentFocus =
        (activeFilter != 'All') ? activeFilter : touchedCategory;

    if (currentFocus != 'None' && currentFocus != categoryName) {
      opacity = 0.1;
    }

    _drawSmoothLine(canvas, chartHeight, data, stepX, color, opacity);

    if (showValues) {
      for (int i = 0; i < data.length; i++) {
        _drawSingleValueLabel(canvas, chartHeight, stepX, data[i], i, color);
      }
    }
  }

  void _drawSingleValueLabel(Canvas canvas, double chartHeight, double stepX,
      double value, int index, Color color) {
    final double x = leftPadding + (index * stepX);
    final double y = chartHeight - (value / maxY * chartHeight);

    final Paint circleFill = Paint()..color = Colors.white;
    final Paint circleBorder = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(x, y), 4, circleFill);
    canvas.drawCircle(Offset(x, y), 4, circleBorder);

    final String text = value.toInt().toString();
    final textSpan = TextSpan(
        text: text,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold));
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();

    final double boxWidth = textPainter.width + 10;
    final double boxHeight = textPainter.height + 6;
    final double boxY = y - 10 - boxHeight;

    final RRect rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(x, boxY + boxHeight / 2),
          width: boxWidth,
          height: boxHeight),
      const Radius.circular(6),
    );

    final Paint boxPaint = Paint()..color = color;
    canvas.drawRRect(rect, boxPaint);

    textPainter.paint(canvas, Offset(x - textPainter.width / 2, boxY + 3));
  }

  void _drawYAxisLabels(Canvas canvas, Size size, double chartHeight) {
    final textStyle = TextStyle(color: Colors.grey[600], fontSize: 10);
    final List<int> labels = [0, (maxY / 2).round(), maxY.toInt()];

    for (var label in labels) {
      final textSpan = TextSpan(text: label.toString(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final double y = chartHeight - (label / maxY * chartHeight);

      textPainter.paint(canvas,
          Offset(leftPadding - textPainter.width - 10, y - textPainter.height / 2));

      if (label > 0) {
        final Paint gridPaint = Paint()
          ..color = Colors.grey.withOpacity(0.1)
          ..strokeWidth = 1;
        canvas.drawLine(
            Offset(leftPadding, y), Offset(size.width, y), gridPaint);
      }
    }
  }

  void _drawSmoothLine(Canvas canvas, double chartHeight, List<double> data,
      double stepX, Color color, double opacity) {
    final double strokeWidth = opacity == 1.0 ? 3.0 : 1.5;

    final Paint paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    double getY(double val) => chartHeight - (val / maxY * chartHeight);

    path.moveTo(leftPadding, getY(data[0]));

    for (int i = 0; i < data.length - 1; i++) {
      double x1 = leftPadding + (i * stepX);
      double y1 = getY(data[i]);
      double x2 = leftPadding + ((i + 1) * stepX);
      double y2 = getY(data[i + 1]);

      double controlX1 = x1 + stepX / 2;
      double controlY1 = y1;
      double controlX2 = x1 + stepX / 2;
      double controlY2 = y2;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, x2, y2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return true;
  }
}