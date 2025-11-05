# fastapi template with astral toolkit

## run
```bash
nix develop
uv run fastapi dev
```

## features
- ruff lints and formats the code when saving (vscode)
- ty checks types (when they're are defined, e.g. `def func() -> int` and `x: int = func()`)
- fastapi
    - with health check endpoint at `http://127.0.0.1:8000/health`
    - openapi docs at `http://127.0.0.1:8000/docs`
