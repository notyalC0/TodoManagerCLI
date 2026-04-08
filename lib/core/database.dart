import 'dart:convert';
import 'dart:io';

String _getPath() {
  final home = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      '.';
  return '$home/tarefas_cli_db.json';
}

void salvarArquivo(List<Map<String, dynamic>> tasks) {
  File(_getPath()).writeAsStringSync(jsonEncode(tasks));
}

List<Map<String, dynamic>> carregarArquivo() {
  final f = File(_getPath());
  if (!f.existsSync()) return [];
  try {
    return List<Map<String, dynamic>>.from(jsonDecode(f.readAsStringSync()));
  } catch (_) {
    return [];
  }
}
