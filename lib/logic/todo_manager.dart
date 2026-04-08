import '../models/tasks.dart';

class TodoManager {
  List<Tasks> _tasks = [];

  List<Tasks> get tasks {
    final lista = List<Tasks>.from(_tasks);
    lista.sort((a, b) {
      if (a.concluida != b.concluida) return a.concluida ? 1 : -1;
      final pA = a.prioridade;
      final pB = b.prioridade;
      if (pA != pB) return pA.compareTo(pB);
      return b.id.compareTo(a.id);
    });
    return lista;
  }

  int get total => _tasks.length;
  int get concluidas => _tasks.where((t) => t.concluida).length;
  int get pendentes => total - concluidas;
  double get pct => total == 0 ? 0.0 : concluidas / total;

  void carregar(List<Map<String, dynamic>> data) =>
      _tasks = data.map((t) => Tasks.fromJson(t)).toList();

  void adicionar(String titulo, String desc, int prioridade) {
    _tasks.add(Tasks(
      id: DateTime.now().millisecondsSinceEpoch,
      titulo: titulo,
      descricao: desc,
      prioridade: prioridade,
    ));
  }

  void alternarStatus(int id) {
    for (final t in _tasks) {
      if (t.id == id) t.concluida = !t.concluida;
    }
  }

  void excluir(int id) => _tasks.removeWhere((t) => t.id == id);

  void editar(int id, String novoT, String novaD, int novaP) {
    for (final t in _tasks) {
      if (t.id == id) {
        if (novoT.isNotEmpty) t.titulo = novoT;
        if (novaD.isNotEmpty) t.descricao = novaD;
        t.prioridade = novaP;
      }
    }
  }

  List<Map<String, dynamic>> exportarParaSalvar() {
    return _tasks.map((t) => t.toJson()).toList();
  }
}
