# Web開発ルール

## 技術スタック

- WebUIにはMaterial UIを使う
- 3DにはThree.jsを使う
- グラフ描画にはRechartsを使う
- TypeScriptを使う
- TypeScriptのセミコロンは省略しない
- ORMはsequelizeを使う
- APIサーバーはExpressを使う
- フロントエンドのHTTPクライアントはfetchを使う（axiosは使わない）。ラッパーは `frontend/src/utils/api.ts` に置く
- LintにはESLint（v9 flat config）+ `typescript-eslint` を使う
- フロントエンドは追加で `eslint-plugin-react-hooks` を導入する
- コードフォーマットにはPrettierを使う（ルートの `.prettierrc` で一元管理）
- `lint`・`format`・`typecheck` スクリプトを各パッケージおよびルートに用意する
- MQTTを使う場合はRabbitMQを使う

## プロジェクト構成

- React v19.0.0 + react-leaflet v5.0.0 + leaflet v1.9.4 を使用
- Reactアプリでは `index.tsx` にてテーマ、CookieProvider、React Router（`/quest-board/...`）を使用

## アプリ構成・デプロイ

### 概要

- フロントエンド: Vite + React（TypeScript）
- バックエンド: Express + sequelize-typescript
- ルートに `frontend/` と `backend/` を置き、npm workspaces で管理する
- ルートの `.gitignore` に `backend/data/` を追加する（SQLiteファイルの除外）

### 開発時

- DBはSQLiteを使い、Dockerなしで起動できるようにする
- `NODE_ENV` が `production` 以外の場合は SQLite、`production` の場合は PostgreSQL に切り替える
- SQLiteのファイルパスは `DB_PATH` 環境変数で上書きできるようにする

### 本番デプロイ

- Docker Compose で postgres + backend の2サービス構成にする
- フロントエンドの `dist` はホスト側でビルドし、バックエンドコンテナに `:ro` でボリュームマウントする
- 本番時、バックエンドの Express からフロントエンドの静的ファイルを配信する
- 未マッチのルートは `index.html` にフォールバックする
- DBデータ・アップロードファイル等の永続化は `/opt/<プロジェクト名>/` 以下にマウントする
- バックエンドの Dockerfile はマルチステージビルド（node:20-alpine）
- SQLite のネイティブビルドのため、Dockerfile のビルダーステージに `python3 make g++` を追加する
- バックエンドに `GET /api/health` エンドポイントを設け、ヘルスチェックに使う
- `deploy.sh`（初回フルデプロイ）と `update.sh`（git pull → 差分ビルド → 再起動）を用意する

## API 設計

- バックエンドのAPIエンドポイントは `/api/v1/` から始める
  - Expressからフロントエンドを静的配信する際に `/api/` 以下を静的ファイルと分離しやすくするため
  - 後方互換性が保てない変更が必要になった場合に `/api/v2/` へ移行できるようにするため
- クエリストリングやリクエストボディの値チェックは、必ずZodで行う
- バリデーションエラー時は `{ success, code, message, data }` 形式で返す
  - `success: false`、`code: 'invalid_query'`、`message` にはZodのエラーメッセージをカンマ区切りで格納する
- レスポンスの `data` には通常時は `from`、`count`、`total`、`items` などを含め、エラー時は `null` または空オブジェクトとする
- APIを作るときは1ファイルに1API

### REST APIのJSONレスポンス形式

```json
{
  "success": true,
  "code": "",
  "message": "",
  "data": {}
}
```

- `success`：`true` または `false`
- `code`：エラー時は短く使い回しのきく英語文字列
- `message`：成功時はユーザー向け英文、失敗時はエラー内容（英文）
- `data`：任意のデータ本体

### APIファイルのコメント形式

```javascript
/**
 * @api {HTTPメソッド} /エンドポイント 概要説明
 * @description
 *   - 機能の簡潔な説明
 *   - 必要に応じて注意事項や利用例を記載
 *
 * @request
 *   - クエリストリング/リクエストボディの各パラメータと型・説明
 *   - バリデーションはzodで行うこと
 *   - バリデーション失敗時は { success: false, code: 'invalid_query', message: 'エラー内容', data: null }
 *
 * @response
 *   - 例: { success: true, code: '', message: '正常終了メッセージ', data: { from, count, total, items } }
 *   - エラー時: { success: false, code: 'error_code', message: 'エラー内容', data: null }
 *
 * @responseExample 成功例
 *   {
 *     "success": true,
 *     "code": "",
 *     "message": "Success message",
 *     "data": {
 *       "from": 0,
 *       "count": 10,
 *       "total": 100,
 *       "items": [ ... ]
 *     }
 *   }
 *
 * @responseExample 失敗例
 *   {
 *     "success": false,
 *     "code": "invalid_query",
 *     "message": "エラー内容（英文）",
 *     "data": null
 *   }
 *
 * @author 作成者
 * @date YYYY-MM-DD
 */
```

- `@api` タグでHTTPメソッド・エンドポイント・概要を記載
- `@description` で主な機能や注意事項を記載
- `@request` で入力値（クエリ・ボディ）、型、バリデーション方法（Zod使用）を明記
- バリデーション失敗時の戻り値（`success: false`、`code: 'invalid_query'`、`message: ...`、`data: null`）を明示
- `@response` で正常・異常時のレスポンス仕様を記載
- `@responseExample` で具体的なJSON例（成功・失敗）を示す
- `@author`、`@date` で作成者と日付を明記

## バックエンドエラーハンドリング

- `AppError` クラスを `backend/src/utils/errors.ts` に定義し、
  運用エラー（バリデーション失敗など）とプログラムエラー（予期せぬバグ）を区別する
- グローバルエラーハンドラは `backend/src/middleware/errorHandler.ts` に独立させ、
  `app.ts` の末尾でミドルウェアとして登録する
- Sequelizeのエラー（UniqueConstraintError、ConnectionError等）は
  errorHandler 内で AppError に変換して処理する
- 運用エラーは `warn`、プログラムエラーは `error` レベルでログを記録する

## 多言語対応（i18n）

- i18next + react-i18next を使用する
- 翻訳リソースは `frontend/src/i18n.ts` に言語ごとのオブジェクトとしてまとめる
- `frontend/src/index.tsx` で `I18nextProvider` をルートに配置する
- 各コンポーネントでは `useTranslation()` フックで呼び出す
- 多言語対応が必要なプロジェクトでは明示するので、その都度適用する

## フロントエンド通知（Snackbar）

- グローバルな `SnackbarContext` を `frontend/src/app/SnackbarContext.tsx` に作成する
- `frontend/src/index.tsx` で `SnackbarProvider` をルートに配置する
- `useSnackbar()` フックで severity（success / error / warning / info）と
  message を指定してどこからでも呼び出せるようにする
- MUIの `Snackbar` + `Alert` を組み合わせて表示する
