import 'package:dart_console/dart_console.dart';
import 'package:meu_todo/core/database.dart';
import 'package:meu_todo/core/theme.dart';
import 'package:meu_todo/logic/todo_manager.dart';
import 'package:meu_todo/ui/render.dart';

void main() {
  final console = Console();
  final manager = TodoManager();
  manager.carregar(carregarArquivo());

  int cursorIdx = 0;
  bool rodando = true;

  console.rawMode = true;
  console.hideCursor();

  while (rodando) {
    if (manager.total > 0 && cursorIdx >= manager.total) {
      cursorIdx = manager.total - 1;
    }

    renderMain(console, manager, cursorIdx);

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
        case ControlCharacter.enter:
          if (manager.total > 0) {
            final taskSelected = manager.tasks[cursorIdx];
            telaDetalhes(console, taskSelected);
          }
          break;
        default:
          break;
      }
    } else {
      switch (key.char.toLowerCase()) {
        case ' ':
          if (manager.total > 0) {
            manager.alternarStatus(manager.tasks[cursorIdx].id);
            salvarArquivo(manager.tasks.map((t) => t.toJson()).toList());
          }
          break;
        case 'a':
          prepInput(console);
          telaAdicionar(console, manager);
          voltarNav(console);
          salvarArquivo(manager.tasks.map((t) => t.toJson()).toList());
          break;
        case 'e':
          if (manager.total > 0) {
            prepInput(console);
            telaEditar(console, manager, cursorIdx);
            voltarNav(console);
            salvarArquivo(manager.tasks.map((t) => t.toJson()).toList());
          }
          break;
        case 'f':
          prepInput(console);
          telaBuscar(console, manager);
          voltarNav(console);
          break;
        case 'd':
          if (manager.total > 0) {
            prepInput(console);
            final confirmado = confirmarDelete(
              console,
              manager.tasks[cursorIdx].titulo,
            );
            voltarNav(console);
            if (confirmado) {
              manager.excluir(manager.tasks[cursorIdx].id);
              salvarArquivo(manager.tasks.map((t) => t.toJson()).toList());
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
