#!/bin/bash

PLIST="$HOME/Library/LaunchAgents/com.example.ytwallpaper.plist"

# サービスをアンロード
launchctl unload "$PLIST" 2>/dev/null || true

# plist ファイルを削除
rm -f "$PLIST"

echo "✅ アンインストール完了"
echo "📁 ~/yt-wallpaper フォルダは手動で削除できます"
