import 'dart:io';
import 'dart:convert';
import 'package:dart_console/dart_console.dart';

abstract class T { // theme
  static const r  = '\x1B[0m';         // reset
  static const b  = '\x1B[1m';         // bold
  static const d  = '\x1B[2m';         // dimmed

  static const fg0 = '\x1B[38;2;205;214;244m'; // branco suave  #CDD6F4
  static const fg1 = '\x1B[38;2;90;96;128m';   // cinza médio
  static const fg2 = '\x1B[38;2;61;65;102m';   // cinza escuro

  static const acc  = '\x1B[38;2;199;146;234m'; // roxo  #C792EA
  static const grn  = '\x1B[38;2;195;232;141m'; // verde #C3E88D
  static const yel  = '\x1B[38;2;255;203;107m'; // âmbar #FFCB6B
  static const red  = '\x1B[38;2;240;113;120m'; // coral #F07178
  static const cyn  = '\x1B[38;2;137;221;255m'; // ciano #89DDFF

  static const bgSel  = '\x1B[48;2;30;34;53m';  // linha selecionada
  static const bgDark = '\x1B[48;2;13;14;20m';  // fundo total #0D0E14
}

class TodoManager {
  List<Map<String, dynamic>> _raw = [];

  List<Map<String, dynamic>> get tarefas {
    final lista = List<Map<String, dynamic>>.from(_raw);
    lista.sort((a, b) {
      if (a['concluida'] != b['concluida']) return a['concluida'] ? 1 : -1;
      final pA = (a['prioridade'] as int?) ?? 3;
      final pB = (b['prioridade'] as int?) ?? 3;
      if (pA != pB) return pA.compareTo(pB);
      return (b['id'] as int).compareTo(a['id'] as int);
    });
    return lista;
  }

  int get total      => _raw.length;
  int get concluidas => _raw.where((t) => t['concluida'] == true).length;
  int get pendentes  => total - concluidas;
  double get pct     => total == 0 ? 0.0 : concluidas / total;

  void carregar(List<Map<String, dynamic>> data) => _raw = data;

  void adicionar(String titulo, String desc, int prioridade) {
    _raw.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'dataCriacao': DateTime.now().toIso8601String(),
      'titulo': titulo,
      'descricao': desc,
      'prioridade': prioridade,
      'concluida': false,
    });
  }

  void alternarStatus(int id) {
    for (final t in _raw) {
      if (t['id'] == id) t['concluida'] = !(t['concluida'] as bool);
    }
  }

  void excluir(int id) => _raw.removeWhere((t) => t['id'] == id);

  void editar(int id, String novoT, String novaD, int novaP) {
    for (final t in _raw) {
      if (t['id'] == id) {
        if (novoT.isNotEmpty) t['titulo']    = novoT;
        if (novaD.isNotEmpty) t['descricao'] = novaD;
        t['prioridade'] = novaP;
      }
    }
  }
}

void main() {
  final console = Console();
  final manager = TodoManager();
  manager.carregar(_carregarArquivo());

  int cursorIdx = 0;
  bool rodando  = true;

  console.rawMode = true;
  console.hideCursor();

  while (rodando) {
    if (manager.total > 0 && cursorIdx >= manager.total) {
      cursorIdx = manager.total - 1;
    }

    _renderMain(console, manager, cursorIdx);

    final key = console.readKey();

    if (key.isControl) {
      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          if (cursorIdx > 0) cursorIdx--;
          break;
        case ControlCharacter.arrowDown:
          if (cursorIdx < manager.total - 1) cursorIdx++;
          break;
        case ControlCharacter.escape:
          rodando = false;
          break;
        default:
          break;
      }
    } else {
      switch (key.char.toLowerCase()) {
        case ' ':
          if (manager.total > 0) {
            manager.alternarStatus(manager.tarefas[cursorIdx]['id'] as int);
            _salvarArquivo(manager.tarefas);
          }
          break;
        case 'a':
          _prepInput(console);
          _telaAdicionar(console, manager);
          _voltarNav(console);
          _salvarArquivo(manager.tarefas);
          break;
        case 'e':
          if (manager.total > 0) {
            _prepInput(console);
            _telaEditar(console, manager, cursorIdx);
            _voltarNav(console);
            _salvarArquivo(manager.tarefas);
          }
          break;
        case 'f':
          _prepInput(console);
          _telaBuscar(console, manager);
          _voltarNav(console);
          break;
        case 'd':
          if (manager.total > 0) {
            _prepInput(console);
            final confirmado = _confirmarDelete(
              console,
              manager.tarefas[cursorIdx]['titulo'].toString(),
            );
            _voltarNav(console);
            if (confirmado) {
              manager.excluir(manager.tarefas[cursorIdx]['id'] as int);
              _salvarArquivo(manager.tarefas);
            }
          }
          break;
        case 'q':
          rodando = false;
          break;
      }
    }
  }

  console.rawMode = false;
  console.showCursor();
  console.clearScreen();
  console.resetCursorPosition();
  print('${T.grn}${T.b}  ✓ Dados salvos. Até logo!${T.r}\n');
}

void _renderMain(Console console, TodoManager m, int cursor) {
  console.clearScreen();
  console.resetCursorPosition();

  final now    = DateTime.now();
  final semana = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sáb'][now.weekday % 7];
  final data   = '$semana, ${_dd(now.day)} ${_mes(now.month)}  ${_dd(now.hour)}:${_dd(now.minute)}';

  _ln('');
  _ln('  ${T.fg2}╭──────────────────────────────────────────────────────╮${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.acc}${T.b}◈  TAREFAS${T.r}${' ' * 32}${T.fg1}$data  ${T.fg2}│${T.r}');

  if (m.total > 0) {
    final preenchido = (m.pct * 20).round();
    final barra = '${T.grn}${'█' * preenchido}${T.r}${T.fg2}${'░' * (20 - preenchido)}${T.r}';
    final pctStr = '${(m.pct * 100).round()}%';
    _ln('  ${T.fg2}│${T.r}  $barra  ${T.fg1}${m.concluidas}/${m.total}${T.r}  ${T.grn}${T.b}$pctStr${T.r}${' ' * (m.pct < 1 ? 27 : 26)}${T.fg2}│${T.r}');
  } else {
    _ln('  ${T.fg2}│${T.r}  ${T.fg1}nenhuma tarefa. aperte ${T.acc}a${T.fg1} para adicionar.${T.r}${' ' * 11}${T.fg2}│${T.r}');
  }
  _ln('  ${T.fg2}╰──────────────────────────────────────────────────────╯${T.r}');
  _ln('');
  _ln('  ${T.fg2}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${T.r}');
  _ln('');

  const janela = 6;
  int inicio = 0;
  if (m.total > janela) {
    inicio = cursor - janela + 1;
    if (inicio < 0) inicio = 0;
    if (inicio > m.total - janela) inicio = m.total - janela;
  }
  final fim = (inicio + janela > m.total) ? m.total : inicio + janela;

  if (inicio > 0) {
    _ln('  ${T.fg2}  ↑ $inicio acima...${T.r}');
  } else {
    _ln('');
  }

  for (var i = inicio; i < fim; i++) {
    final t      = m.tarefas[i];
    final sel    = i == cursor;
    final done   = t['concluida'] as bool;
    final prio   = (t['prioridade'] as int?) ?? 3;
    final titulo = _trunc(t['titulo'].toString(), 28);
    final dt     = t.containsKey('dataCriacao')
        ? DateTime.parse(t['dataCriacao'] as String)
        : null;

    final corPrio = done ? T.fg2 : (prio == 1 ? T.red : prio == 2 ? T.yel : T.cyn);
    final tagPrio = done ? '  ' : (prio == 1 ? '! ' : prio == 2 ? '– ' : '↓ ');
    final icone   = done ? '${T.grn}✓${T.r}' : '${corPrio}○${T.r}';
    final pointer = sel ? '${T.cyn}${T.b}▶${T.r}' : ' ';
    final bgLinha = sel ? T.bgSel : '';
    final fgTit   = done ? '${T.fg2}$titulo${T.r}' : '${T.fg0}${T.b}$titulo${T.r}';
    final dtStr   = dt != null ? '${T.fg2}${_dd(dt.day)}/${_dd(dt.month)}${T.r}' : '     ';

    final pad = 28 - titulo.length;

    stdout.write('  $pointer $bgLinha $icone  ${corPrio}$tagPrio${T.r}$fgTit${' ' * pad}  $dtStr${T.r}\n');

    if (sel) {
      final desc = t['descricao'].toString();
      if (desc.isNotEmpty) {
        _ln('       ${T.fg2}└─ ${_trunc(desc, 38)}${T.r}');
      } else {
        _ln('');
      }
    }
  }

  if (fim < m.total) {
    _ln('  ${T.fg2}  ↓ ${m.total - fim} abaixo...${T.r}');
  } else {
    _ln('');
  }

  _ln('');
  _ln('  ${T.fg2}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${T.r}');
  stdout.write(
    '  ${T.fg2}↑↓${T.r} mover  '
    '${T.acc}spc${T.r} ${T.fg1}check${T.r}  '
    '${T.acc}a${T.r} ${T.fg1}add${T.r}  '
    '${T.acc}e${T.r} ${T.fg1}editar${T.r}  '
    '${T.acc}d${T.r} ${T.fg1}del${T.r}  '
    '${T.acc}f${T.r} ${T.fg1}buscar${T.r}  '
    '${T.acc}q${T.r} ${T.fg1}sair${T.r}\n'
  );
}

void _telaAdicionar(Console console, TodoManager m) {
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.acc}${T.b}╭─ nova tarefa${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}título${T.r}     ${T.cyn}▸${T.r}  ', newline: false);
  final titulo = (console.readLine()?.trim()) ?? '';
  if (titulo.isEmpty) return;

  _ln('  ${T.fg2}│${T.r}  ${T.fg1}descrição${T.r}  ${T.cyn}▸${T.r}  ', newline: false);
  final desc = (console.readLine()?.trim()) ?? '';

  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}prioridade${T.r}  ${T.cyn}▸${T.r}  ${T.fg2}[1]${T.r} ${T.red}alta${T.r}  ${T.fg2}[2]${T.r} ${T.yel}média${T.r}  ${T.fg2}[3]${T.r} ${T.cyn}baixa${T.r}  ${T.fg1}[Enter=3]${T.r}  ', newline: false);
  final pInput = (console.readLine()?.trim()) ?? '';
  final prio   = int.tryParse(pInput) ?? 3;

  _ln('  ${T.fg2}│${T.r}');
  m.adicionar(titulo, desc, prio.clamp(1, 3));
  _ln('  ${T.grn}${T.b}╰─ ✓ tarefa adicionada!${T.r}');
  _pausar(console);
}

void _telaEditar(Console console, TodoManager m, int index) {
  final t = m.tarefas[index];
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.yel}${T.b}╭─ editar:${T.r} ${T.fg0}${_trunc(t['titulo'].toString(), 30)}${T.r}');
  _ln('  ${T.fg2}│  deixe vazio para manter  ·  :q no título para cancelar${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}título${T.r}     ${T.cyn}▸${T.r}  ', newline: false);
  final nt = (console.readLine()?.trim()) ?? '';
  if (nt == ':q') return;

  _ln('  ${T.fg2}│${T.r}  ${T.fg1}descrição${T.r}  ${T.cyn}▸${T.r}  ', newline: false);
  final nd = (console.readLine()?.trim()) ?? '';

  final prioAtual = (t['prioridade'] as int?) ?? 3;
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}prioridade${T.r} ${T.cyn}▸${T.r}  ${T.fg2}[1]${T.r} ${T.red}alta${T.r}  ${T.fg2}[2]${T.r} ${T.yel}média${T.r}  ${T.fg2}[3]${T.r} ${T.cyn}baixa${T.r}  ${T.fg1}[Enter=$prioAtual]${T.r}  ', newline: false);
  final pInput = (console.readLine()?.trim()) ?? '';
  final novaP  = (int.tryParse(pInput) ?? prioAtual).clamp(1, 3);

  m.editar(t['id'] as int, nt, nd, novaP);
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.grn}${T.b}╰─ ✓ tarefa atualizada!${T.r}');
  _pausar(console);
}

void _telaBuscar(Console console, TodoManager m) {
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.acc}${T.b}╭─ buscar${T.r}  ', newline: false);
  final busca = (console.readLine()?.toLowerCase().trim()) ?? '';

  _ln('');
  _ln('  ${T.fg2}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${T.r}');
  _ln('');

  final resultados = m.tarefas.where((t) =>
    t['titulo'].toString().toLowerCase().contains(busca) ||
    t['descricao'].toString().toLowerCase().contains(busca)
  ).toList();

  if (resultados.isEmpty) {
    _ln('  ${T.red}  nenhum resultado encontrado.${T.r}');
  } else {
    for (final r in resultados) {
      final done = r['concluida'] as bool;
      final icone = done ? '${T.grn}✓${T.r}' : '${T.yel}○${T.r}';
      final titulo = _trunc(r['titulo'].toString(), 32);
      final fgTit = done ? '${T.fg2}$titulo${T.r}' : '${T.fg0}$titulo${T.r}';
      final dt = r.containsKey('dataCriacao')
          ? DateTime.parse(r['dataCriacao'] as String)
          : null;
      final dtStr = dt != null ? '  ${T.fg2}${_dd(dt.day)}/${_dd(dt.month)}${T.r}' : '';
      _ln('  $icone  $fgTit$dtStr');
    }
  }

  _ln('');
  _ln('  ${T.fg2}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${T.r}');
  _ln('  ${T.fg2}${resultados.length} resultado(s)  ·  enter para voltar${T.r}');
  console.readLine();
}

bool _confirmarDelete(Console console, String titulo) {
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.red}${T.b}╭─ excluir tarefa${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}tarefa${T.r}  ${T.fg0}${_trunc(titulo, 36)}${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.red}│${T.r}  ${T.fg1}confirmar exclusão?${T.r}  ${T.grn}[s]${T.r} sim  ${T.fg2}[Enter]${T.r} cancelar  ', newline: false);
  final resp = (console.readLine()?.trim().toLowerCase()) ?? '';
  return resp == 's';
}

void _ln(String s, {bool newline = true}) {
  if (newline) {
    stdout.writeln(s);
  } else {
    stdout.write(s);
  }
}

void _prepInput(Console console) {
  console.rawMode = false;
  console.showCursor();
}

void _voltarNav(Console console) {
  console.hideCursor();
  console.rawMode = true;
}

void _pausar(Console console) {
  stdout.write('\n  ${T.fg2}pressione enter para continuar...${T.r}');
  console.readLine();
}

String _trunc(String s, int max) =>
    s.length <= max ? s : '${s.substring(0, max - 3)}...';

String _dd(int n) => n.toString().padLeft(2, '0');

String _mes(int m) => [
  '', 'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
  'jul', 'ago', 'set', 'out', 'nov', 'dez'
][m];

String _getPath() {
  final home = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ?? '.';
  return '$home/tarefas_cli_db.json';
}

void _salvarArquivo(List<Map<String, dynamic>> tasks) {
  File(_getPath()).writeAsStringSync(jsonEncode(tasks));
}

List<Map<String, dynamic>> _carregarArquivo() {
  final f = File(_getPath());
  if (!f.existsSync()) return [];
  try {
    return List<Map<String, dynamic>>.from(jsonDecode(f.readAsStringSync()));
  } catch (_) {
    return [];
  }
}
