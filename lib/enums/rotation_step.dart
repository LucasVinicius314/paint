enum RotationStep {
  n1,
  n10,
  n15,
  n30,
  n60,
  n90,
  n180,
}

extension RotationStepToDouble on RotationStep {
  double toDouble() {
    return ({
              RotationStep.n1: 1,
              RotationStep.n10: 10,
              RotationStep.n15: 15,
              RotationStep.n30: 30,
              RotationStep.n60: 60,
              RotationStep.n90: 90,
              RotationStep.n180: 180,
            }[this] ??
            0)
        .toDouble();
  }
}
