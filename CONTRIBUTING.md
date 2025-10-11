# Contributing to SSI

Thank you for your interest in contributing to SSI (Adaptive Deep Learning Model)! We welcome contributions from the community. 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

### Prerequisites

- Python 3.8+
- Docker (recommended)
- Git

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/SSI.git
   cd SSI
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/AXI0MH1VE/SSI.git
   ```
4. **Run setup script**:
   ```bash
   chmod +x scripts/*.sh
   ./scripts/setup.sh
   ```
5. **Start the application**:
   ```bash
   ./scripts/run-docker.sh  # or ./scripts/run-local.sh
   ```

## How to Contribute

### Reporting Bugs

- Use the GitHub Issues tab
- Search existing issues first to avoid duplicates
- Include detailed information:
  - Steps to reproduce
  - Expected vs actual behavior
  - Environment details (OS, Python version, etc.)
  - Relevant logs from `local_storage/logs/`

### Suggesting Features

- Open a GitHub Issue with the "enhancement" label
- Clearly describe the feature and its use case
- Discuss in GitHub Discussions for broader community input

### Good First Issues

Look for issues labeled `good first issue` - these are great starting points for new contributors!

## Development Process

### Creating a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### Making Changes

1. Make your changes in your feature branch
2. Follow our [Coding Standards](#coding-standards)
3. Write or update tests as needed
4. Update documentation if required
5. Test your changes locally

### Commit Messages

Write clear, descriptive commit messages:

```
type: Brief description (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain the problem this commit solves and why this approach was chosen.

Fixes #123
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## Pull Request Process

1. **Update your fork** with upstream changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your branch** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request** on GitHub:
   - Provide a clear title and description
   - Reference any related issues (e.g., "Fixes #123")
   - Describe what changed and why
   - Include screenshots for UI changes

4. **Code Review**:
   - Respond to reviewer feedback
   - Make requested changes in new commits
   - Be patient and respectful

5. **Merge**:
   - Once approved, a maintainer will merge your PR
   - Your contribution will be included in the next release! 🎉

## Coding Standards

### Python Style

- Follow [PEP 8](https://pep8.org/) style guide
- Use meaningful variable and function names
- Maximum line length: 100 characters
- Use type hints where appropriate

### Code Organization

- Keep functions focused and small
- Add docstrings to all public functions and classes
- Comment complex logic
- Maintain the existing project structure

### Example Function:

```python
def process_request(prompt: str, context: dict = None) -> dict:
    """
    Process an ADLM request with the given prompt.
    
    Args:
        prompt: The user's input prompt
        context: Optional context dictionary
        
    Returns:
        dict: Response containing result and metadata
    """
    # Implementation
    pass
```

## Testing

### Running Tests

```bash
# Run all tests
python -m pytest

# Run specific test file
python -m pytest tests/test_axiom_model.py

# Run with coverage
python -m pytest --cov=axiom_model
```

### Writing Tests

- Write unit tests for new functionality
- Ensure tests are isolated and deterministic
- Mock external dependencies
- Aim for high code coverage

## Documentation

### What to Document

- New features and APIs
- Configuration options
- Architecture changes
- Setup and deployment procedures

### Documentation Style

- Use clear, concise language
- Include code examples
- Add diagrams for complex concepts
- Update the README when needed

## Community

### Getting Help

- **GitHub Discussions**: Ask questions and share ideas
- **GitHub Issues**: Report bugs and request features
- **Pull Requests**: Get code review feedback

### Being a Good Community Member

- Be respectful and welcoming
- Help others when you can
- Share knowledge and experiences
- Give constructive feedback
- Celebrate successes together! 🎉

## Principles

Remember our core principles when contributing:

1. **User Full Control**: No hidden external calls, all data local
2. **Full Transparency**: Clear, inspectable logic and audit logs
3. **Deterministic Behavior**: Same inputs = same outputs
4. **Privacy First**: Offline-by-default operation

## License

By contributing to SSI, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to ask questions in GitHub Discussions or open an issue. We're here to help!

Thank you for contributing to SSI! 🚀
