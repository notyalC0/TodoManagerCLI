class Tasks {
  final int id;
  String titulo;
  String descricao;
  int prioridade;
  bool concluida;
  DateTime dataCriacao;

  Tasks({
    required this.id,
    required this.titulo,
    this.descricao = '',
    this.prioridade = 3,
    this.concluida = false,
    DateTime? dataCriacao,
  }) : this.dataCriacao = dataCriacao ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'concluida': concluida,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      prioridade: json['prioridade'],
      concluida: json['concluida'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
    );
  }
}
