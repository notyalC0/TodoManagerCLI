import 'dart:io';
import 'package:dart_console/dart_console.dart';
import '../core/database.dart';
import '../logic/todo_manager.dart';
import '../core/theme.dart';
import '../models/tasks.dart';

void renderMain(Console console, TodoManager m, int cursor) {
  console.clearScreen();
  console.resetCursorPosition();

  final now = DateTime.now();
  final semana =
      ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sáb'][now.weekday % 7];
  final data =
      '$semana, ${_dd(now.day)} ${_mes(now.month)}  ${_dd(now.hour)}:${_dd(now.minute)}';

  _ln('');
  _ln('  ${T.fg2}╭──────────────────────────────────────────────────────╮${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.acc}${T.b}◈  TAREFAS${T.r}${' ' * 32}${T.fg1}$data  ${T.fg2}│${T.r}');

  if (m.total > 0) {
    final preenchido = (m.pct * 20).round();
    final barra =
        '${T.grn}${'█' * preenchido}${T.r}${T.fg2}${'░' * (20 - preenchido)}${T.r}';
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
    final t = m.tasks[i];
    final sel = i == cursor;
    final done = t.concluida;
    final prio = t.prioridade;
    final titulo = _trunc(t.titulo, 28);
    final dt = t.dataCriacao;

    final corPrio = done
        ? T.fg2
        : (prio == 1
            ? T.red
            : prio == 2
                ? T.yel
                : T.cyn);
    final tagPrio = done
        ? '  '
        : (prio == 1
            ? '! '
            : prio == 2
                ? '– '
                : '↓ ');
    final icone = done ? '${T.grn}✓${T.r}' : '${corPrio}○${T.r}';
    final pointer = sel ? '${T.cyn}${T.b}▶${T.r}' : ' ';
    final bgLinha = sel ? T.bgSel : '';
    final fgTit =
        done ? '${T.fg2}$titulo${T.r}' : '${T.fg0}${T.b}$titulo${T.r}';
    final dtStr = '${T.fg2}${_dd(dt.day)}/${_dd(dt.month)}${T.r}';

    final pad = 28 - titulo.length;

    stdout.write(
        '  $pointer $bgLinha $icone  ${corPrio}$tagPrio${T.r}$fgTit${' ' * pad}  $dtStr${T.r}\n');

    if (sel) {
      final desc = t.descricao;
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
  stdout.write('  ${T.fg2}↑↓${T.r} mover  '
      '${T.acc}spc${T.r} ${T.fg1}check${T.r}  '
      '${T.acc}a${T.r} ${T.fg1}add${T.r}  '
      '${T.acc}e${T.r} ${T.fg1}editar${T.r}  '
      '${T.acc}d${T.r} ${T.fg1}del${T.r}  '
      '${T.acc}f${T.r} ${T.fg1}buscar${T.r}  '
      '${T.acc}ent${T.r} ${T.fg1}detalhes${T.r}  '
      '${T.acc}q${T.r} ${T.fg1}sair${T.r}\n');
}

void telaAdicionar(Console console, TodoManager m) {
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.acc}${T.b}╭─ nova tarefa${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}título${T.r}     ${T.cyn}▸${T.r}  ',
      newline: false);
  final titulo = (console.readLine()?.trim()) ?? '';
  if (titulo.isEmpty) return;

  _ln('  ${T.fg2}│${T.r}  ${T.fg1}descrição${T.r}  ${T.cyn}▸${T.r}  ',
      newline: false);
  final desc = (console.readLine()?.trim()) ?? '';

  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}prioridade${T.r}  ${T.cyn}▸${T.r}  ${T.fg2}[1]${T.r} ${T.red}alta${T.r}  ${T.fg2}[2]${T.r} ${T.yel}média${T.r}  ${T.fg2}[3]${T.r} ${T.cyn}baixa${T.r}  ${T.fg1}[Enter=3]${T.r}  ',
      newline: false);
  final pInput = (console.readLine()?.trim()) ?? '';
  final prio = int.tryParse(pInput) ?? 3;

  _ln('  ${T.fg2}│${T.r}');
  m.adicionar(titulo, desc, prio.clamp(1, 3));
  _ln('  ${T.grn}${T.b}╰─ ✓ tarefa adicionada!${T.r}');
  pausar(console);
}

void telaEditar(Console console, TodoManager m, int index) {
  final t = m.tasks[index];
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.yel}${T.b}╭─ editar:${T.r} ${T.fg0}${_trunc(t.titulo, 30)}${T.r}');
  _ln('  ${T.fg2}│  deixe vazio para manter  ·  :q no título para cancelar${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}título${T.r}     ${T.cyn}▸${T.r}  ',
      newline: false);
  final nt = (console.readLine()?.trim()) ?? '';
  if (nt == ':q') return;

  _ln('  ${T.fg2}│${T.r}  ${T.fg1}descrição${T.r}  ${T.cyn}▸${T.r}  ',
      newline: false);
  final nd = (console.readLine()?.trim()) ?? '';

  final prioAtual = t.prioridade;
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}prioridade${T.r} ${T.cyn}▸${T.r}  ${T.fg2}[1]${T.r} ${T.red}alta${T.r}  ${T.fg2}[2]${T.r} ${T.yel}média${T.r}  ${T.fg2}[3]${T.r} ${T.cyn}baixa${T.r}  ${T.fg1}[Enter=$prioAtual]${T.r}  ',
      newline: false);
  final pInput = (console.readLine()?.trim()) ?? '';
  final novaP = (int.tryParse(pInput) ?? prioAtual).clamp(1, 3);

  m.editar(t.id, nt, nd, novaP);
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.grn}${T.b}╰─ ✓ tarefa atualizada!${T.r}');
  pausar(console);
}

void telaBuscar(Console console, TodoManager m) {
  // 1. Primeiro pegamos o termo de busca (modo input)
  prepInput(console);
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.acc}${T.b}╭─ buscar${T.r}  ', newline: false);
  final busca = (console.readLine()?.toLowerCase().trim()) ?? '';

  if (busca.isEmpty) {
    voltarNav(console);
    return;
  }

  voltarNav(console);
  int cursorBusca = 0;
  bool navegandoBusca = true;

  while (navegandoBusca) {
    final resultados = m.tasks
        .where((t) =>
            t.titulo.toLowerCase().contains(busca) ||
            t.descricao.toLowerCase().contains(busca))
        .toList();

    if (resultados.isEmpty) {
      console.clearScreen();
      _ln('\n  ${T.red}  Nenhum resultado para: "$busca"${T.r}');
      _ln('  ${T.fg2}  pressione qualquer tecla para voltar...${T.r}');
      console.readKey();
      break;
    }

    if (cursorBusca >= resultados.length) cursorBusca = resultados.length - 1;
    if (cursorBusca < 0) cursorBusca = 0;

    console.clearScreen();
    console.resetCursorPosition();
    _ln('\n  ${T.acc}${T.b}╭─ resultados para: "$busca"${T.r}');
    _ln('  ${T.fg2}├────────────────────────────────────────${T.r}');

    for (var i = 0; i < resultados.length; i++) {
      final t = resultados[i];
      final sel = i == cursorBusca;
      final icone = t.concluida ? '${T.grn}✓${T.r}' : '${T.yel}○${T.r}';
      final pointer = sel ? '${T.cyn}▶${T.r}' : ' ';
      final bg = sel ? T.bgSel : '';

      _ln('  $pointer $bg $icone  ${sel ? T.b : ''}${_trunc(t.titulo, 30)}${T.r}');
    }

    _ln('  ${T.fg2}├────────────────────────────────────────${T.r}');
    _ln('  ${T.fg2}↑↓ mover  ${T.acc}ent${T.r} detalhes  ${T.acc}spc${T.r} status  ${T.acc}e${T.r} editar  ${T.acc}d${T.r} del  ${T.acc}q${T.r} sair${T.r}');

    final key = console.readKey();
    final taskAtual = resultados[cursorBusca];

    if (key.isControl) {
      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          if (cursorBusca > 0) cursorBusca--;
          break;
        case ControlCharacter.arrowDown:
          if (cursorBusca < resultados.length - 1) cursorBusca++;
          break;
        case ControlCharacter.enter:
          telaDetalhes(console, taskAtual);
          break;
        default:
          break;
      }
    } else {
      switch (key.char.toLowerCase()) {
        case ' ':
          m.alternarStatus(taskAtual.id);

          salvarArquivo(m.exportarParaSalvar());
          break;
        case 'd':
          prepInput(console);
          if (confirmarDelete(console, taskAtual.titulo)) {
            m.excluir(taskAtual.id);
            salvarArquivo(m.exportarParaSalvar());
          }
          voltarNav(console);
          break;
        case 'e':
          prepInput(console);
          telaEditarSimples(console, m, taskAtual);
          salvarArquivo(m.exportarParaSalvar());
          voltarNav(console);
          break;
        case 'q':
          navegandoBusca = false;
          break;
      }
    }
  }
}

void telaEditarSimples(Console console, TodoManager m, Tasks t) {
  console.clearScreen();
  _ln('\n  ${T.yel}${T.b}╭─ editando: ${t.titulo}${T.r}');
  _ln('  ${T.fg2}│  deixe vazio para manter  ·  :q no título para cancelar${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}título${T.r}     ${T.cyn}▸${T.r}  ',
      newline: false);
  final novoTitulo = (console.readLine()?.trim()) ?? '';
  if (novoTitulo == ':q') return;
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}descrição${T.r}  ${T.cyn}▸${T.r}  ',
      newline: false);
  final novaDesc = (console.readLine()?.trim()) ?? '';
  final prioAtual = t.prioridade;
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}prioridade${T.r} ${T.cyn}▸${T.r}  ${T.fg2}[1]${T.r} ${T.red}alta${T.r}  ${T.fg2}[2]${T.r} ${T.yel}média${T.r}  ${T.fg2}[3]${T.r} ${T.cyn}baixa${T.r}  ${T.fg1}[Enter=$prioAtual]${T.r}  ',
      newline: false);
  final pInput = (console.readLine()?.trim()) ?? '';
  final novaPrio = (int.tryParse(pInput) ?? prioAtual).clamp(1, 3);
  m.editar(t.id, novoTitulo, novaDesc, novaPrio);
}

void telaDetalhes(Console console, Tasks t) {
  console.clearScreen();
  console.resetCursorPosition();

  final corPrio = t.concluida
      ? T.fg2
      : (t.prioridade == 1
          ? T.red
          : t.prioridade == 2
              ? T.yel
              : T.cyn);
  final status =
      t.concluida ? '${T.grn}Concluída${T.r}' : '${T.red}Pendente${T.r}';

  _ln('');
  _ln('  ${T.acc}${T.b}╭─ DETALHES DA TAREFA${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}Título:${T.r}    ${T.b}${t.titulo}${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}Status:${T.r}    $status');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}Prioridade:${T.r} ${corPrio}${t.prioridade == 1 ? "Alta" : t.prioridade == 2 ? "Média" : "Baixa"}${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}Criada em:${T.r}  ${T.fg0}${t.dataCriacao.day}/${t.dataCriacao.month}/${t.dataCriacao.year}${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}├─ DESCRIÇÃO${T.r}');
  _ln('  ${T.fg2}│${T.r}');

  if (t.descricao.isEmpty) {
    _ln('  ${T.fg2}│  (Sem descrição informada)${T.r}');
  } else {
    _ln('  ${T.fg0}${t.descricao}${T.r}');
  }

  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.acc}${T.b}╰─ [Enter ou Esc] para voltar${T.r}');

  console.readKey();
}

bool confirmarDelete(Console console, String titulo) {
  console.clearScreen();
  console.resetCursorPosition();
  _ln('');
  _ln('  ${T.red}${T.b}╭─ excluir tarefa${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.fg2}│${T.r}  ${T.fg1}tarefa${T.r}  ${T.fg0}${_trunc(titulo, 36)}${T.r}');
  _ln('  ${T.fg2}│${T.r}');
  _ln('  ${T.red}│${T.r}  ${T.fg1}confirmar exclusão?${T.r}  ${T.grn}[s]${T.r} sim  ${T.fg2}[Enter]${T.r} cancelar  ',
      newline: false);
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

void prepInput(Console console) {
  console.rawMode = false;
  console.showCursor();
}

void voltarNav(Console console) {
  console.hideCursor();
  console.rawMode = true;
}

void pausar(Console console) {
  stdout.write('\n  ${T.fg2}pressione enter para continuar...${T.r}');
  console.readLine();
}

String _trunc(String s, int max) =>
    s.length <= max ? s : '${s.substring(0, max - 3)}...';

String _dd(int n) => n.toString().padLeft(2, '0');

String _mes(int m) => [
      '',
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez'
    ][m];
