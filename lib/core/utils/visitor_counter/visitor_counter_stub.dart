const int kRealisticVisitorBaseline = 120;

int computeDynamicBaseline() {
  return kRealisticVisitorBaseline;
}

Future<int> getVisitorCountImpl() async {
  return kRealisticVisitorBaseline;
}

Future<int> incrementVisitorCountImpl() async {
  return kRealisticVisitorBaseline + 1;
}

void syncVisitorCountLocal(int newCount) {}
