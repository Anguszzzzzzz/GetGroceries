import 'package:flutter/material.dart';
import 'package:checklist_app/util/colors.dart';

Widget circProgIndi ({double strokeWidth = 2, Color color = primaryGreen, double size = 48 }) =>
    Container(width: size, height: size,
        child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color,));