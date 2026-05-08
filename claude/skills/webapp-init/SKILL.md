---
name: webapp-init
description: Webアプリのプロジェクト雛形を生成する。プロジェクト名と任意のオプション（--i18n, --snackbar）を引数に取る。
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
- `--i18n` が含まれる場合: i18next + react-i18next を追加
- `--snackbar` が含まれる場合: SnackbarContext を追加
- どちらのフラグもない場合は追加しない

## 生成するディレクトリ構造

```
<project-name>/
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
│   ├── .env.example
│   └── src/
│       ├── app.ts
│       ├── server.ts
│       ├── db.ts
│       ├── middleware/
│       │   └── errorHandler.ts
│       ├── utils/
│       │   └── errors.ts
│       └── routes/
│           └── health.ts
├── docker-compose.yml
├── backend/Dockerfile
├── deploy.sh
└── update.sh
```

## 各ファイルの仕様

### ルート `package.json`

- `workspaces`: `["frontend", "backend"]`
- `scripts.lint`: 各ワークスペースの lint を順に実行
- `scripts.format`: 各ワークスペースの format を順に実行
- `scripts.typecheck`: 各ワークスペースの typecheck を順に実行

### `.gitignore`

`node_modules`, `dist`, `.env`, `backend/data/` を含む。

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

開発時のプロキシ: `/api` → `http://localhost:3000`。

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
- `sequelize`, `sequelize-typescript`, `reflect-metadata`
- `pg`, `pg-hstore`
- `dotenv`, `zod`
- `@types/node`（本番でも使用）

**devDependencies:**
- `sqlite3`
- `typescript`, `ts-node-dev`
- `@types/express`, `@types/cors`
- `eslint`, `typescript-eslint`, `prettier`

**scripts:** `dev`（ts-node-dev）, `build`, `start`, `lint`, `format`, `typecheck`

### `backend/tsconfig.json`

`strict: true`, `target: ES2020`, `experimentalDecorators: true`, `emitDecoratorMetadata: true`。

### `backend/.env.example`

```
NODE_ENV=development
PORT=3000
DB_PATH=./data/dev.sqlite
DATABASE_URL=postgres://user:pass@localhost:5432/dbname
```

### `backend/src/db.ts`

- `NODE_ENV !== 'production'`: SQLite（`DB_PATH` 環境変数でパス上書き可能、デフォルト `./data/dev.sqlite`）
- `production`: PostgreSQL（`DATABASE_URL` 環境変数）
- `sequelize-typescript` で `new Sequelize(...)` して export

### `backend/src/utils/errors.ts`

```ts
export class AppError extends Error {
  constructor(
    public readonly statusCode: number,
    message: string,
    public readonly isOperational = true
  ) {
    super(message);
  }
}
```

### `backend/src/middleware/errorHandler.ts`

- `AppError` の場合: `warn` ログ、`statusCode` でレスポンス
- それ以外（プログラムエラー）: `error` ログ、500 でレスポンス
- Sequelize の `ValidationError` / `UniqueConstraintError` → `AppError(400, ...)` に変換
- レスポンス形式: `{ success: false, code, message, data: null }`

### `backend/src/routes/health.ts`

```
GET /api/v1/health
レスポンス: { success: true, code: '', message: 'OK', data: { status: 'ok' } }
```

### `backend/src/app.ts`

1. `express()` インスタンスを生成
2. `express.json()`, `cors()` を登録
3. `NODE_ENV === 'production'` の場合: `../frontend/dist` を静的ファイルとして配信
4. `/api/v1` にルーターをマウント（health ルートを含む）
5. 未マッチルートを `index.html` にフォールバック（本番時）
6. `errorHandler` を末尾に登録

### `backend/src/server.ts`

db との同期（`sequelize.sync()`）後に `app.listen(PORT)`。

### `docker-compose.yml`

- `postgres` サービス: `postgres:16-alpine`、`/opt/<project-name>/pgdata` に永続化
- `backend` サービス: Dockerfile でビルド、`NODE_ENV=production`
- `frontend/dist` を backend コンテナの `/app/frontend/dist` に `:ro` マウント
- `/opt/<project-name>/uploads` などの永続化ボリュームを定義

### `backend/Dockerfile`

マルチステージビルド（`node:20-alpine`）:

1. **builder**: `python3 make g++` を追加、`npm ci`, `npm run build`
2. **runner**: `node_modules`（production のみ）と `dist` をコピー

### `deploy.sh`

初回フルデプロイ:
1. `git clone` またはカレントディレクトリを使用
2. `npm install`（ルート）
3. `npm run build`（frontend）
4. `docker compose up -d --build`

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
