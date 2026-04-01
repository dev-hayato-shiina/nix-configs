{

  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.zsh ];

  config = {
    package = pkgs.zsh;

    # グローバルRCの影響を排除（再現性確保）
    skipGlobalRC = true;

    # Home Managerを使わないので無効化
    hmSessionVariables = null;

    # 環境変数（home.sessionVariables 相当）
    zshenv.content = ''
      export LANG=en_US.UTF-8
    '';

    # エイリアス（programs.zsh.shellAliases）
    zshAliases = {
      ".."       = "cd ..";
      "...."     = "cd ../..";
      "......"   = "cd ../../..";
      "........" = "cd ../../../..";

      rebuild = ''sudo nixos-rebuild switch --flake "path:/etc/nixos#agate"'';
      gc-clear = "sudo nix-collect-garbage -d";
      grep = "rg";

      discord = "env DISPLAY=:1 TZ=Asia/Tokyo flatpak run com.discordapp.Discord --env=TZ=Asia/Tokyo";
    };

    # .zshrc（そのまま移植）
    zshrc.content = builtins.readFile ./zshrc;

    # （任意）.p10k.zsh をwrapperに含める
    zlogin.content = ''
      [[ -f ${./p10k.zsh} ]] && source ${./p10k.zsh}
    '';
  };
}
