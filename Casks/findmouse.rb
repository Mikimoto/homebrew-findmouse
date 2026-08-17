cask "findmouse" do
  # 兩段式 version：產出檔名是 FindMouse-<版本>-<shortsha>.dmg，光靠版本號組不出
  # 下載連結。version.csv.first/second 就是 Homebrew 給這種檔名的機制。
  # 兩個值都由上游的 Scripts/release.sh 跑完之後直接印在螢幕上。
  version "0.5.0,834a98f"
  sha256 "314da96338a780c538f8921705422bac788684a4fed2d95269664a0e0108020f"

  url "https://github.com/Mikimoto/FindMouse/releases/download/v#{version.csv.first}/FindMouse-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.com/Mikimoto/FindMouse/"
  name "FindMouse"
  desc "Menu bar app that summons a cat to sit beside your lost cursor"
  homepage "https://github.com/Mikimoto/FindMouse"

  # 刻意沒有寫 `livecheck do` 區塊。**但這不等於沒有 livecheck**——Homebrew 會從
  # 上面那個 GitHub release url 推一個預設策略出來，而它只吐得出 `0.5.0`，
  # 認不得兩段式 version。後果是 `brew audit --online` **必定**報一筆
  # 「Version '<版本>,<sha>' differs from '<版本>' retrieved by livecheck」——
  # 對的版本也一樣報（v0.5.0 這一輪實測：更新前後都報，只是被比較的字串換了）。
  #
  # 這一筆是已知的假陽性，不是待修：要它閉嘴就得寫一個把 short sha 也組進去的
  # 自訂 strategy，而那正是「多一個會壞掉的活動零件」——維護者就是上游本人，
  # release.sh 跑完直接把該換的兩個值印在螢幕上，不需要別人來提醒。
  # 所以驗這個 cask 用 `brew audit --cask`（不帶 --online，實測乾淨）。

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
