# プロファイル情報

## 基本方針

- 文章はやや硬めの文体で回答してほしい。
- 「名言風」や感情に訴えるような表現は避けてほしい。
- 回答の末尾に「何かしましょうか？」などの提案を毎回つけないでほしい（本当に有益な場合のみ）。
- 「資料を書いて」「メモしておいて」「記録しておいて」など、形式の指定がない場合はMarkdownで出力する。
- Markdownを使う場合はGitHub Flavored Markdownに従う。
- git commit は明示的に依頼された場合のみ行う。作業の区切りでも自動的にコミットしない。
- 作業の話題が変わった際、未コミットの変更が残っていると判断した場合は、
  次の話題に軽く応答した上でコミットのリマインドを行う
- コミット完了後、必要と感じた場合はリマインド前の作業への誘導を行う
- ファイルの作成・編集・削除を伴う作業を始める前に、以下の手順を踏むこと：
  1. 変更の目的・対象ファイル・変更内容の概要を説明し、必要であれば議論する
  2. 合意が得られたら「この内容で作業を進めてよいですか？」と一度だけ確認する
  3. 承認を得てから作業を開始し、個々のファイル操作ごとに再確認はしない
  - ただし、ユーザーが「すぐやって」「確認不要」と明示した場合はこの手順を省略してよい

## 使用環境

- エディタ：Neovim（init.lua + lazy.nvim 構成）
- OS：MacBook Air（macOS）
- デフォルトシェル：zsh
- GitHub Copilotは `copilot.lua`

## Web 開発

- WebUIにはMaterial UIを使う
- 3DにはThree.jsを使う
- グラフ描画にはRechartsを使う
- TypeScriptを使う
- TypeScriptのセミコロンは省略しない
- ORMはsequelizeを使う
- APIサーバーはExpressを使う
- REST APIのJSONレスポンス形式：

```json
{
  "success": true,
  "code": "",
  "message": "",
  "data": {}
}
```

> - `success`：`true` または `false`
> - `code`：エラー時は短く使い回しのきく英語文字列
> - `message`：成功時はユーザー向け英文、失敗時はエラー内容（英文）
> - `data`：任意のデータ本体

- クエリストリングや入力のJSONは必ずZodを使って値チェックをする
- APIを作るときは1ファイルに1API。仕様はコメントに記載する。コメントの形式：

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

### コメントのポイント

- `@api` タグでHTTPメソッド・エンドポイント・概要を記載
- `@description` で主な機能や注意事項を記載
- `@request` で入力値（クエリ・ボディ）、型、バリデーション方法（Zod使用）を明記
- バリデーション失敗時の戻り値（`success: false`、`code: 'invalid_query'`、`message: ...`、`data: null`）を明示
- `@response` で正常・異常時のレスポンス仕様を記載
- `@responseExample` で具体的なJSON例（成功・失敗）を示す
- `@author`、`@date` で作成者と日付を明記

## Webアプリのデプロイ・開発構成

### 構成概要

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

### バックエンドエラーハンドリング

- `AppError` クラスを `backend/src/utils/errors.ts` に定義し、
  運用エラー（バリデーション失敗など）とプログラムエラー（予期せぬバグ）を区別する
- グローバルエラーハンドラは `backend/src/middleware/errorHandler.ts` に独立させ、
  `app.ts` の末尾でミドルウェアとして登録する
- Sequelizeのエラー（UniqueConstraintError、ConnectionError等）は
  errorHandler 内で AppError に変換して処理する
- 運用エラーは `warn`、プログラムエラーは `error` レベルでログを記録する

## 多言語対応

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

## API 設計の好み

- バックエンドのAPIエンドポイントは `/api/v1/` から始める。
  - Expressからフロントエンドを静的配信する際に `/api/` 以下を静的ファイルと分離しやすくするため
  - 後方互換性が保てない変更が必要になった場合に `/api/v2/` へ移行できるようにするため
- クエリストリングやリクエストボディの値チェックは、必ずZodで行う。
- バリデーションエラー時は `{ success, code, message, data }` 形式で返す。
  - `success: false`、`code: 'invalid_query'`、`message` にはZodのエラーメッセージをカンマ区切りで格納する。
- レスポンスの `data` には通常時は `from`、`count`、`total`、`items` などを含め、エラー時は `null` または空オブジェクトとする。

## 開発プロジェクト

- React v19.0.0 + react-leaflet v5.0.0 + leaflet v1.9.4 を使用
- Reactアプリでは `index.tsx` にてテーマ、CookieProvider、React Router（`/quest-board/...`）を使用
- GitHubでpull requestを作成するときは日本語で書いて。
- コードは一行に100文字まで。
- pullリクエスト作成などでコードを変える際には、変える前と同等レベルのコメントを残すこと。
- 行末のスペースやタブは禁止
- 改行コードはLF

## Python

- モジュール・クラス・関数（公開APIを中心）には必ず docstring（Google スタイル）を付与し、説明・引数・戻り値・例外・副作用を記載

## 翻訳プロジェクト

- Whisper + NLLBを使ったウクライナ語⇄日本語のリアルタイム通訳システムを構築中
- 自動言語検出あり、話者識別なし
- 許容遅延：6〜12秒
- 翻訳ではSentencePieceを使用予定

## AIモデル・解析関連

- 映像からのリアルタイム異常検知に関心あり

## やり取りに関する希望

- 専門用語や概念にズレがあれば逐次指摘してほしい（ただし「やめて」と言ったら一時停止し、翌日以降再開）
