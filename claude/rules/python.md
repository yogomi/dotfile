# Pythonルール

- パッケージ管理にはuvを使う（依存追加は `uv add`、環境同期は `uv sync`、実行は `uv run`）
- モジュール・クラス・関数（公開APIを中心）には必ず docstring（Google スタイル）を付与し、説明・引数・戻り値・例外・副作用を記載
- LintおよびフォーマットにはRuffを使う（`ruff check` + `ruff format`）
- 型チェックにはPyrightを使う（`pyrightconfig.json` をプロジェクトルートに置く）
- 設定は `pyproject.toml` の `[tool.ruff]` セクションにまとめる
  （`line-length = 100`、`quote-style = "single"`）
- コミット前は `ruff check`・`ruff format --check`・`pyright` を実行する
