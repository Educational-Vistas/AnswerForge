# AGENTS.md - BMad Project Guidelines

## Project Overview

BMad (Builder's Method for Agent Development) is a framework for structured agentic workflows. It uses a skill-based architecture with YAML/TOML configuration and Python scripts.

## Build / Lint / Test Commands

### Python Scripts

All Python scripts use PEP 723 inline dependency metadata. Run directly with Python 3.10+:

```bash
# Run a script (dependencies auto-resolved via uv or pip)
python .opencode/skills/bmad-init/scripts/bmad_init.py

# Run with uv (recommended)
uv run .opencode/skills/bmad-distillator/scripts/analyze_sources.py
```

### Testing

```bash
# Run all tests with pytest
pytest .opencode/skills/bmad-init/scripts/tests/
pytest .opencode/skills/bmad-distillator/scripts/tests/

# Run a single test file
pytest .opencode/skills/bmad-init/scripts/tests/test_bmad_init.py

# Run a single test class
pytest .opencode/skills/bmad-init/scripts/tests/test_bmad_init.py::TestFindProjectRoot

# Run a single test method
pytest .opencode/skills/bmad-init/scripts/tests/test_bmad_init.py::TestFindProjectRoot::test_finds_bmad_folder

# Run with unittest (alternative)
python -m unittest .opencode.skills.bmad-init.scripts.tests.test_bmad_init
```

### Type Checking (optional)

```bash
# Install mypy if needed
pip install mypy

# Type check a file
mypy .opencode/skills/bmad-init/scripts/bmad_init.py
```

## Code Style Guidelines

### Python

#### Imports
- Use `from __future__ import annotations` for forward references
- Group imports: stdlib → third-party → local
- Use absolute imports with pathlib for local modules:
  ```python
  import sys
  from pathlib import Path
  sys.path.insert(0, str(Path(__file__).parent.parent))
  ```

#### Formatting
- 4 spaces for indentation
- 88-100 character line length (Black-compatible)
- Single quotes for strings: `'string'`
- f-strings for interpolation: `f'Hello {name}'`
- Trailing commas in multi-line collections

#### Naming
- `snake_case` for functions, variables, modules
- `PascalCase` for classes
- `UPPER_CASE` for constants
- Private functions prefix with underscore: `_helper()`

#### Types
- Use type hints everywhere (Python 3.10+ syntax)
- Use `|` for unions: `str | None`
- Use built-in generics: `list[str]`, `dict[str, int]`

#### Error Handling
- Use specific exceptions, avoid bare `except:`
- Log errors to stderr: `print(..., file=sys.stderr)`
- Exit with non-zero codes on failure: `sys.exit(1)`
- Use `try/except/else/finally` appropriately

#### Documentation
- Module docstrings explain purpose and usage
- Function docstrings for public APIs
- Inline comments for complex logic
- PEP 723 header for script dependencies:
  ```python
  # /// script
  # requires-python = ">=3.10"
  # dependencies = ["pyyaml"]
  # ///
  ```

### File Organization

```
skill-name/
├── SKILL.md              # Entry point (6 lines max)
├── workflow.md           # Workflow orchestration
├── checklist.md          # Completion criteria
├── steps-c/              # Step files (create mode)
│   ├── step-01-init.md
│   └── step-02-discovery.md
├── scripts/              # Python scripts
│   ├── script_name.py
│   └── tests/
│       └── test_script_name.py
├── templates/            # Document templates
└── resources/            # Static assets
```

### Configuration

- **YAML**: Use for module definitions, workflow configs
- **TOML**: Use for customization files (`customize.toml`, `config.toml`)
- **JSON**: Use for structured output, API responses
- Frontmatter in markdown files uses YAML format

### Path Handling

- Always use `pathlib.Path` over `os.path`
- Use `{project-root}` placeholder in configs, resolve at runtime
- Skip directories: `node_modules`, `.git`, `__pycache__`, `.venv`

### Testing Standards

- Use pytest for new tests
- Use unittest only when required
- Fixtures in `conftest.py` or `@pytest.fixture`
- Parametrize test cases where applicable
- Mock external dependencies
- Clean up temp files in `tearDown` or use `tempfile`

## Project-Specific Conventions

### BMad Agent System

- Agents defined in `_bmad/config.toml` with `name`, `title`, `icon`, `description`
- Skills follow `bmad-{verb}-{noun}` naming
- Workflows use step-file architecture (sequential, no skipping)
- Output files use frontmatter with `stepsCompleted` tracking

### Key Directories

- `_bmad/` - Configuration and core modules
- `_bmad-output/` - Generated artifacts (gitignored)
- `_bmad-input/` - Input documents
- `.opencode/skills/` - Installed skills
- `.agents/skills/` - Customized skills
- `docs/` - Project knowledge base
