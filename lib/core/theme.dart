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
