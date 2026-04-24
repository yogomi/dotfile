以下の内容を私のプロファイル情報として認識してほしい：

【基本方針】
- 文章はやや硬めの文体で回答してほしい。
- 「名言風」や感情に訴えるような表現は避けてほしい。
- 回答の末尾に「何かしましょうか？」などの提案を毎回つけないでほしい（本当に有益な場合のみ）。
- ファイルの作成・編集・削除を伴う作業を始める前に、以下の手順を踏むこと：
  1. 変更の目的・対象ファイル・変更内容の概要を説明し、必要であれば議論する
  2. 合意が得られたら「この内容で作業を進めてよいですか？」と一度だけ確認する
  3. 承認を得てから作業を開始し、個々のファイル操作ごとに再確認はしない
  - ただし、ユーザーが「すぐやって」「確認不要」と明示した場合はこの手順を省略してよい

【使用環境】
- エディタ：Neovim（init.lua + lazy.nvim 構成）
- OS：MacBook Air（macOS）
- デフォルトシェル：zsh
- GitHub Copilotは `copilot.lua` 

【web開発】
- TypeScriptを使う
- TypeScriptのセミコロンは省略しない
- ORMはsequelizeを使う
- APIサーバーはExpressを使う
- REST APIのjsonは
{
  "success": true,           // または false
  "code": "",                // エラー時は短く使い回しのきく英語文字列
  "message": "",             // 成功時はユーザー向け英文、失敗時はエラー内容（英文）
  "data": {}                 // 任意：データ本体
}
- クエリストリングや入力のjsonは必ずZodを使って値チェックをする
- APIを作るときは1ファイルに1API。仕様はコメントに記載する。コメントでの使用の形式は以下の通り。

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

ポイント
@api タグでHTTPメソッド・エンドポイント・概要を記載
@description で主な機能や注意事項を記載
@request で入力値（クエリ・ボディ）、型、バリデーション方法（zod使用）を明記
バリデーション失敗時の戻り値（success: false, code: 'invalid_query', message: ..., data: null）を明示
@response で正常・異常時のレスポンス仕様を記載
@responseExample で具体的なJSON例（成功・失敗）を示す
@author, @date で作成者と日付を明記

【API設計の好み】
- クエリストリングやリクエストボディの値チェックは、必ずzodで行う。
- バリデーションエラー時は、REST APIのjsonレスポンス（{success, code, message, data}形式）で、success: false・code: 'invalid_query'・messageにはzodのエラーメッセージをカンマ区切りで格納して返す。
- レスポンスのdataには通常時はfrom, count, total, itemsなどを含め、エラー時はnullまたは空オブジェクトとする。

【開発プロジェクト】
- React v19.0.0 + react-leaflet v5.0.0 + leaflet v1.9.4 を使用
- Reactアプリでは `index.tsx` にてテーマ、CookieProvider、React Router（`/quest-board/...`）を使用
- GitHubでpull requestを作成するときは日本語で書いて。
- コードは一行に100文字まで。
- pullリクエスト作成などでコードを変える際には、変える前と同等レベルのコメントを残すこと。
- 行末のスペースやタブは禁止
- 改行コードはLF

【Python】
- モジュール・クラス・関数（公開APIを中心）には必ず docstring（Google スタイル）を付与し、説明・引数・戻り値・例外・副作用を記載

【翻訳プロジェクト】
- Whisper + NLLBを使ったウクライナ語⇄日本語のリアルタイム通訳システムを構築中
- 自動言語検出あり、話者識別なし
- 許容遅延：6〜12秒
- 翻訳ではSentencePieceを使用予定

【AIモデル・解析関連】
- LLaMA 4を物体検知などの文脈で使用予定
- YOLOv10 または RT-DETR も使用予定
- 映像からのリアルタイム異常検知に関心あり

【投資・ビジネス】
- BLOCK INCの株を20株（購入価格：55.02ドル）保有
- キャッシュレス決済銘柄に関心あり
- 海外旅行好きな層向けにストリート系Tシャツを販売予定（Printful + Etsy）
- SNSではInstagramとXを活用予定

【やり取りに関する希望】
- 専門用語や概念にズレがあれば逐次指摘してほしい（ただし「やめて」と言ったら一時停止し、翌日以降再開）
