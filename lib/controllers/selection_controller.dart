import 'package:flutter/material.dart';
import 'package:paint/model/selection_data.dart';
import 'package:paint/model/vector_node.dart';

class SelectionController extends ChangeNotifier {
  var selectedNodes = <VectorNode>[];
  SelectionData? selectionData;

  void setSelectionData(SelectionData? newSelectionData) {
    selectionData = newSelectionData;

    notifyListeners();
  }

  void setSelectedNodes(List<VectorNode> nodes) {
    selectedNodes = nodes;

    notifyListeners();
  }
}
