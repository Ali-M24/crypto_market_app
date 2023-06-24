class Crypto {
  String id;
  String name;
  String symbol;
  double priceUsd;
  double changePercent24Hr;
  double marketCapUsd;
  int rank;

  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.priceUsd,
    this.changePercent24Hr,
    this.marketCapUsd,
    this.rank,
  );

  factory Crypto.fromMapJson(Map<String, dynamic> JsonMapObject) => Crypto(
        JsonMapObject['id'],
        JsonMapObject['name'],
        JsonMapObject['symbol'],
        double.parse(JsonMapObject['priceUsd']),
        double.parse(JsonMapObject['changePercent24Hr']),
        double.parse(JsonMapObject['marketCapUsd']),
        int.parse(JsonMapObject['rank']),
      );
}
