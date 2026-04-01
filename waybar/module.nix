{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.waybar ];

  config = {
    package = pkgs.waybar;

    settings = {
      layer = "top";    # 他のウィンドウより前面に表示する
      position = "top"; # 画面上部に配置する
      height = 24;      # バーの高さ（px）
      spacing = 5;      # モジュール間の余白（px）
      margin-top = 5;   # 画面上端からの余白（px）

      # 左側: アプリケーション起動ボタンを並べる
      modules-left = [
        "custom/launcher"  # アプリランチャー（Wofi）
        "custom/bitwarden" # Bitwarden
        "custom/chrome"    # Google Chrome
        "custom/discord"   # Discord
      ];

      # 中央: 時計を表示する
      modules-center = [ "clock" ];

      # 右側: システム情報・通知領域を並べる
      modules-right = [
        "mpd"            # 音楽プレーヤー（MPD）
        "idle_inhibitor" # スリープ抑制トグル
        "temperature"    # CPU 温度
        "cpu"            # CPU 使用率
        "memory"         # メモリ使用率
        "network"        # ネットワーク接続状態
        "pulseaudio"     # 音量
        "backlight"      # 画面輝度
        "keyboard-state" # NumLock / CapsLock 状態
        "battery"        # バッテリー残量（BAT1）
        "battery#bat2"   # バッテリー残量（BAT2）
        "tray"           # システムトレイ
        "custom/power"   # 電源メニュー
      ];

      # アプリランチャーボタン: クリックで Wofi（drun モード）を起動する
      "custom/launcher" = {
        format = "🔍";
        on-click = "${pkgs.wofi}/bin/wofi --show drun";
        tooltip = false;
      };

      # Bitwarden ボタン: クリックで Bitwarden デスクトップアプリを起動する
      "custom/bitwarden" = {
        format = "🔐";
        on-click = "${pkgs.bitwarden-desktop}/bin/bitwarden";
        tooltip-format = "Bitwarden";
      };

      # Chrome ボタン: クリックで Google Chrome を起動する
      "custom/chrome" = {
        format = "🌐";
        on-click = "${pkgs.google-chrome}/bin/google-chrome-stable";
        tooltip-format = "Chrome";
      };

      # Discord ボタン: クリックで起動通知を表示しつつ DISPLAY=:1（XWayland）で Discord を起動する
      "custom/discord" = {
        format = "💬";
        on-click = "notify-send -t 3000 -i discord 'Discord' '起動中...' & env DISPLAY=:1 TZ=Asia/Tokyo ${pkgs.flatpak}/bin/flatpak run com.discordapp.Discord --env=TZ=Asia/Tokyo";
        tooltip-format = "Discord";
      };

      # 電源ボタン: クリックで電源メニュースクリプトを実行する
      # "custom/power" = {
        # format = "⏻";
        # on-click = "${config.xdg.configHome}/waybar/scripts/powermenu.sh";
        # tooltip-format = "Power Menu";
      # };

      # NumLock / CapsLock のロック状態をアイコンで表示する
      "keyboard-state" = {
        numlock = true;
        capslock = true;
        format = "{name} {icon} ";
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };

      # Sway のモード名（resize など）をイタリック体で表示する
      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };

      # Sway のスクラッチパッドにウィンドウがある場合にアイコンと件数を表示する
      "sway/scratchpad" = {
        format = "{icon} {count}";
        show-empty = false;
        format-icons = {
          empty = "";
          full = "";
        };
        tooltip = true;
        tooltip-format = "{app}: {title}";
      };

      # MPD（Music Player Daemon）の再生状態・曲情報を表示する
      mpd = {
        format = "  {title} - {artist} {stateIcon} [{elapsedTime:%M:%S}/{totalTime:%M:%S}] {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}[{songPosition}/{queueLength}] [{volume}%]";
        format-disconnected = " Disconnected";
        format-stopped = " {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped";
        unknown-tag = "N/A";
        interval = 2;    # 更新間隔（秒）
        consume-icons = {
          on = " ";     # コンシュームモード有効時のアイコン
        };
        random-icons = {
          on = " ";     # ランダム再生有効時のアイコン
        };
        repeat-icons = {
          on = " ";     # リピート有効時のアイコン
        };
        single-icons = {
          on = " 1 ";   # シングル再生有効時のアイコン
        };
        state-icons = {
          paused = "";  # 一時停止中のアイコン
          playing = ""; # 再生中のアイコン
        };
        tooltip-format = "MPD (connected)";
        tooltip-format-disconnected = "MPD (disconnected)";
        on-click = "mpc toggle";                    # クリックで再生・一時停止をトグルする
        on-click-right = "foot -a ncmpcpp ncmpcpp"; # 右クリックで ncmpcpp を起動する
        on-scroll-up = "mpc volume +2";             # スクロールアップで音量を上げる
        on-scroll-down = "mpc volume -2";           # スクロールダウンで音量を下げる
      };

      # スリープ・スクリーンセーバーの抑制をトグルするボタン
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";   # 抑制中（スリープしない）
          deactivated = ""; # 通常（スリープあり）
        };
      };

      # システムトレイ（常駐アプリのアイコン表示領域）
      tray = {
        spacing = 10; # アイコン間の余白（px）
      };

      # 時計: 日本語フォーマットで日付・時刻を表示し、ツールチップにカレンダーを表示する
      clock = {
        format = "{:%Y年%m月%d日(%a) %H:%M}";
        locale = "ja_JP.UTF-8";
        tooltip-format = "<big>{:%Y年%m月}</big>\n<tt><small>{calendar}</small></tt>";
      };

      # CPU 使用率をアイコン付きで表示する
      cpu = {
        format = "  {usage}%";
      };

      # メモリ使用率をアイコン付きで表示する
      memory = {
        format = " {}%";
      };

      # CPU 温度を表示する（80°C 以上でクリティカル表示）
      temperature = {
        thermal-zone = 2;
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input"; # 温度センサーのパス
        critical-threshold = 80; # クリティカル判定の閾値（°C）
        format-critical = "{icon} {temperatureC}°C";
        format = "{icon} {temperatureC}°C";
        format-icons = [
          ""
          ""
          ""
        ];
      };

      # 画面輝度をアイコン付きで表示する
      backlight = {
        format = "{icon} {percent}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };

      # バッテリー残量を表示する（30% 以下で警告、15% 以下でクリティカル）
      battery = {
        states = {
          warning = 30;  # 警告状態の閾値（%）
          critical = 15; # クリティカル状態の閾値（%）
        };
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%"; # 充電中
        format-plugged = " {capacity}%";   # AC 接続中
        format-alt = "{icon}  {time}";      # 残り時間表示（代替フォーマット）
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      # 2 本目のバッテリー（BAT2）を表示する
      "battery#bat2" = {
        bat = "BAT2";
      };

      # ネットワーク接続状態を表示する
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";    # Wi-Fi 接続時
        format-ethernet = " {ifname}";                  # 有線接続時
        tooltip-format = " {ifname} via {gwaddr}";      # ツールチップ
        format-linked = " {ifname} (No IP)";            # リンクあり・IP なし
        format-disconnected = "Disconnected ⚠ {ifname}"; # 未接続
        format-alt = " {ifname}: {ipaddr}/{cidr}";      # IP アドレス表示（代替フォーマット）
      };

      # 音量を表示する（クリックで pavucontrol、右クリックで pw-top を起動する）
      pulseaudio = {
        scroll-step = 5; # スクロール1回あたりの音量変化量（%）
        format = "{icon}  {volume}% {format_source}";
        format-bluetooth = " {icon} {volume}% {format_source}"; # Bluetooth 接続時
        format-bluetooth-muted = "  {icon} {format_source}";   # Bluetooth ミュート時
        format-muted = "  {format_source}"; # ミュート時
        format-source = " {volume}%";       # マイク入力
        format-source-muted = "";           # マイクミュート時
        format-icons = {
          default = [ # 音量に応じたアイコン（小・中・大）
            ""
            ""
            ""
          ];
        };
        on-click = "pavucontrol";                 # クリックで音量ミキサーを起動する
        on-click-right = "foot -a pw-top pw-top"; # 右クリックで PipeWire モニターを起動する
      };
    };

    "style.css".path = "./style.css";
  };
}
