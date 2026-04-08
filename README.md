<h1 align="center" style="color: #C792EA;">📝 Interactive CLI Task Manager</h1>

<p align="center">
  <img src="https://img.shields.io/github/v/release/notyalC0/TodoManagerCLI?style=for-the-badge&color=C792EA" alt="Release">
  <img src="https://img.shields.io/github/stars/notyalC0/TodoManagerCLI?style=for-the-badge&color=89DDFF" alt="Stars">
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</p>

<p align="center" style="color: #CDD6F4; font-size: 1.1em;">
  A modern, interactive, and highly polished task manager, developed entirely in
  <span style="color: #89DDFF; font-weight: bold;">Dart</span>.
</p>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">🚀 Features</h2>

<ul style="color: #CDD6F4;">
  <li><span style="color: #C792EA; font-weight: bold;">Interactive Navigation:</span> Smoothly browse your list using the <b>arrow keys</b> (<span style="color: #89DDFF;">↑</span> and <span style="color: #89DDFF;">↓</span>).</li>
  <li><span style="color: #C792EA; font-weight: bold;">Visual Dashboard:</span> Graphical progress bar (<span style="color: #C3E88D;">█</span><span style="color: #5A6080;">░</span>), real-time statistics, and pagination (6 tasks at a time).</li>
  <li><span style="color: #C792EA; font-weight: bold;">Priority System:</span> Classify as <span style="color: #F07178;">High (!)</span>, <span style="color: #FFCB6B;">Medium (–)</span>, or <span style="color: #89DDFF;">Low (↓)</span>.</li>
  <li><span style="color: #C792EA; font-weight: bold;">Search & Filter:</span> Find tasks quickly by title or description.</li>
</ul>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">📦 Project Structure</h2>

<pre style="background-color: #0D0E14; padding: 16px; border-radius: 8px; color: #CDD6F4; line-height: 1.5;">
📦 <span style="color: #C792EA; font-weight: bold;">TO-DO-LIST-DART-CLI</span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #5A6080;">.dart_tool/</span>      <span style="color: #5A6080;"><i># Internal files and Dart cache</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #5A6080;">.vscode/</span>         <span style="color: #5A6080;"><i># Editor settings</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #89DDFF;">assets/</span>
<span style="color: #5A6080;">┃ ┗ 🖼️</span> <span style="color: #CDD6F4;">screenshot.png</span> <span style="color: #5A6080;"><i># Images used in this documentation</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #89DDFF;">bin/</span>
<span style="color: #5A6080;">┃ ┗ 🎯</span> <span style="color: #C3E88D;">main.dart</span>      <span style="color: #5A6080;"><i># The heart of the CLI: Interface and Main Logic</i></span>
<span style="color: #5A6080;">┣ 📂</span> <span style="color: #89DDFF;">test/</span>
<span style="color: #5A6080;">┃ ┗ 🧪</span> <span style="color: #CDD6F4;">test.dart</span>      <span style="color: #5A6080;"><i># Unit testing environment</i></span>
<span style="color: #5A6080;">┣ 📄</span> <span style="color: #C792EA;">pubspec.yaml</span>     <span style="color: #5A6080;"><i># Settings, version, and dependencies (dart_console)</i></span>
<span style="color: #5A6080;">┣ 📄</span> <span style="color: #CDD6F4;">pubspec.lock</span>     <span style="color: #5A6080;"><i># Dependency version locking</i></span>
<span style="color: #5A6080;">┣ 📄</span> <span style="color: #CDD6F4;">README.md</span>        <span style="color: #5A6080;"><i># This wonderful documentation</i></span>
<span style="color: #5A6080;">┗ 💾</span> <span style="color: #FFCB6B;">tarefas.json</span>     <span style="color: #5A6080;"><i># Your local database with saved tasks</i></span>
</pre>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">🛠️ Installation & Usage</h2>

<h3 style="color: #CDD6F4;">1. Installing Dependencies</h3>
<p style="color: #CDD6F4;">In the terminal, run the command below in the project root:</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #C3E88D;">dart pub get</pre>

<h3 style="color: #CDD6F4;">2. Activating the Global Command</h3>
<p style="color: #CDD6F4;">To run the program by typing only <code>todo</code> in any folder on your computer:</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #C3E88D;">dart pub global activate --source path .</pre>

<h3 style="color: #CDD6F4;">3. How to Use</h3>
<p style="color: #CDD6F4;">Run the command below in any terminal to start the interface:</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #89DDFF; font-weight: bold;">todo</pre>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">⌨️ Controls & Shortcuts</h2>
<p style="color: #CDD6F4;">Navigate freely without having to press <code>Enter</code> at every step:</p>
<ul style="color: #CDD6F4;">
  <li><kbd>↑</kbd> / <kbd>↓</kbd> : <b>Move cursor</b> through the task list.</li>
  <li><kbd>Space</kbd> : <b>Check/Uncheck</b> (Toggles selected task status).</li>
  <li><kbd>a</kbd> : <b>Add</b> new task (title, description, and priority).</li>
  <li><kbd>e</kbd> : <b>Edit</b> selected task (press <code>:q</code> in the title to cancel).</li>
  <li><kbd>d</kbd> : <b>Delete</b> selected task (with safety confirmation).</li>
  <li><kbd>f</kbd> : <b>Filter/Search</b> active tasks.</li>
  <li><kbd>Enter</kbd> : <b>Details</b> selected task.</li>
  <li><kbd>q</kbd> or <kbd>Esc</kbd> : <b>Exit</b> (Data is saved automatically).</li>
</ul>

<hr style="border-color: #5A6080;">

<p align="center">
  <img src="assets/screenshot.png" alt="App Demo in Terminal" width="600" style="border-radius: 8px; border: 2px solid #5A6080;">
</p>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">🤝 Project Usage & Contributions</h2>
<p style="color: #CDD6F4;">
  This is an open-source project! Feel free to <b>fork</b>, modify the code for your needs, or send a <b>Pull Request</b> with new features.
</p>

<p style="color: #CDD6F4;">To run the project in development mode (without activating globally):</p>
<pre style="background-color: #0D0E14; padding: 12px; border-radius: 8px; color: #C3E88D;">dart run bin/main.dart</pre>

<ul style="color: #CDD6F4;">
  <li>Report bugs in the <span style="color: #C792EA;">Issues</span> tab.</li>
  <li>Suggest new ideas for the terminal interface.</li>
  <li>Improve code organization or add new tests.</li>
</ul>

<hr style="border-color: #5A6080;">

<h2 style="color: #89DDFF;">📄 License</h2>
<p style="color: #CDD6F4;">
  This project is under the <b>MIT</b> license. This means you are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, provided you include the original copyright notice and license permission.
</p>
<p style="color: #CDD6F4;">Check the <code style="color: #FFCB6B;">LICENSE</code> file to read the full terms.</p>

<br>
<p align="center" style="color: #5A6080; font-size: 0.9em;">
  Developed by <b>notyalC</b> 🚀
</p>
