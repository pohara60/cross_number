class EvaluationResult {
  final num value;
  final Map<String, int> variableValues;

  EvaluationResult(this.value, this.variableValues);

  @override
  String toString() {
    return 'EvaluationResult($value, $variableValues)';
  }
}

class EvaluationFinalResult {
  final int value;
  final Map<String, int> variableValues;

  EvaluationFinalResult(this.value, this.variableValues);

  @override
  String toString() {
    return 'EvaluationFinalResult($value, $variableValues)';
  }
}
