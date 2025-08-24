enum LotteryType {
  mega('Mega-Sena', 60, 6, 'megasena'),
  loto('Lotofácil', 25, 15, 'lotofacil'),
  mania('Lotomania', 100, 50, 'lotomania');

  const LotteryType(this.displayName, this.maxNumber, this.quantity, this.apiKey);

  final String displayName;
  final int maxNumber;
  final int quantity;
  final String apiKey;
}
