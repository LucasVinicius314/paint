class VectorNode {
  VectorNode({
    required this.coordinates,
  });

  (double, double) coordinates;

  factory VectorNode.fromTuple((double, double) coordinates) {
    return VectorNode(coordinates: coordinates);
  }
}
