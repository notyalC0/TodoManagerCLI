<h1 align="center" style="color: #C792EA;">📝 Gerenciador de Tarefas CLI Interativo</h1>

<p align="center" style="color: #CDD6F4; font-size: 1.1em;">
  Um gerenciador de tarefas moderno, interativo e altamente polido, desenvolvido inteiramente em 
  <span style="color: #89DDFF; font-weight: bold;">Dart</span>.
</p>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">🚀 Funcionalidades</h2>

<ul style="color: #CDD6F4;">
  <li><span style="color: #C792EA; font-weight: bold;">Navegação Interativa:</span> Navegue pela sua lista suavemente usando as <b>setas do teclado</b> (<span style="color: #89DDFF;">↑</span> e <span style="color: #89DDFF;">↓</span>).</li>
  <li><span style="color: #C792EA; font-weight: bold;">Dashboard Visual:</span> Barra de progresso gráfica (<span style="color: #C3E88D;">█</span><span style="color: #5A6080;">░</span>), estatísticas em tempo real e paginação (6 tarefas por vez).</li>
  <li><span style="color: #C792EA; font-weight: bold;">Sistema de Prioridades:</span> Classifique como <span style="color: #F07178;">Alta (!)</span>, <span style="color: #FFCB6B;">Média (–)</span> ou <span style="color: #89DDFF;">Baixa (↓)</span>.</li>
  <li><span style="color: #C792EA; font-weight: bold;">Busca e Filtro:</span> Encontre tarefas rapidamente pelo título ou descrição.</li>
</ul>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">📦 Estrutura do Projeto</h2>

<pre style="background-color: #0D0E14; padding: 16px; border-radius: 8px; color: #CDD6F4; line-height: 1.5;">
📦 <span style="color: #C792EA; font-weight: bold;">TO-DO-LIST-DART-CLI</span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #5A6080;">.dart_tool/</span>      <span style="color: #5A6080;"><i># Arquivos internos e cache do Dart</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #5A6080;">.vscode/</span>         <span style="color: #5A6080;"><i># Configurações do seu editor</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #89DDFF;">assets/</span>          
<span style="color: #5A6080;">┃ ┗ 🖼️</span> <span style="color: #CDD6F4;">screenshot.png</span> <span style="color: #5A6080;"><i># Imagens usadas nesta documentação</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #89DDFF;">bin/</span>
<span style="color: #5A6080;">┃ ┗ 🎯</span> <span style="color: #C3E88D;">main.dart</span>      <span style="color: #5A6080;"><i># O coração do CLI: Interface e Lógica Principal</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #89DDFF;">test/</span>
<span style="color: #5A6080;">┃ ┗ 🧪</span> <span style="color: #CDD6F4;">test.dart</span>      <span style="color: #5A6080;"><i># Ambiente de testes unitários</i></span>
<span style="color: #5A6080;">┣ 📄</span> <span style="color: #C792EA;">pubspec.yaml</span>     <span style="color: #5A6080;"><i># Configurações, versão e dependências (dart_console)</i></span>
<span style="color: #5A6080;">┣ 📄</span> <span style="color: #CDD6F4;">pubspec.lock</span>     <span style="color: #5A6080;"><i># Travamento das versões das dependências</i></span>
<span style="color: #5A6080;">┣ 📄</span> <span style="color: #CDD6F4;">README.md</span>        <span style="color: #5A6080;"><i># Esta documentação maravilhosa</i></span>
<span style="color: #5A6080;">┗ 💾</span> <span style="color: #FFCB6B;">tarefas.json</span>     <span style="color: #5A6080;"><i># Seu banco de dados local com as tarefas salvas</i></span>
</pre>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">🛠️ Instalação e Uso</h2>

<h3 style="color: #CDD6F4;">1. Instalando as Dependências</h3>
<p style="color: #CDD6F4;">No terminal, rode o comando abaixo na raiz do projeto:</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #C3E88D;">dart pub get</pre>

<h3 style="color: #CDD6F4;">2. Ativando o Comando Global</h3>
<p style="color: #CDD6F4;">Para poder rodar o programa digitando apenas <code>todo</code> em qualquer pasta do seu computador:</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #C3E88D;">dart pub global activate --source path .</pre>

<h3 style="color: #CDD6F4;">3. Como Usar</h3>
<p style="color: #CDD6F4;">Execute o comando abaixo em qualquer terminal para iniciar a interface:</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #89DDFF; font-weight: bold;">todo</pre>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">⌨️ Controles e Atalhos</h2>
<p style="color: #CDD6F4;">Navegue livremente sem precisar apertar <code>Enter</code> a cada passo:</p>
<ul style="color: #CDD6F4;">
  <li><span style="color: #C792EA;">↑ / ↓</span> : <b>Mover o cursor</b> pela lista de tarefas.</li>
  <li><span style="color: #C792EA;">Espaço</span> : <b>Check/Uncheck</b> (Alterna o status da tarefa selecionada).</li>
  <li><span style="color: #C792EA;">a</span> : <b>Adicionar</b> nova tarefa (título, descrição e prioridade).</li>
  <li><span style="color: #C792EA;">e</span> : <b>Editar</b> a tarefa selecionada (pressione <code>:q</code> no título para cancelar).</li>
  <li><span style="color: #C792EA;">d</span> : <b>Deletar</b> a tarefa selecionada (com confirmação de segurança).</li>
  <li><span style="color: #C792EA;">f</span> : <b>Filtrar/Buscar</b> tarefas ativas.</li>
  <li><span style="color: #C792EA;">q ou Esc</span> : <b>Sair</b> (Os dados são salvos automaticamente).</li>
</ul>

<hr style="border-color: #5A6080;">

<p align="center">
  <img src="assets/screenshot.png" alt="Demonstração do App no Terminal" width="600" style="border-radius: 8px; border: 2px solid #5A6080;">
</p>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">📄 Licença</h2>
<p style="color: #CDD6F4;">Distribuído sob a licença <b>MIT</b>. Veja o arquivo <code>LICENSE</code> para mais informações.</p>

<br>
<p align="center" style="color: #5A6080; font-size: 0.9em;">
  Desenvolvido por <b>notyalC</b> 🚀
</p>
