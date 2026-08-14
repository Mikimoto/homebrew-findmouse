cask "findmouse" do
  # 兩段式 version：產出檔名是 FindMouse-<版本>-<shortsha>.dmg，光靠版本號組不出
  # 下載連結。version.csv.first/second 就是 Homebrew 給這種檔名的機制。
  # 兩個值都由上游的 Scripts/release.sh 跑完之後直接印在螢幕上。
  version "0.4.0,a214cd9"
  sha256 "adc7eeeaa2d8f4aecf4baa5aaad631b2cb6bb5b1fbf91d5176a0d54f0bb30f3a"

  url "https://github.com/Mikimoto/FindMouse/releases/download/v#{version.csv.first}/FindMouse-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.com/Mikimoto/FindMouse/"
  name "FindMouse"
  desc "Menu bar app that summons a cat to sit beside your lost cursor"
  homepage "https://github.com/Mikimoto/FindMouse"

  # 刻意沒有 livecheck。它的用途是讓維護者發現上游出了新版——而這裡的維護者就是
  # 上游，release.sh 跑完就把該換的兩個值印出來。加一個要跟兩段式 version 對齊的
  # 自訂 strategy，只是多一個會壞掉的活動零件。

  # 上游的 Package.swift 寫 macOS 14。裸符號就是「這版或更新」——`brew info` 對
  # 它回 `Required: macOS >= 14`（實測，與舊寫法逐字相同）。
  # 別寫成字串比較格式 ">= :sonoma"：cask 那邊是 deprecated 警告，
  # formula 那邊直接硬失敗（unknown or unsupported macOS version）。
  depends_on macos: :sonoma

  app "FindMouse.app"

  # 兩條路徑都是實測的：packs 與 control socket 在 Application Support/FindMouse/，
  # 設定走 UserDefaults.standard（bundle id tw.com.deepthought.findmouse）。
  zap trash: [
    "~/Library/Application Support/FindMouse",
    "~/Library/Preferences/tw.com.deepthought.findmouse.plist",
  ]

  caveats <<~CAVEATS
    命令列工具是分開的，要用腳本控制才需要：
      brew install mikimoto/findmouse/findmouse-cli

    zap 清不掉「開機時啟動」的註冊——那筆紀錄由系統保管（SMAppService／BTM），
    brew 碰不到。移除前先在設定視窗把那個勾關掉，或到
    「系統設定 → 一般 → 登入項目」移除。
  CAVEATS
end
