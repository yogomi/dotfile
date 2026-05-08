---
name: webapp-init
description: Webアプリのプロジェクト雛形を生成する。プロジェクト名と任意のオプション（--db, --i18n, --snackbar, --helmet, --compression, --rate-limit）を引数に取る。
user-invocable: true
allowed-tools:
  - Write
  - Bash(mkdir *)
  - Bash(chmod *)
---

Webアプリのプロジェクト雛形を**現在のディレクトリに**生成してください。

引数: $ARGUMENTS

## 引数の解釈

- 最初のワードをプロジェクト名として使用する（例: `myapp`）
- `--db` が含まれる場合: Sequelize（SQLite/PostgreSQL 切替）を追加
- `--i18n` が含まれる場合: i18next + react-i18next を追加
- `--snackbar` が含まれる場合: SnackbarContext を追加
- `--helmet` が含まれる場合: helmet（セキュリティヘッダー）を追加
- `--compression` が含まれる場合: compression（gzip レスポンス圧縮）を追加
- `--rate-limit` が含まれる場合: express-rate-limit + `app.set('trust proxy', 1)` を追加
- フラグがない場合は対応機能を追加しない

## 生成するディレクトリ構造

```
<project-name>/
├── .env.example
├── package.json                  # npm workspaces（frontend, backend）
├── .gitignore
├── .prettierrc
├── eslint.config.mjs
├── frontend/
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts
│   ├── index.html
│   ├── eslint.config.mjs
│   └── src/
│       ├── index.tsx
│       ├── App.tsx
│       ├── vite-env.d.ts
│       ├── theme.ts
│       ├── utils/
│       │   └── api.ts
│       └── app/
│           ├── SnackbarContext.tsx   # --snackbar のときのみ
│           └── i18n.ts              # --i18n のときのみ
├── backend/
│   ├── package.json
│   ├── tsconfig.json
│   ├── eslint.config.mjs
│   └── src/
│       ├── index.ts
│       ├── db.ts                    # --db のときのみ
│       ├── middleware/
│       │   ├── errorHandler.ts
│       │   └── rateLimiter.ts       # --rate-limit のときのみ
│       ├── utils/
│       │   ├── errors.ts
│       │   └── logger.ts
│       └── routes/
│           └── health.ts
├── docker-compose.yml
├── backend/Dockerfile
├── deploy.sh
└── update.sh
```

## 各ファイルの仕様

### ルート `.env.example`

ルートに1ファイルとして置き、backend は `dotenv.config({ path: '../.env' })` で読み込む。

```
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000
FRONTEND_PATH=../frontend/dist
LOG_DIR=./backend/logs
LOG_LEVEL=debug

# --db のときのみ
DB_PATH=./backend/data/dev.sqlite
DATABASE_URL=postgres://user:pass@localhost:5432/dbname
```

### ルート `package.json`

- `workspaces`: `["frontend", "backend"]`
- `devDependencies`: `concurrently`
- `scripts.dev`: `concurrently "npm run dev:backend" "npm run dev:frontend"`
- `scripts.dev:backend`: `cd backend && npm run dev`
- `scripts.dev:frontend`: `cd frontend && npm run dev`
- `scripts.build`: `cd frontend && npm run build`
- `scripts.lint`: 各ワークスペースの lint を順に実行
- `scripts.format`: 各ワークスペースの format を順に実行
- `scripts.typecheck`: 各ワークスペースの typecheck を順に実行

### `.gitignore`

`node_modules`, `dist`, `.env`, `backend/data/`, `backend/logs/` を含む。

### `.prettierrc`

```json
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100
}
```

### ルート `eslint.config.mjs`

`typescript-eslint` を使用したフラットconfig。

### `frontend/package.json`

**dependencies:**
- `react@^19`, `react-dom@^19`
- `react-router-dom`
- `@mui/material`, `@emotion/react`, `@emotion/styled`, `@mui/icons-material`
- `--i18n` の場合: `i18next`, `react-i18next`

**devDependencies:**
- `typescript`, `vite`, `@vitejs/plugin-react`
- `@types/react`, `@types/react-dom`
- `eslint`, `typescript-eslint`, `eslint-plugin-react-hooks`, `prettier`

**scripts:** `dev`, `build`, `preview`, `lint`, `format`, `typecheck`

### `frontend/tsconfig.json`

`strict: true`, `target: ES2020`, `jsx: react-jsx`。

### `frontend/vite.config.ts`

- dev server ポート: `3000`
- 開発時のプロキシ: `/api` → `http://localhost:3001`

### `frontend/src/index.tsx`

- `ThemeProvider`（`theme.ts`）でラップ
- `BrowserRouter` + `Routes`（ベースパス `/<project-name>`）
- `--snackbar` の場合: `SnackbarProvider` でラップ
- `--i18n` の場合: `I18nextProvider` でラップ（`i18n.ts` をインポート）

### `frontend/src/theme.ts`

MUI のデフォルトテーマをベースにした `createTheme()` のエクスポート。

### `frontend/src/utils/api.ts`

`fetch` のラッパー。ベースURLは `import.meta.env.VITE_API_BASE_URL || ''`。
共通エラーハンドリング（HTTP エラーを `Error` として throw）。

### `frontend/src/app/SnackbarContext.tsx`（`--snackbar` のときのみ）

- `SnackbarContext` と `useSnackbar()` フックを定義
- severity: `success` / `error` / `warning` / `info`
- `SnackbarProvider` コンポーネントを export
- MUI の `Snackbar` + `Alert` を組み合わせて表示

### `frontend/src/app/i18n.ts`（`--i18n` のときのみ）

- `i18next` と `react-i18next` を使用
- 日本語・英語の翻訳リソース（サンプルキーを含む）
- `i18next.init()` を呼び出してデフォルト export

### `backend/package.json`

**dependencies:**
- `express`, `cors`
- `express-async-errors`
- `winston`
- `dotenv`, `zod`
- `@types/node`（本番でも使用）
- `--db` の場合: `sequelize`, `sequelize-typescript`, `reflect-metadata`, `pg`, `pg-hstore`
- `--helmet` の場合: `helmet`
- `--compression` の場合: `compression`
- `--rate-limit` の場合: `express-rate-limit`

**devDependencies:**
- `typescript`, `ts-node-dev`
- `@types/express`, `@types/cors`
- `--db` の場合: `sqlite3`
- `--compression` の場合: `@types/compression`
- `eslint`, `typescript-eslint`, `prettier`

**scripts:** `dev`（ts-node-dev）, `build`, `start`, `lint`, `format`, `typecheck`

### `backend/tsconfig.json`

`strict: true`, `target: ES2020`。
`--db` の場合は `experimentalDecorators: true`, `emitDecoratorMetadata: true` を追加。

### `backend/src/utils/logger.ts`

Winston を使ったロガー。

- 開発環境: タイムスタンプ + カラー付きテキスト形式（スタックトレース・メタデータ含む）
- 本番環境: JSON 構造化ログ形式
- トランスポート:
  - Console（常時）
  - `error.log`（error レベルのみ、JSON 形式）
  - `combined.log`（全レベル、JSON 形式）
- ログ出力先: `LOG_DIR` 環境変数（デフォルト `../../logs` = ルートの `logs/`）
- ログレベル: `LOG_LEVEL` 環境変数（デフォルト: 本番 `info`、開発 `debug`）

### `backend/src/utils/errors.ts`

```ts
export class AppError extends Error {
  constructor(
    message: string,
    public readonly statusCode: number,
    public readonly code: string,
    public readonly isOperational = true,
  ) {
    super(message);
  }
}
```

### `backend/src/middleware/errorHandler.ts`

- Sequelize の `ValidationError` / `UniqueConstraintError` / `ConnectionError` / `TimeoutError` → `AppError` に変換
- `AppError`（運用エラー）: `warn` ログ、`statusCode` でレスポンス
- それ以外（プログラムエラー）: `error` ログ（リクエスト情報含む）、500 でレスポンス
- レスポンス形式: `{ success: false, code, message, data: null }`

### `backend/src/middleware/rateLimiter.ts`（`--rate-limit` のときのみ）

`express-rate-limit` を使い以下の2種類を export する。

- `apiRateLimiter`: 一般 API 用（200 req / 3 sec）
- `authRateLimiter`: 認証系エンドポイント用（10 req / 3 min）

レスポンス形式: `{ success: false, code: 'rate_limit_exceeded', message: '...', data: null }`

### `backend/src/routes/health.ts`

```
GET /api/v1/health
- --db あり: DB 接続確認（sequelize.authenticate()）
  - 成功: { success: true, code: '', message: 'OK', data: { status: 'healthy' } }
  - 失敗: 503 { success: false, code: 'unhealthy', message: 'Database connection failed', data: null }
- --db なし: 常に { success: true, code: '', message: 'OK', data: { status: 'ok' } }
```

### `backend/src/index.ts`

ファイル先頭で以下を実行する（順番厳守）:

```ts
import 'express-async-errors';
import dotenv from 'dotenv';
dotenv.config({ path: '../.env' });
```

その後以下を実装する:

1. `express()` インスタンスを生成
2. `app.set('trust proxy', 1)`（`--rate-limit` のときのみ）
3. `helmet()`（`--helmet` のときのみ）
4. `compression()`（`--compression` のときのみ）
5. `cors({ origin: process.env.FRONTEND_URL || 'http://localhost:3000', credentials: true })`
6. `express.json({ limit: '10mb' })`
7. `/api/v1` にルーターをマウント（health ルートを含む、`--rate-limit` の場合は `apiRateLimiter` を挟む）
8. `NODE_ENV === 'production'` の場合:
   - `FRONTEND_PATH` 環境変数（デフォルト `../frontend/dist`）から静的ファイルを配信
   - JS/CSS は `Cache-Control: public, max-age=31536000, immutable`、その他は `max-age=86400`
   - API パス以外の未マッチルートは `index.html` にフォールバック
9. 404 ハンドラ: `{ success: false, code: 'not_found', message: 'Not found', data: null }`
10. `globalErrorHandler` を末尾に登録
11. Graceful shutdown を実装:
    - `SIGTERM` / `SIGINT`: `server.close()` → DB 接続クローズ → `process.exit(0)`（30 秒タイムアウトで強制終了）
    - `uncaughtException` / `unhandledRejection`: ログ記録後に graceful shutdown
12. 起動処理:
    - `--db` あり: `sequelize.authenticate()` 成功後に `app.listen(PORT)`
    - `--db` なし: 直接 `app.listen(PORT)`
    - デフォルト PORT は `3001`

### `backend/src/db.ts`（`--db` のときのみ）

- `NODE_ENV !== 'production'`: SQLite（`DB_PATH` 環境変数でパス上書き可能、デフォルト `../data/dev.sqlite`）
- `production`: PostgreSQL（`DATABASE_URL` 環境変数）
- `sequelize-typescript` で初期化して export

### `docker-compose.yml`

- `backend` サービス: Dockerfile でビルド、`NODE_ENV=production`
- `frontend/dist` を backend コンテナの `/app/frontend/dist` に `:ro` マウント
- `--db` の場合:
  - `postgres` サービス: `postgres:16-alpine`、`/opt/<project-name>/pgdata` に永続化
  - `/opt/<project-name>/uploads` などの永続化ボリュームを定義

### `backend/Dockerfile`

マルチステージビルド（`node:20-alpine`）:

1. **builder**: `python3 make g++` を追加、`npm ci`, `npm run build`
2. **runner**: `node_modules`（production のみ）と `dist` をコピー

### `deploy.sh`

初回フルデプロイ:
1. `npm install`（ルート）
2. `npm run build`（frontend）
3. `docker compose up -d --build`

### `update.sh`

差分更新:
1. `git pull`
2. `npm install`（ルート）
3. `npm run build`（frontend）
4. `docker compose up -d --build backend`

## 生成時の注意事項

- TypeScript のセミコロンは省略しない
- 行末のスペースやタブは禁止
- 改行コードは LF
- 1行 100 文字以内
- すべてのファイルを実際に Write ツールで作成すること
- `deploy.sh`, `update.sh` には実行権限を付与すること（`chmod +x`）
- `--db` の場合: `backend/data/` ディレクトリを `mkdir -p` で作成すること（SQLite 用）
