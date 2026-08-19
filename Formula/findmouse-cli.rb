class FindmouseCli < Formula
  desc "Command-line client for the FindMouse menu bar app"
  homepage "https://github.com/Mikimoto/FindMouse"
  url "https://github.com/Mikimoto/FindMouse/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "a5ab44d0aa55bf04276b175f561e8b70650dccf09088f97da9e0ff67ac49ffa3"
  license "Apache-2.0"

  # 從原始碼建而不是發預編二進位：實測乾淨編譯 6.26 秒、505,816 bytes、
  # SwiftPM 自動 ad-hoc 簽章。findmouse 只相依 FindMouseCLICore ＋ FindMouseWire，
  # 碰不到 AppKit 也不含資源，所以 --product findmouse 不會去編那個 App。
  # 省下的是 universal binary 的產生與驗證、一個額外的 release asset、
  # 以及那個 asset 的 sha256 維護。
  #
  # 16.0 取自上游的 swift-tools-version: 6.0，**不是量出來的**——
  # 上游作者的機器上只有 Xcode 27 的 beta，沒有 Xcode 16 的樣本。
  # （不寫是哪一個 beta：那個號碼每次更新就爛掉一次，而它不是重點。）
  depends_on xcode: ["16.0", :build]
  # 裸符號＝這版或更新。字串比較格式 ">= :sonoma" 在 formula 是**硬失敗**
  # （`unknown or unsupported macOS version`，實測），不是像 cask 那樣只吐警告。
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "findmouse"
    bin.install ".build/release/findmouse"
  end

  test do
    # 探針只能用 --help。`findmouse --version` **不存在**（實測 exit 2、
    # 「未知命令：--version」），照抄慣例寫 --version 會直接紅。
    assert_match "用法：findmouse", shell_output("#{bin}/findmouse --help")

    # FINDMOUSE_SOCKET 指到一個不存在的路徑，否則這條斷言的結果取決於**跑測試那台
    # 機器上 App 有沒有在跑**：App 在跑時 status 回 exit 0，這條就紅了。
    ENV["FINDMOUSE_SOCKET"] = "#{testpath}/nope.sock"
    assert_match "APP_NOT_RUNNING", shell_output("#{bin}/findmouse status --json", 3)
  end
end
