{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.niri ];

  config = {
    package = pkgs.niri;

    "config.kdl".content = ''
      environment {
        DISPLAY ":1"
      }

      input {
        mouse {}
      }

      spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${./img/img-1.jpg}" "-m" "fill"

      layout {
        gaps 5
        focus-ring {
          width 3
          active-color "rgba(50, 160, 250, 1)"
          inactive-color "#00000000"
        }
      }

      window-rule {
        geometry-corner-radius 5
        clip-to-geometry true
      }

      window-rule {
        match app-id="Alacritty"
        open-maximized true
      }

      binds {
        "Mod+Shift+E" {
          quit
        }

        Mod+Return {
          spawn "${pkgs.alacritty}/bin/alacritty"
        }

        Mod+Q {
          close-window
        }

        Mod+R { switch-preset-column-width; }

        Mod+F { maximize-column; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
      }
    '';

    extraPackages = with pkgs; [
      alacritty
      swaybg
      xwayland-satellite
    ];
  };
}
