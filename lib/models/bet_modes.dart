class BetMode {
  final String name;
  final double multiplier;
  final int maxDigits;
  final bool isFullPrizeRequired;

  BetMode({
    required this.name,
    required this.multiplier,
    required this.maxDigits,
    required this.isFullPrizeRequired,
  });
}

class BetModes {
  static final group = BetMode(
      name: "Grupo",
      multiplier: 18.0,
      maxDigits: 2,
      isFullPrizeRequired: false);

  static final dozen = BetMode(
      name: "Dezena",
      multiplier: 60.0,
      maxDigits: 2,
      isFullPrizeRequired: false);

  static final hundred = BetMode(
      name: "Centena",
      multiplier: 600.0,
      maxDigits: 3,
      isFullPrizeRequired: false);

  static final thousand = BetMode(
      name: "Milhar",
      multiplier: 4000.0,
      maxDigits: 4,
      isFullPrizeRequired: false);

  static List<BetMode> get allModes => [
        group,
        dozen,
        hundred,
        thousand,
      ];
}
