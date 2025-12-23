# yt-live-wallpaper (macOS)

YouTube Live を **5分おきに静止画取得して macOS 壁紙に自動更新**するツール。

## 必要環境

- macOS
- Homebrew
- yt-dlp
- ffmpeg

### 依存ツールのインストール

```bash
brew install yt-dlp ffmpeg
```

## セットアップ

### 1. リポジトリをクローン

```bash
git clone https://github.com/yourname/yt-live-wallpaper.git
cd yt-live-wallpaper
```

### 2. YouTube URLを設定

`update_wallpaper.sh` の以下の行を編集してください：

```bash
URL="https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE"
```

YouTube Live のURLに置き換えます（例：`https://www.youtube.com/watch?v=dQw4w9WgXcQ`）

### 3. インストール実行

```bash
chmod +x install.sh
./install.sh
```

インストール完了後、5分ごとに壁紙が自動更新されます。

## 使い方

### 動作確認

```bash
# 手動で1回実行
bash update_wallpaper.sh

# ログを確認
tail -f ~/yt-wallpaper/launchd.log
tail -f ~/yt-wallpaper/launchd_error.log
```

### 更新間隔の変更

`com.example.ytwallpaper.plist` の以下の行を編集：

```xml
<key>StartInterval</key>
<integer>300</integer>  <!-- 秒単位（300秒=5分） -->
```

例：10分にしたい場合は `600` に変更

### サービスの停止・再開

```bash
# 停止
launchctl unload ~/Library/LaunchAgents/com.example.ytwallpaper.plist

# 再開
launchctl load ~/Library/LaunchAgents/com.example.ytwallpaper.plist

# ステータス確認
launchctl list | grep ytwallpaper
```

## アンインストール

```bash
./uninstall.sh
```

## 仕組み

- **自動実行**: `launchd` が5分ごとにスクリプトを実行
- **画像交互生成**: image1.jpg と image2.jpg を交互に作成（ディスク容量節約）
- **古い画像削除**: 前のサイクルの画像を削除
- **壁紙更新**: current.jpg を全デスクトップに設定

## ディレクトリ構造

```
~/yt-wallpaper/
├── image1.jpg          # 前フレーム
├── image2.jpg          # 現在のフレーム
├── current.jpg         # 壁紙として使用中（シンボリックリンク）
├── state.txt           # 現在のステート（1 or 2）
├── launchd.log         # 標準出力ログ
└── launchd_error.log   # エラーログ
```

## トラブルシューティング

### 壁紙が更新されない

```bash
# 詳細なログを確認
tail -50 ~/yt-wallpaper/launchd_error.log

# サービスが正しく登録されているか確認
launchctl list | grep ytwallpaper

# スクリプトが実行可能か確認
ls -la /path/to/update_wallpaper.sh
```

### YouTube URLが無効

- 公開動画（非公開・削除済みでない）であることを確認
- URLが正しい形式であることを確認
- `yt-dlp --version` で yt-dlp がインストールされているか確認

## ライセンス

MIT License

## 作成者

Create your own awesome project!

---

**Tips**: このツールは任意のYouTube動画に対応しています。Live配信でなくても使用可能です。
