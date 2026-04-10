# Contributing

Thank you for your interest in contributing to **Interactive CLI Task Manager**!
This document explains how to get involved, from reporting a bug to submitting a pull request.

---

## Table of contents

1. [Code of conduct](#code-of-conduct)
2. [Getting started](#getting-started)
3. [Reporting bugs](#reporting-bugs)
4. [Suggesting features](#suggesting-features)
5. [Submitting a pull request](#submitting-a-pull-request)
6. [Code style](#code-style)
7. [Running tests](#running-tests)

---

## Code of conduct

Be respectful and constructive in all interactions. Harassment, hate speech, or personal attacks of any kind will not be tolerated.

---

## Getting started

Before contributing, make sure you can run the project locally:

```bash
git clone https://github.com/notyalC0/TodoManagerCLI
cd TodoManagerCLI
dart pub get
dart run bin/main.dart
```

Dart SDK ≥ 3.0 is required. You can download it at [dart.dev/get-dart](https://dart.dev/get-dart).

---

## Reporting bugs

If you found a bug, please open an [Issue](https://github.com/notyalC0/TodoManagerCLI/issues) and include:

- A clear title describing the problem.
- Steps to reproduce the issue.
- What you expected to happen vs. what actually happened.
- Your OS and Dart SDK version (`dart --version`).

The more context you provide, the faster it can be addressed.

---

## Suggesting features

Have an idea for a new feature? Open an Issue with the `enhancement` label and describe:

- What the feature is and why it would be useful.
- How you imagine it working (commands, keyboard shortcuts, UI behavior).
- Any alternatives you have considered.

---

## Submitting a pull request

1. **Fork** the repository and create a branch from `main`:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes. Keep commits focused and descriptive:

   ```bash
   git commit -m "add: task sorting by priority"
   ```

3. Run the tests to make sure nothing is broken:

   ```bash
   dart test
   ```

4. Push your branch and open a pull request against `main`.

5. In the PR description, explain:
   - What problem it solves or what it adds.
   - Any relevant design decisions you made.
   - If it closes an existing issue, add `Closes #issue-number`.

PRs will be reviewed as soon as possible. Feedback will be given if changes are needed before merging.

---

## Code style

This project follows the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style). A few highlights:

- Use `dart format .` before committing to auto-format all files.
- Prefer `final` over `var` when a variable is not reassigned.
- Keep functions short and focused — if a function is doing too many things, split it.
- Add comments for non-obvious logic, but avoid commenting what the code already makes clear.

---

## Running tests

```bash
dart test
```

Test files live in the `test/` directory. When adding a new feature or fixing a bug, add or update the relevant tests accordingly.

---

<p align="center">Developed by <b>notyalC</b></p>
