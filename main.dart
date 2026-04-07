import 'dart:io';
import 'dart:convert';

// --- CORES ANSI ---
abstract class Cores {
  static const reset = '\x1B[0m';
  static const vermelho = '\x1B[31m';
  static const verde = '\x1B[32m';
  static const amarelo = '\x1B[33m';
  static const azul = '\x1B[34m';
  static const magenta = '\x1B[35m';
  static const ciano = '\x1B[36m';
  static const branco = '\x1B[37m';
  static const negrito = '\x1B[1m';
  static const dimmed = '\x1B[2m';
}

// --- CONSTANTES VISUAIS ---
final _sep = '─' * 44;
final _sepTop = '┌${'─' * 44}┐';
final _sepMid = '├${'─' * 44}┤';
final _sepBot = '└${'─' * 44}┘';

// --- MODELO ---
class TodoManager {
  List<Map<String, dynamic>> _tarefas = [];
  List<Map<String, dynamic>> get tarefas => _tarefas;

  int get total => _tarefas.length;
  int get concluidas => _tarefas.where((t) => t['concluida'] == true).length;
  int get pendentes => total - concluidas;

  void carregar(List<Map<String, dynamic>> data) => _tarefas = data;

  void adicionar(String titulo, String descricao) {
    _tarefas.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'titulo': titulo,
      'descricao': descricao,
      'concluida': false,
    });
  }

  bool editar(int id, String titulo, String descricao) {
    for (var t in _tarefas) {
      if (t['id'] == id) {
        if (titulo.isNotEmpty) t['titulo'] = titulo;
        if (descricao.isNotEmpty) t['descricao'] = descricao;
        return true;
      }
    }
    return false;
  }

  bool alternarStatus(int id) {
    for (var t in _tarefas) {
      if (t['id'] == id) {
        t['concluida'] = !t['concluida'];
        return true;
      }
    }
    return false;
  }

  bool excluir(int id) {
    final antes = _tarefas.length;
    _tarefas.removeWhere((t) => t['id'] == id);
    return _tarefas.length < antes;
  }
}

// --- MAIN ---
void main() {
  int? opcao;
  final manager = TodoManager();
  manager.carregar(carregarArquivo());

  while (opcao != 0) {
    _limparTela();
    _printHeader(manager);

    print(
        '  ${Cores.verde}${Cores.negrito}[ 1 ]${Cores.reset}  Adicionar Tarefa');
    print(
        '  ${Cores.ciano}${Cores.negrito}[ 2 ]${Cores.reset}  Listar / Alternar Status');
    print(
        '  ${Cores.amarelo}${Cores.negrito}[ 3 ]${Cores.reset}  Editar Tarefa');
    print(
        '  ${Cores.vermelho}${Cores.negrito}[ 4 ]${Cores.reset}  Excluir Tarefa');
    print('  ${Cores.dimmed}[ 0 ]  Sair${Cores.reset}');
    print('\n  ${Cores.dimmed}$_sep${Cores.reset}');

    stdout.write('\n  ${Cores.negrito}Escolha uma opção:${Cores.reset} ');
    opcao = int.tryParse(stdin.readLineSync() ?? '');

    switch (opcao) {
      case 1:
        _menuAdicionar(manager);
        break;
      case 2:
        _menuListar(manager);
        break;
      case 3:
        _menuEditar(manager);
        break;
      case 4:
        _menuExcluir(manager);
        break;
      case 0:
        print('\n  ${Cores.amarelo}Salvando... Até logo!${Cores.reset}\n');
        salvarArquivo(manager.tarefas);
        break;
      default:
        _printErro('Opção inválida. Tente novamente.');
        _pausar();
    }
  }
}

// --- HEADER ---
void _printHeader(TodoManager m) {
  print('');
  print(
      '  ${Cores.ciano}${Cores.negrito}╔══════════════════════════════════════════╗${Cores.reset}');
  print(
      '  ${Cores.ciano}${Cores.negrito}║       GERENCIADOR DE TAREFAS  CLI        ║${Cores.reset}');
  print(
      '  ${Cores.ciano}${Cores.negrito}╚══════════════════════════════════════════╝${Cores.reset}');
  print('');

  if (m.total > 0) {
    final barraTotal = 20;
    final barraFeita = ((m.concluidas / m.total) * barraTotal).round();
    final barraRestante = barraTotal - barraFeita;
    final barra =
        '${Cores.verde}${'█' * barraFeita}${Cores.reset}${Cores.dimmed}${'░' * barraRestante}${Cores.reset}';

    print(
        '  $barra  ${Cores.dimmed}${m.concluidas}/${m.total} concluídas  ·  ${Cores.amarelo}${m.pendentes} pendente(s)${Cores.reset}');
  } else {
    print('  ${Cores.dimmed}Nenhuma tarefa cadastrada ainda.${Cores.reset}');
  }

  print('  ${Cores.dimmed}$_sep${Cores.reset}\n');
}

// --- MENUS ---
void _menuAdicionar(TodoManager manager) {
  _limparTela();
  _printSecao('ADICIONAR TAREFA', Cores.verde);

  stdout.write('  Título    : ');
  final titulo = stdin.readLineSync() ?? '';

  stdout.write('  Descrição : ');
  final desc = stdin.readLineSync() ?? '';

  if (titulo.trim().isEmpty) {
    _printErro('O título não pode ser vazio!');
  } else {
    manager.adicionar(titulo.trim(), desc.trim());
    salvarArquivo(manager.tarefas);
    _printSucesso('Tarefa adicionada com sucesso!');
  }
  _pausar();
}

void _menuListar(TodoManager manager) {
  _limparTela();
  _printSecao('LISTAR / ALTERNAR STATUS', Cores.ciano);
  _exibirLista(manager.tarefas);

  if (manager.tarefas.isEmpty) {
    _pausar();
    return;
  }

  stdout.write(
      '  Número para alternar status ou ${Cores.vermelho}[0]${Cores.reset} para voltar: ');
  final index = int.tryParse(stdin.readLineSync() ?? '');

  if (index == null || index == 0) return;

  if (index > 0 && index <= manager.tarefas.length) {
    final id = manager.tarefas[index - 1]['id'];
    manager.alternarStatus(id);
    salvarArquivo(manager.tarefas);
    final nova =
        manager.tarefas[index - 1]['concluida'] ? 'CONCLUÍDA' : 'PENDENTE';
    _printSucesso('Status atualizado para $nova!');
    _pausar();
  } else {
    _printErro('Número fora do intervalo.');
    _pausar();
  }
}

void _menuEditar(TodoManager manager) {
  _limparTela();
  _printSecao('EDITAR TAREFA', Cores.amarelo);
  _exibirLista(manager.tarefas);

  if (manager.tarefas.isEmpty) {
    _pausar();
    return;
  }

  stdout.write('  Número da tarefa para editar: ');
  final index = int.tryParse(stdin.readLineSync() ?? '');

  if (index == null || index < 1 || index > manager.tarefas.length) {
    _printErro('Número inválido.');
    _pausar();
    return;
  }

  final id = manager.tarefas[index - 1]['id'];
  final atual = manager.tarefas[index - 1];

  print(
      '  ${Cores.dimmed}Deixe vazio para manter o valor atual.${Cores.reset}\n');
  stdout.write(
      '  Novo título    (${Cores.dimmed}${atual['titulo']}${Cores.reset}): ');
  final titulo = stdin.readLineSync() ?? '';

  stdout.write(
      '  Nova descrição (${Cores.dimmed}${atual['descricao']}${Cores.reset}): ');
  final desc = stdin.readLineSync() ?? '';

  manager.editar(id, titulo, desc);
  salvarArquivo(manager.tarefas);
  _printSucesso('Tarefa atualizada!');
  _pausar();
}

void _menuExcluir(TodoManager manager) {
  _limparTela();
  _printSecao('EXCLUIR TAREFA', Cores.vermelho);
  _exibirLista(manager.tarefas);

  if (manager.tarefas.isEmpty) {
    _pausar();
    return;
  }

  stdout.write(
      '  ${Cores.vermelho}Número para excluir${Cores.reset} (ou 0 para cancelar): ');
  final index = int.tryParse(stdin.readLineSync() ?? '');

  if (index == null || index == 0) return;

  if (index < 1 || index > manager.tarefas.length) {
    _printErro('Número inválido.');
    _pausar();
    return;
  }

  final tarefa = manager.tarefas[index - 1];
  stdout.write(
      '  ${Cores.vermelho}Confirmar exclusão de "${tarefa['titulo']}"? (s/N):${Cores.reset} ');
  final confirm = (stdin.readLineSync() ?? '').toLowerCase();

  if (confirm == 's') {
    manager.excluir(tarefa['id']);
    salvarArquivo(manager.tarefas);
    _printSucesso('Tarefa excluída.');
  } else {
    print('  ${Cores.dimmed}Operação cancelada.${Cores.reset}');
  }
  _pausar();
}

// --- LISTA FORMATADA ---
void _exibirLista(List<Map<String, dynamic>> tasks) {
  if (tasks.isEmpty) {
    print('  ${Cores.amarelo}Sua lista está vazia.${Cores.reset}\n');
    return;
  }

  print('  $_sepTop');
  for (var i = 0; i < tasks.length; i++) {
    final t = tasks[i];
    final num = '${Cores.magenta}${Cores.negrito}[${i + 1}]${Cores.reset}';
    final done = t['concluida'] as bool;
    final icon = done
        ? '${Cores.verde}✔${Cores.reset}'
        : '${Cores.dimmed}○${Cores.reset}';
    final status = done
        ? '${Cores.verde}CONCLUÍDA${Cores.reset}'
        : '${Cores.amarelo}PENDENTE ${Cores.reset}';
    final titulo = '${Cores.negrito}${t['titulo']}${Cores.reset}';

    print('  │  $num  $icon $status  $titulo');

    if (t['descricao'].toString().isNotEmpty) {
      print('  │       ${Cores.dimmed}└─ ${t['descricao']}${Cores.reset}');
    }

    if (i < tasks.length - 1) print('  $_sepMid');
  }
  print('  $_sepBot\n');
}

// --- UTILITÁRIOS VISUAIS ---
void _printSecao(String titulo, String cor) {
  print('$cor${Cores.negrito}  ┌─ $titulo${Cores.reset}');
  print('  ${Cores.dimmed}$_sep${Cores.reset}\n');
}

void _printSucesso(String msg) {
  print('\n  ${Cores.verde}${Cores.negrito}✔ $msg${Cores.reset}');
}

void _printErro(String msg) {
  print('\n  ${Cores.vermelho}${Cores.negrito}✖ Erro: $msg${Cores.reset}');
}

void _limparTela() {
  print(Process.runSync(
    Platform.isWindows ? 'cls' : 'clear',
    [],
    runInShell: true,
  ).stdout);
}

void _pausar() {
  stdout.write(
      '\n  ${Cores.dimmed}Pressione Enter para continuar...${Cores.reset}');
  stdin.readLineSync();
}

// --- PERSISTÊNCIA ---
void salvarArquivo(List<Map<String, dynamic>> tasks) {
  File('tarefas.json').writeAsStringSync(jsonEncode(tasks));
}

List<Map<String, dynamic>> carregarArquivo() {
  final arquivo = File('tarefas.json');
  if (!arquivo.existsSync()) return [];
  try {
    return List<Map<String, dynamic>>.from(
        jsonDecode(arquivo.readAsStringSync()));
  } catch (_) {
    return [];
  }
}
