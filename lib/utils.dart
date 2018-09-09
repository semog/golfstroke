int sum(List<int> list) {
  int accumulator = 0;
  list.forEach((x) => accumulator += x);
  return accumulator;
}

int totalMilliseconds(DateTime dt) => dt.difference(DateTime.fromMillisecondsSinceEpoch(0)).inMilliseconds;

String fmtHoleNum(int holeNum) {
  if (1 == holeNum) {
    return "1st";
  } else if (2 == holeNum) {
    return "2nd";
  } else if (3 == holeNum) {
    return "3rd";
  }
  return "${holeNum}th";
}
