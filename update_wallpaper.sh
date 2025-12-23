#!/bin/bash
set -e

### 設定 ###
# ここにYouTube URLを設定してください
# 例: https://www.youtube.com/watch?v=dQw4w9WgXcQ
URL="https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE"

BASE_DIR="$HOME/yt-wallpaper"
STATE="$BASE_DIR/state.txt"
IMG1="$BASE_DIR/image1.jpg"
IMG2="$BASE_DIR/image2.jpg"
TARGET="$BASE_DIR/current.jpg"

YTDLP="/opt/homebrew/bin/yt-dlp"
FFMPEG="/opt/homebrew/bin/ffmpeg"

# ディレクトリとステートファイルの初期化
mkdir -p "$BASE_DIR"
touch "$STATE"

# 現在のステートを読み込み
STATE_VAL=$(cat "$STATE")

# 交互に画像ファイルを切り替え
if [ "$STATE_VAL" = "1" ]; then
  NEXT_IMG="$IMG2"
  echo "2" > "$STATE"
else
  NEXT_IMG="$IMG1"
  echo "1" > "$STATE"
fi

# 古い画像を削除（ディスク容量節約）
rm -f "$NEXT_IMG"

# YouTube から静止画を取得
# 失敗してもエラーで終了しない（exit 0でリカバリ）
"$YTDLP" -f b -o - "$URL" \
| "$FFMPEG" -loglevel quiet -y -i pipe:0 -frames:v 1 "$NEXT_IMG" || exit 0

# current.jpg をシンボリックリンク更新
ln -sf "$NEXT_IMG" "$TARGET"

# macOS の壁紙を更新（全デスクトップ対応）
osascript <<EOF
tell application "System Events"
    set picture of every desktop to (POSIX file "$TARGET")
end tell
EOF
