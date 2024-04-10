Classes

```
class Crossnumber<PuzzleKind extends Puzzle> {
    late PuzzleKind puzzle;
    static const bool traceInit = true;
    static const bool traceSolve = true;
    Crossnumber();
    void initCrossnumber();

    var updateQueue = <Clue>[];
    var priorityQueue = PriorityQueue<VariableClue>((a, b) => -b.count.compareTo(a.count));
    void addToUpdateQueue(Clue clue);
    Clue takeFromUpdateQueue();
    bool updateQueueIsNotEmpty();

    // solve here because of queue?
    void solve();
    bool solveClue(Clue clue);
    bool updateVariables(String variable, Set<int> possibleValues)
}

class Puzzle<ClueKind extends Clue> {
    late Map<String, ClueKind> clues;
    Grid? grid;
    void addClue(ClueKind clue);
    void addDigitIdentity(ClueKind clue1, int digit1, ClueKind clue2, int digit2);
    void addDigitIdentityFromGrid();
    void addReference(ClueKind clue1, ClueKind clue2, [bool symmetric = false]);
    String toString();
    String toSummary();

    // why logic here?
    List<int> knownValues = [];
    bool updateValues(ClueKind clue, Set<int> possibleValue);
    bool uniqueSolution();
    postProcessing();
    Map<Clue, Answer> solution = {};
    List<Clue> order = [];
    int iterate();
    int iterateValues();
    int findSolutions(List<Clue> order, int next, int count);
    bool checkSolution();
    bool clueValuesMatch(Clue clue, int value);
    String solutionToString();
}

class SolveException implements Exception;

class VariablePuzzle<ClueKind extends Clue, VariableKind extends Variable>
    extends Puzzle<ClueKind> {
    late final VariableList variableList;
    VariablePuzzle(List<int> possibleValues);
    VariablePuzzle.fromGridString(List<int> possibleValues, List<String> gridString);
    Map<String, Variable> get variables => variableList.variables;
    List<int> get remainingValues => variableList.remainingValues;
    Set<String> updateVariables(String variable, Set<int> possibleValues) =>
    variableList.updateVariables(variable, possibleValues);

    int getClueCount(VariableClue clue, List<List<int>> variableValues);
    void updateClueCount(VariableClue clue);
    void solveVariableExpression(VariableClue clue,Set<int> possibleValue,Map<String, Set<int>> possibleVariables,int expression(List<int> variables));
    bool solveVariableExpressionEvaluator(VariableClue clue,Set<int> possibleValue, Map<String, Set<int>> possibleVariables);
    int iterateVariables();
    String toString();
    String toSummary();
}

class Answer {
    List<int> possible;
    int? value;
    Answer(this.possible);
}

class Variable {
    final String name;
    late Set<int> \_values;
    int? \_value;
    Variable(this.name);
    tryValue(int value) => \_value = value;
    Set<int> get values => \_value != null ? {\_value!} : \_values;
    set values(Set<int> values) => \_values = values;
    String toString();
    bool updatePossible(Set<int> possibleValues);
    bool get isSet => this.values.length == 1;
}

class VariableList<VariableKind extends Variable> {
    final Map<String, VariableKind> variables = {};
    late final List<int> remainingValues;
    VariableList(this.remainingValues);
    Set<String> updateVariables(String variableName, Set<int> possibleValues);
    String toString();
    String toSummary();
}

class Clue {
    final String name;
    final int length;
    final String? valueDesc;
    late final List<DigitIdentity?> digitIdentities;
    late final List<Clue> referrers;
    final SolveFunction? solve;
    late final List<Set<int>> digits;
    Set<int>? \_values;
    int? \_tryValue;
    bool get isAcross => this.name[0] == 'A';
    bool get isDown => this.name[0] == 'D';
    set tryValue(int? value);
    Set<int>? get values => \_tryValue != null ? {\_tryValue!} : \_values;
    set values(Set<int>? values);
    Clue({required this.name,required this.length,this.valueDesc,this.solve,});
    void initDigits();
    addReferrer(Clue clue);
    bool initialise();
    bool finalise();
    bool updateValues(Set<int> possibleValue);
    bool digitsMatch(int value);
    String toString();
    String toSummary();
}

bool updatePossible(Set<int> possible, Set<int> possibleValues);

class VariableClue extends Clue {
    late final List<String> variableReferences;
    late ExpressionEvaluator exp;
    int count = 0;
    VariableClue({required String name, required int? length, String? valueDesc, SolveFunction? solve});
    addVariableReference(String variable);
}

class ClueReference {
    // The referenced clue
    final Clue clue;
    ClueReference({required this.clue});
    String toString();
}

class DigitIdentity {
    final Clue clue;
    final int digit;
    DigitIdentity({required this.clue,required this.digit,});
    String toString();
}
```
