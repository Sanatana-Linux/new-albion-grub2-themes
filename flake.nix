{
  description = "New Albion GRUB2 themes with customizable backgrounds and styles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in
    with nixpkgs.lib; rec {
      nixosModules.default = {config, ...}: let
        cfg = config.boot.loader.grub.new-albion-theme;
        resolutions = {
          "1080p" = "1920x1080";
          "2k" = "2560x1440";
          "4k" = "3840x2160";
        };
        new-albion-grub-theme = pkgs.stdenv.mkDerivation {
          pname = "new-albion-grub-theme";
          version = "1.0.0";
          src = "${self}";
          
          nativeBuildInputs = with pkgs; [
            imagemagick
            inkscape
          ];
          
          buildPhase = ''
            runHook preBuild
            
            # Generate theme using the project's generate script
            bash ./generate.sh \
              --theme ${cfg.theme} \
              --type ${cfg.style} \
              --side ${cfg.side} \
              --color ${cfg.color} \
              --screen ${cfg.screen} \
              --dest $out
            
            runHook postBuild
          '';
          
          installPhase = ''
            runHook preInstall
            
            mkdir -p $out/share/grub/themes
            
            # Copy generated theme to output
            themeName="New-Albion-${cfg.theme}-${cfg.style}-${cfg.side}-${cfg.color}-${cfg.screen}"
            if [ -d "$out/$themeName" ]; then
              mv "$out/$themeName" "$out/share/grub/themes/new-albion"
            fi
            
            # Use custom background if provided
            if [ -n "${cfg.customBackground}" ]; then
              ${pkgs.imagemagick}/bin/magick "${cfg.customBackground}" \
                "$out/share/grub/themes/new-albion/background.jpg"
            fi
            
            runHook postInstall
          '';
          
          meta = with lib; {
            description = "New Albion GRUB2 themes with multiple background variants";
            homepage = "https://github.com/Sanatana-Linux/new-albion-grub2-themes";
            license = licenses.gpl3Plus;
            platforms = platforms.linux;
            maintainers = [];
          };
        };
        
        resolution =
          if cfg.customResolution != null
          then cfg.customResolution
          else resolutions."${cfg.screen}";
      in {
        options = {
          boot.loader.grub.new-albion-theme = {
            enable = mkOption {
              default = false;
              example = true;
              type = types.bool;
              description = ''
                Enable New Albion GRUB2 theme
              '';
            };
            
            theme = mkOption {
              default = "yerba-buena";
              example = "fog";
              type = types.enum ["yerba-buena" "fog" "580W" "golden-gate"];
              description = ''
                Background theme variant to use
              '';
            };
            
            style = mkOption {
              default = "window";
              example = "float";
              type = types.enum ["window" "float" "sharp" "blur"];
              description = ''
                Theme style variant
              '';
            };
            
            side = mkOption {
              default = "left";
              example = "right";
              type = types.enum ["left" "right"];
              description = ''
                Picture display side
              '';
            };
            
            color = mkOption {
              default = "dark";
              example = "dark";
              type = types.enum ["dark"];
              description = ''
                Background color variant
              '';
            };
            
            screen = mkOption {
              default = "1080p";
              example = "2k";
              type = types.enum ["1080p" "2k" "4k"];
              description = ''
                Screen resolution variant
              '';
            };
            
            customResolution = mkOption {
              default = null;
              example = "1600x900";
              type = types.nullOr (types.strMatching "[0-9]+x[0-9]+");
              description = ''
                Custom resolution override in WIDTHxHEIGHT format
              '';
            };
            
            customBackground = mkOption {
              default = null;
              example = "/path/to/background.jpg";
              type = types.nullOr types.path;
              description = ''
                Custom background image path (JPG/PNG)
              '';
            };
          };
        };
        
        config = mkIf cfg.enable {
          environment.systemPackages = [ new-albion-grub-theme ];
          
          boot.loader.grub = {
            enable = true;
            theme = "${new-albion-grub-theme}/share/grub/themes/new-albion";
            gfxmodeEfi = "${resolution}";
            gfxmodeBios = "${resolution}";
            splashImage = "${new-albion-grub-theme}/share/grub/themes/new-albion/background.jpg";
          };
        };
      };
    };
}
