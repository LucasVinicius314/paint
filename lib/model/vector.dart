import 'package:flutter/material.dart';
import 'package:paint/model/vector_node.dart';

class Vector {
  Vector({
    required this.color,
    required this.nodes,
  });

  Color color;
  List<VectorNode> nodes;
}
