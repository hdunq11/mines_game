class RankModel {
  final int ave;
  final int best;
  final String email;
  final int games;
  final int rate;
  final int won;

  RankModel({
    required this.ave,
    required this.best,
    required this.email,
    required this.games,
    required this.rate,
    required this.won,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) {
    return RankModel(
      ave: json['ave'],
      best: json['best'],
      email: json['email'],
      games: json['games'],
      rate: json['rate'],
      won: json['won'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ave': ave,
      'best': best,
      'email': email,
      'games': games,
      'rate': rate,
      'won': won,
    };
  }
}