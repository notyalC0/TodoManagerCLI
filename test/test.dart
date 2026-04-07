import 'package:test/test.dart';
// Substitua pelo nome real do seu arquivo .dart
import '../main.dart';

void main() {
  group('Testes de TodoManager', () {
    late TodoManager manager;

    setUp(() {
      manager = TodoManager();
    });

    test('Deve adicionar uma nova tarefa', () {
      manager.adicionar('Título da Tarefa', 'Descrição da Tarefa');

      expect(manager.tarefas.length, equals(1));
      expect(manager.tarefas.first['titulo'], equals('Título da Tarefa'));
      expect(manager.tarefas.first['descricao'], equals('Descrição da Tarefa'));
      expect(manager.tarefas.first['concluida'], isFalse);
    });

    test('Deve listar todas as tarefas', () {
      manager.adicionar('Tarefa 1', 'Desc 1');
      manager.adicionar('Tarefa 2', 'Desc 2');

      expect(manager.tarefas.length, equals(2));
      expect(manager.tarefas[0]['titulo'], equals('Tarefa 1'));
      expect(manager.tarefas[1]['titulo'], equals('Tarefa 2'));
    });

    test('Deve editar uma tarefa existente', () {
      manager.adicionar('Título Antigo', 'Desc Antiga');
      int id = manager.tarefas.first['id'];

      manager.editar(id, 'Novo Título', 'Nova Desc');

      expect(manager.tarefas.first['titulo'], equals('Novo Título'));
      expect(manager.tarefas.first['descricao'], equals('Nova Desc'));
    });

    test('Deve excluir uma tarefa da lista', () {
      manager.adicionar('Tarefa para Morrer', 'Desc');
      int id = manager.tarefas.first['id'];

      manager.excluir(id);

      expect(manager.tarefas, isEmpty);
    });

    test('AlternarStatus deve inverter o valor booleano', () {
      manager.adicionar('Status Test', 'Desc');
      int id = manager.tarefas.first['id'];

      manager.alternarStatus(id); // De false para true
      expect(manager.tarefas.first['concluida'], isTrue);

      manager.alternarStatus(id); // De true para false
      expect(manager.tarefas.first['concluida'], isFalse);
    });
  });
}
