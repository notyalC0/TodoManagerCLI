# 📝 Gerenciador de Tarefas CLI (Dart)

Um gerenciador de tarefas (To-Do List) moderno, colorido e funcional, desenvolvido inteiramente em **Dart**. Esta ferramenta foi projetada para rodar diretamente no seu terminal, oferecendo uma experiência ágil e organizada para o seu fluxo de trabalho.

---

## 🚀 Funcionalidades

* **Dashboard Visual:** Painel com barra de progresso gráfica (`█░`) que mostra a porcentagem de tarefas concluídas.
* **Seleção Amigável:** Esqueça IDs complexos. Selecione as tarefas por números simples (1, 2, 3...) refletindo a posição na lista.
* **Status Alternável (Toggle):** Alterne entre "Pendente" e "Concluída" com um único comando.
* **Persistência Centralizada:** Os dados são salvos em um local fixo na pasta do usuário (`HOME` ou `USERPROFILE`), permitindo usar o comando de qualquer diretório sem perder dados.
* **Interface Colorida:** Uso de códigos ANSI para destacar erros, sucessos e categorias.

---

## 📦 Instalação e Configuração

### 1. Pré-requisitos
Certifique-se de ter o **Dart SDK** instalado. [Baixe aqui](https://dart.dev/get-dart).

### 2. Estrutura de Pastas
Para o comando global funcionar, seu projeto deve estar assim:
```text
meu_projeto/
├── bin/
│   └── main.dart      # Arquivo com o código fonte
└── pubspec.yaml       # Configurações do pacote
```

### 3. Configurando o `pubspec.yaml`
Seu arquivo `pubspec.yaml` deve conter estas definições:
```yaml
name: todo
description: Gerenciador de tarefas CLI em Dart.
version: 1.0.0
executables:
  todo: main
environment:
  sdk: '>=3.0.0 <4.0.0'
```

### 4. Ativando o Comando Global
No terminal, dentro da pasta do projeto, execute:
```bash
dart pub global activate --source path .
```
*Certifique-se de que o caminho de binários do Dart (`.pub-cache/bin`) está no seu **PATH** do sistema.*

---

## 🛠️ Como Usar

Digite o comando em qualquer terminal:

```bash
todo
```

### Atalhos do Menu:
* **[ 1 ] Adicionar:** Cria uma nova tarefa.
* **[ 2 ] Listar/Status:** Lista as tarefas e alterna o status (feita/pendente) via número.
* **[ 3 ] Editar:** Altera título ou descrição.
* **[ 4 ] Excluir:** Remove a tarefa permanentemente.
* **[ 0 ] Sair:** Salva e encerra o programa.

---

## 💻 Tecnologias

* **Linguagem:** Dart 3
* **Armazenamento:** JSON
* **Interface:** Terminal (ANSI Escape Codes)

---

<p align="center"><img src="assets/screenshot.png" alt="Demonstração" width="500"></p>


## 📄 Licença
Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

---
Desenvolvido por **notyalC** 🚀
