# Contributing to Interactive CLI Task Manager 🚀

First off, thank you for considering contributing! It's people like you who make the open-source community such an amazing place to learn, inspire, and create.

---

## 📋 Code of Conduct
By participating in this project, you agree to maintain a respectful and welcoming environment for everyone.

## 🛠️ How Can I Contribute?

### Reporting Bugs
- Check the [Issues tab](https://github.com/seu-usuario/seu-repo/issues) to see if the bug has already been reported.
- If not, create a new issue. Include:
  - A clear title and description.
  - Steps to reproduce the bug.
  - Your terminal environment (Windows CMD, PowerShell, Zsh, etc.).
  - Screenshots if applicable.

### Suggesting Enhancements
We are always open to new ideas for the terminal UI or new commands!
- Open an issue with the tag `enhancement`.
- Describe the feature and why it would be useful.

### Pull Requests (Code Contributions)
1. **Fork** the repository.
2. Create a **Branch** for your feature: `git checkout -b feature/AmazingFeature`.
3. **Commit** your changes: `git commit -m 'Add some AmazingFeature'`.
4. **Push** to the branch: `git push origin feature/AmazingFeature`.
5. Open a **Pull Request**.

---

## 💻 Development Setup

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) (Version 3.0.0 or higher).
- A terminal with Unicode support (for the icons and progress bars to render correctly).

### Local Setup
```bash
# Clone your fork
git clone [https://github.com/your-username/TO-DO-LIST-DART-CLI.git](https://github.com/your-username/TO-DO-LIST-DART-CLI.git)

# Enter the directory
cd TO-DO-LIST-DART-CLI

# Get dependencies
dart pub get

# Run in dev mode
dart run bin/main.dart

Style Guidelines

    Follow the official Dart Style Guide.

    Use dart format . before committing your code.

    Ensure your code doesn't have any linter warnings (check your IDE or run dart analyze).

🧪 Testing

If you add a new feature, please try to add a corresponding test in the test/ folder.
To run existing tests:
Bash

dart test

📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.
