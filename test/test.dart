import 'package:TodoListManagerCLI/logic/todo_manager.dart';
import 'package:test/test.dart';

void main() {
  group('Testes de TodoManager', () {
    late TodoManager manager;

    setUp(() {
      manager = TodoManager();
    });

    test('Deve adicionar uma nova tarefa com os dados corretos', () {
      manager.adicionar('Título da Tarefa', 'Descrição da Tarefa', 1);

      expect(manager.tasks.length, equals(1));
      expect(manager.tasks.first.titulo, equals('Título da Tarefa'));
      expect(manager.tasks.first.concluida, isFalse);
    });

    test('Deve calcular as estatísticas corretamente usando IDs manuais', () {
      // Injetamos dados com IDs diferentes para evitar conflito de milissegundos
      manager.carregar([
        {
          'id': 101,
          'titulo': 'T1',
          'descricao': '',
          'prioridade': 3,
          'concluida': false
        },
        {
          'id': 102,
          'titulo': 'T2',
          'descricao': '',
          'prioridade': 3,
          'concluida': false
        },
        {
          'id': 103,
          'titulo': 'T3',
          'descricao': '',
          'prioridade': 3,
          'concluida': false
        },
      ]);

      // Alterna o status apenas da tarefa com ID 101
      manager.alternarStatus(101);

      expect(manager.total, equals(3));
      expect(manager.concluidas, equals(1),
          reason: 'Apenas uma tarefa deveria estar concluída');
      expect(manager.pendentes, equals(2));
      expect(manager.pct, closeTo(0.33, 0.01));
    });

    test(
        'A lista deve ser ordenada por: Status > Prioridade > ID (Mais recente)',
        () {
      manager.carregar([
        {
          'id': 1,
          'titulo': 'Baixa Antiga',
          'prioridade': 3,
          'concluida': false
        },
        {'id': 2, 'titulo': 'Baixa Nova', 'prioridade': 3, 'concluida': false},
        {
          'id': 3,
          'titulo': 'Alta Urgência',
          'prioridade': 1,
          'concluida': false
        },
        {'id': 4, 'titulo': 'Já Concluída', 'prioridade': 1, 'concluida': true},
      ]);

      final lista = manager.tasks;

      // 1º Pendente + Prio Alta
      expect(lista[0].titulo, equals('Alta Urgência'));
      // 2º Pendente + Prio Baixa + ID maior (Nova)
      expect(lista[1].titulo, equals('Baixa Nova'));
      // 3º Pendente + Prio Baixa + ID menor (Antiga)
      expect(lista[2].titulo, equals('Baixa Antiga'));
      // 4º Concluída (Sempre por último)
      expect(lista[3].titulo, equals('Já Concluída'));
    });

    test('Deve editar uma tarefa mantendo a integridade do ID', () {
      manager.carregar([
        {
          'id': 500,
          'titulo': 'Original',
          'descricao': 'Desc',
          'prioridade': 2,
          'concluida': false
        }
      ]);

      manager.editar(500, 'Editado', 'Nova Desc', 1);

      final tarefa = manager.tasks.first;
      expect(tarefa.titulo, equals('Editado'));
      expect(tarefa.prioridade, equals(1));
      expect(tarefa.id, equals(500));
    });

    test('Deve remover uma tarefa da lista pelo ID único', () {
      manager.carregar([
        {
          'id': 999,
          'titulo': 'Deletar',
          'descricao': '',
          'prioridade': 3,
          'concluida': false
        },
        {
          'id': 888,
          'titulo': 'Ficar',
          'descricao': '',
          'prioridade': 3,
          'concluida': false
        },
      ]);

      manager.excluir(999);

      expect(manager.total, equals(1));
      expect(manager.tasks.first.id, equals(888));
      expect(manager.tasks.any((t) => t.id == 999), isFalse);
    });

    test('Deve alternar status de concluído para pendente corretamente', () {
      manager.carregar([
        {
          'id': 7,
          'titulo': 'Teste',
          'descricao': '',
          'prioridade': 3,
          'concluida': true
        }
      ]);

      manager.alternarStatus(7); // Deve virar false
      expect(manager.tasks.first.concluida, isFalse);

      manager.alternarStatus(7); // Deve virar true novamente
      expect(manager.tasks.first.concluida, isTrue);
    });
  });
}
