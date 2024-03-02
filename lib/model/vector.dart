import 'package:flutter/material.dart';
import 'package:paint/enums/vector_polygon_mode.dart';
import 'package:paint/model/vector_node.dart';

class Vector {
  Vector({
    required this.color,
    required this.nodes,
    required this.vectorPolygonMode,
  });

  Color color;
  List<VectorNode> nodes;
  VectorPolygonMode vectorPolygonMode;
}
