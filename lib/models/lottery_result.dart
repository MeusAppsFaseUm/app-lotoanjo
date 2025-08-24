class LotteryResult {
  final String concurso;
  final String data;
  final List<String> dezenas;
  final String loteria;

  LotteryResult({
    required this.concurso,
    required this.data,
    required this.dezenas,
    required this.loteria,
  });

  factory LotteryResult.fromJson(Map<String, dynamic> json) {
    return LotteryResult(
      concurso: json['concurso'].toString(),
      data: json['data'].toString(),
      dezenas: List<String>.from(json['dezenas'] ?? []),
      loteria: json['loteria']?.toString() ?? '',
    );
  }
}
