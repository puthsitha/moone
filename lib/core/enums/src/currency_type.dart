enum CurrencyType {
  usd,
  khr;

  static CurrencyType fromMap(String value) {
    return CurrencyType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => CurrencyType.usd,
    );
  }
}
