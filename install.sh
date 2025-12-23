#!/bin/bash

set -e

# リポジトリディレクトリを取得
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_DIR="$HOME/Library/LaunchAgents"
PLIST_SRC="$REPO_DIR/com.example.ytwallpaper.plist"
PLIST_DST="$AGENT_DIR/com.example.ytwallpaper.plist"

# 必要なディレクトリを作成
mkdir -p "$HOME/yt-wallpaper"
mkdir -p "$AGENT_DIR"

# plist ファイルをコピー（USERNAMEを現在のユーザーに置換）
sed "s|/Users/USERNAME|$HOME|g" "$PLIST_SRC" > "$PLIST_DST"

# スクリプトを実行可能に
chmod +x "$REPO_DIR/update_wallpaper.sh"

# launchd に登録（既に登録されていればアンロード）
launchctl unload "$PLIST_DST" 2>/dev/null || true
launchctl load "$PLIST_DST"

# 即座にサービスを開始
launchctl start com.example.ytwallpaper

echo "✅ インストール完了！"
echo "📝 update_wallpaper.sh の URL を設定してください"
echo "⏰ 5分ごとに壁紙が更新されます"
echo ""
echo "ステータス確認: launchctl list | grep ytwallpaper"
echo "ログ確認: tail -f ~/yt-wallpaper/launchd.log"
