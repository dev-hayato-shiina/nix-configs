# Zsh

ビルド
```sh
cd ~/nix-configs/zsh && nix build "path:."
```

ビルドした Zsh を起動する
```sh
~/nix-configs/zsh/result/bin/zsh
```

ビルド直後 → 「設定ファイル未ロード状態のZsh」
`exec zsh` 後 → 「wrapper前提の完全初期化済みZsh」
```sh
exec zsh
```

シェルプロセスの終了
```sh
exit
```
