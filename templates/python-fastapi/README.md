# fastapi template with astral toolkit

## run
```bash
nix develop
uv run src/main.py
```

## features
- ruff lints and formats the code when saving (vscode)
- ty checks types (when they're are defined, e.g. `def func() -> int` and `x: int = func()`)
- fastapi
    - with health check endpoint at `/health`
    - openapi docs at `/docs`
