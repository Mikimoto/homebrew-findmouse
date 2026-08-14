# homebrew-findmouse

[FindMouse](https://github.com/Mikimoto/FindMouse) 的 Homebrew tap。

```sh
brew tap mikimoto/findmouse
brew install --cask findmouse        # 選單列 App
brew install findmouse-cli           # 命令列工具（可選，從原始碼建，需要 Xcode）
```

## 為什麼是自建 tap 而不是 homebrew-core／homebrew-cask

那兩邊都有專案知名度與發布史的門檻，FindMouse 現在還不符合。

## 為什麼是兩個名字

cask 叫 `findmouse`（App），formula 叫 `findmouse-cli`（命令列工具）。
同一個 tap 裡兩者同名會讓 `brew install findmouse` 有歧義。
formula 名與它裝出來的執行檔名不同是常態——`findmouse-cli` 裝出來的是 `findmouse`。

App 本身**不夾帶** CLI：上游規劃的沙盒版是唯一的 App 變體，需要 CLI 的人從這裡單獨裝。

## 發新版時要換什麼

上游的 `Scripts/release.sh` 跑完會把值印出來：

- `Casks/findmouse.rb` 的 `version`（兩段式，`<版本>,<shortsha>`）與 `sha256`
- `Formula/findmouse-cli.rb` 的 tag 與 tarball 的 `sha256`（要等 tag 推上 GitHub 才算得出來）
