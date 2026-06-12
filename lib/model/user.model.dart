class UserModel {
  final String uid;
  final String nome;
  final String email;
  final int xp;
  final int nivel;
  final int moedas;

  UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.xp,
    required this.nivel,
    required this.moedas,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'xp': xp,
      'nivel': nivel,
      'moedas': moedas,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      nivel: (json['nivel'] as num?)?.toInt() ?? 0,
      moedas: (json['moedas'] as num?)?.toInt() ?? 0,
    );
  }
}
