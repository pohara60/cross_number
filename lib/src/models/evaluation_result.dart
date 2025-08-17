class EvaluationResult {
  final num value;
  final Map<String, int> variableValues;

  EvaluationResult(this.value, this.variableValues);
}

class EvaluationFinalResult {
  final int value;
  final Map<String, int> variableValues;

  EvaluationFinalResult(this.value, this.variableValues);
}
