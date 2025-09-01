import 'package:crossnumber/src/models/expressable.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';

class TransitiveExpressableGrouper {
  List<List<Expressable>> findGroups(PuzzleDefinition puzzle, bool trace) {
    final references = <String, Set<String>>{};
    final referencedBy = <String, Set<String>>{};

    // Populate references and referencedBy maps
    for (final expressable in puzzle.expressables.values) {
      references.putIfAbsent(expressable.id, () => <String>{});
      for (final variable in expressable.allVariables) {
        references[expressable.id]!.add(variable);
        referencedBy.putIfAbsent(variable, () => <String>{});
        referencedBy[variable]!.add(expressable.id);
      }
    }

    final groups = <List<Expressable>>[];
    final visited = <String>{};

    for (final expressable in puzzle.expressables.values) {
      if (!visited.contains(expressable.id)) {
        final group = <Expressable>[];
        final queue = [expressable];
        visited.add(expressable.id);

        var head = 0;
        while (head < queue.length) {
          final current = queue[head++];
          group.add(current);

          final toVisit = <String>{};
          if (references.containsKey(current.id)) {
            toVisit.addAll(references[current.id]!);
          }
          if (referencedBy.containsKey(current.id)) {
            toVisit.addAll(referencedBy[current.id]!);
          }

          for (final id in toVisit) {
            if (!visited.contains(id)) {
              visited.add(id);
              var newExpressable = puzzle.expressables[id];
              if (newExpressable != null) {
                queue.add(newExpressable);
              }
            }
          }
        }
        if (group.length > 1) groups.add(group);
      }
    }

    if (trace) {
      print('Found ${groups.length} expressable groups:');
      for (final group in groups) {
        print('  Group: ${group.map((e) => e.id).join(', ')}');
      }
    }

    return groups;
  }
}
