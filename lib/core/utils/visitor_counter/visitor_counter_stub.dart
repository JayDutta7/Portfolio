int computeDynamicBaseline() {
  final startDate = DateTime(2024, 1, 1);
  final now = DateTime.now();
  final days = now.difference(startDate).inDays;
  final hour = now.hour;
  return 3820 + (days * 3) + (hour ~/ 2);
}

Future<int> getVisitorCountImpl() async {
  return computeDynamicBaseline();
}

Future<int> incrementVisitorCountImpl() async {
  return computeDynamicBaseline() + 1;
}
