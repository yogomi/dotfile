# 映像・動画処理ルール

## ffmpeg エンコード方針

動画を加工・再エンコードする際は、**元のコーデックを維持する**ことを基本方針とする。
環境変数 `USE_GPU=true` が設定されている場合は NVIDIA NVENC を使用する。

| 入力コーデック | GPU あり | GPU なし |
|--------------|---------|---------|
| hevc (H.265) | `hevc_nvenc` | `libx265` |
| h264 (H.264) | `h264_nvenc` | `libx264` |
| av1 | `libsvtav1`（NVENC 非対応） | `libsvtav1` |
| vp9 | `libvpx-vp9`（NVENC 非対応） | `libvpx-vp9` |
| vp8 | `libvpx`（NVENC 非対応） | `libvpx` |
| その他 | `h264_nvenc` | `libx264`（H.264 に変換） |

- Docker 本番環境では `docker-compose.yml` に `USE_GPU=true` と GPU デバイス設定を追加する
- GPU デバイスの capabilities は `[gpu, video]` が必要（`video` がないと NVENC ライブラリがマウントされない）
- 開発環境（`npm run dev` 等）では `USE_GPU` 未設定で CPU フォールバックとなり、GPU がなくても動作する

## B フレームと `-bf 0`

NVENC でエンコードする際、以下の条件に該当する場合は `-bf 0`（B フレーム無効）を outputOptions に追加する。

- 入力動画のタイムベースが非標準（`16k tbn` など高い値）の場合
  → NVENC の B フレームが mp4 muxer の PTS/DTS 制約に違反し `pts/dts pair unsupported` が発生する
- リアルタイム配信・低遅延が求められる場合
  → B フレームはデコーダーの先読みが必要なため遅延が増える
- 組み込み機器や古いハードウェアデコーダーとの互換性が必要な場合

`-bf 0` によりファイルサイズは同品質で 10〜20% 程度増えるが、クリップ生成などの用途では許容範囲。
CPU エンコーダー（libx264/libx265 等）では B フレームの PTS/DTS 処理が正しく行われるため、通常は不要。
