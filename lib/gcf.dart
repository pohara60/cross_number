import 'dart:math';

import 'package:crossnumber/monadic.dart';

var cacheGCFs = <(int, int), int>{};
var cacheFactors = <List<int>>[];

void initGCFs() {
  cacheFactors.add([]);
  // Hard coded maximum entry of 99999
  for (var i = 1; i < 10000; i++) {
    var list1 = List<int>.from(factors(i));
    cacheFactors.add(list1);
    for (var j = 1; j < i; j++) {
      var list2 = cacheFactors[j];
      var common = intersection(list1, list2);

      cacheGCFs[(i, j)] = common.isEmpty
          ? 1
          : common.reduce((value, element) => value * element);
    }
    cacheGCFs[(i, i)] = i;
  }
}

int getGCF(int v1, int v2) {
  if (cacheFactors.isEmpty) initGCFs();
  var c1 = v1 >= v2 ? v1 : v2;
  var c2 = v1 >= v2 ? v2 : v1;
  return cacheGCFs[(c1, c2)]!;
}

List<int> intersection(List<int> list1, List<int> list2) {
  var i1 = 0;
  var i2 = 0;
  var result = <int>[];
  while (i1 < list1.length && i2 < list2.length) {
    if (list1[i1] == list2[i2]) {
      result.add(list1[i1]);
      i1++;
      i2++;
    } else if (list1[i1] < list2[i2]) {
      i1++;
    } else // (list1[i1] > list2[i2])
    {
      i2++;
    }
  }
  return result;
}

bool checkGCFs(int value, Set<int>? s1, Set<int>? s2) {
  if (s1 == null || s2 == null) return true;
  var m1 = s1.reduce(max);
  var m2 = s2.reduce(max);
  if (value > m1 || value > m2) return false;
  if (cacheFactors.isEmpty) initGCFs();
  for (var v1 in s1.where((element) => element >= value)) {
    for (var v2 in s2.where((element) => element >= value)) {
      if (getGCF(v1, v2) == value) {
        return true;
      }
    }
  }
  return false;
}

bool checkFactors(int value, Set<int>? s1) {
  if (cacheFactors.isEmpty) initGCFs();
  if (s1 == null) return true;
  for (var v1 in s1) {
    var c1 = v1 >= value ? v1 : value;
    var c2 = v1 >= value ? value : v1;
    var gcf = cacheGCFs[(c1, c2)];
    if (gcf == 1 || gcf == value) return false;
  }
  return true;
}
