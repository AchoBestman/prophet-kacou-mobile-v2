class Concordance {
  final int id;
  final int numPred;
  final int numVerset;
  final String concordance;

  Concordance({
    required this.id,
    required this.numPred,
    required this.numVerset,
    required this.concordance,
  });

  factory Concordance.fromMap(Map<String, dynamic> map) {
    return Concordance(
      id: map['id'],
      numPred: map['num_pred'],
      numVerset: map['num_verset'],
      concordance: map['concordance'],
    );
  }
}
