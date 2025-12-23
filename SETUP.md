# セットアップガイド

## クイックスタート

```bash
# 1. クローン
git clone https://github.com/yourname/yt-live-wallpaper.git
cd yt-live-wallpaper

# 2. update_wallpaper.sh を編集
# YOUR_VIDEO_ID_HERE を実際のYouTube URLに置き換え
nano update_wallpaper.sh

# 3. インストール実行
chmod +x install.sh
./install.sh

# 完了！5分ごとに壁紙が更新されます
```

## よくある設定

### YouTube URLの探し方

1. YouTube で動画を開く
2. ブラウザのアドレスバーから URL をコピー
3. `update_wallpaper.sh` の `URL=` の行に貼り付け

例：
```bash
URL="https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

### 更新頻度の変更

`com.example.ytwallpaper.plist` を編集：

```xml
<key>StartInterval</key>
<integer>300</integer>  <!-- 秒単位 -->
```

| 頻度 | 秒数 |
|------|------|
| 1分 | 60 |
| 5分 | 300 |
| 10分 | 600 |
| 30分 | 1800 |
| 1時間 | 3600 |

変更後は再インストール：
```bash
./install.sh
```

### yt-dlp と ffmpeg のパスをカスタマイズ

別の場所にインストール済みの場合：

```bash
which yt-dlp   # パスを確認
which ffmpeg   # パスを確認
```

出力されたパスを `update_wallpaper.sh` の以下の行に設定：

```bash
YTDLP="/your/path/to/yt-dlp"
FFMPEG="/your/path/to/ffmpeg"
```

## トラブルシューティング

### エラー: yt-dlp not found

```bash
which yt-dlp
# 出力がない場合はインストール
brew install yt-dlp
```

### エラー: ffmpeg not found

```bash
brew install ffmpeg
```

### 壁紙が更新されない

```bash
# スクリプトを手動実行
bash update_wallpaper.sh

# エラーログを確認
tail -100 ~/yt-wallpaper/launchd_error.log

# launchctl のステータス確認
launchctl list | grep ytwallpaper
```

### YouTube URLが機能しない

```bash
# yt-dlp で直接テスト
yt-dlp -f b -o - "YOUR_URL" | ffmpeg -i pipe:0 -frames:v 1 test.jpg

# 詳細情報を表示
yt-dlp "YOUR_URL" --dump-json | jq
```

## 詳細情報

- `update_wallpaper.sh` - メインのスクリプト
- `com.example.ytwallpaper.plist` - launchd 設定
- `~/yt-wallpaper/` - 作業ディレクトリ（ログと画像を保存）

## アンインストール

```bash
./uninstall.sh
```

`~/yt-wallpaper/` フォルダの内容は手動で削除できます：

```bash
rm -rf ~/yt-wallpaper
```
