# Linter & pre-commit

## Project Overview

This project is a simple Go application that equipped with linters and pre-commit hooks to ensure code quality and consistency during development.

## Requirements

- Go (1.16 or higher): Download from [golang.org](https://golang.org/dl/).
- Python (for pre-commit): Download from [python.org](https://www.python.org/downloads/).

## Getting Started

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Danila-Khlebokazov/DevOpsTeamTasks.git
   cd linter-pre-commit
   ```

2. **Install Pre-Commit:**

   Install the `pre-commit` package using pip:

   ```bash
   pip install pre-commit
   ```

3. **Install Pre-Commit Hooks:**

   Run the following command to install the pre-commit hooks defined in `.pre-commit-config.yaml`:

   ```bash
   pre-commit install
   ```

## Linter Setup

### Chosen Linter

- **golangci-lint**: A powerful linter for Go that integrates multiple linters to analyze code quality.

### Configuration File

The linter is configured using the `.golangci.yml` file located in the root of the project. Here’s the content of the file:

```yaml
run:
  concurrency: 4
  allow-parallel-runners: true
output:
  formats:
    - format: colored-line-number
      path: stderr
linters:
  disable-all: true
  enable:
    - errcheck
    - bodyclose
    - godox
    - govet
```

### Explanation of Chosen Linters

- **errcheck**: Checks for unhandled errors in the code. This is crucial in Go, where error handling is a common practice.
- **bodyclose**: Ensures that HTTP response bodies are closed properly to prevent resource leaks. This is important for efficient memory management.
- **godox**: Checks for comments like TODO and FIXME left in the code. It ensures that no unfinished or temporary code is accidentally committed.
- **govet**: Reports suspicious constructs in Go code, helping to catch potential bugs before they manifest during runtime.

## Commitlint Setup

### Purpose of Commitlint

**commitlint** is a tool that checks if your commit messages meet the defined conventions. This is useful for maintaining a consistent commit history, making it easier to understand the project's evolution.

### Configuration File

The commitlint configuration is defined in `commitlint.config.js`:

```javascript
module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'type-enum': [2, 'always', [
            'feat',
            'fix',
            'docs',
            'style',
            'refactor',
            'test',
            'chore',
            'ci',
        ]],
        'subject-case': [2, 'always', ['sentence-case']],
        'header-max-length': [2, 'always', 72],
    },
};
```

### Explanation of Commitlint Rules

- **type-enum**: The commit message must start with one of the specified types (e.g., `feat`, `fix`). This helps categorize commits by their purpose.
- **subject-case**: The subject of the commit message should be in sentence case, promoting clarity and readability.
- **header-max-length**: The header (first line) of the commit message must not exceed 72 characters, ensuring that the commit message is concise and informative.

  - 2: This is the severity level of the rule. In commitlint, there are three levels of severity:

      0: Disabled (no rule enforcement).
      1: Warning (the rule will trigger a warning, but won't block the commit).
      2: Error (the rule will trigger an error and block the commit).
  
  - 'always': This is the applicability condition. It tells commitlint when to apply the rule. There are two options:
      always: The rule will always be applied.
      never: The rule will ensure the condition is never met (i.e., it's the opposite check).

## Pre-Commit Hook Setup

### Configuration File

The pre-commit hooks are configured in the `.pre-commit-config.yaml` file:

```yaml
repos:
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: v0.5.1
    hooks:
      - id: golangci-lint
        args: ["--config=.golangci.yml"]
  - repo: https://github.com/alessandrojcm/commitlint-pre-commit-hook
    rev: v9.18.0
    hooks:
      - id: commitlint
        stages: [commit-msg]
        additional_dependencies: ['@commitlint/config-conventional']
        args: ["--config=commitlint.config.js"]
```

### Explanation of Pre-Commit Configuration

- **golangci-lint**: This hook runs the `golangci-lint` tool with the specified configuration file to check for code quality issues before commits.
- **commitlint**: This hook checks commit messages against the defined rules to ensure consistency.

## Verifying Pre-Commit Hook Setup

To check that the pre-commit hooks work correctly, follow these steps:

1. **Ensure the pre-commit hooks are installed**:

   Run the following command in your project directory:

   ```bash
   pre-commit install
   ```

   This command sets up the pre-commit hooks defined in your configuration file.

2. **Make a Change and Commit**:

   Modify a file in the project (e.g., introduce a style error) and try to commit the changes:

   ```bash
   git add <file>
   git commit -m "fix: corrected an issue"
   ```

3. **Observe the Pre-Commit Hook Execution**:

   If your code contains issues detected by `golangci-lint`, the commit will be blocked, and you'll see output indicating the problems.

4. **Check Commit Message Format**:

   Attempt to commit with an invalid message format:

   ```bash
   git commit -m "Invalid commit message"
   ```

   The commit will be rejected, and you’ll receive feedback on the violation of the commit message rules.

## Conclusion

This project integrates `golangci-lint` and `commitlint` to ensure high code quality and consistency in commit messages. By using pre-commit hooks, developers can automate these checks and enforce best practices in their workflows.

Try to correct the code and commit the changes :D

## Examples of good commit messages

feat: Implement user login feature

fix: Resolve issue with API response handling

## Sources

golangci-lint: https://golangci-lint.run/

commitlint: https://commitlint.js.org/

pre-commit: https://pre-commit.com/#golang

pre-commit for commitlint: https://github.com/alessandrojcm/commitlint-pre-commit-hook