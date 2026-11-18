# Using New Albion GRUB2 Themes with NixOS

This flake provides a NixOS module for easily installing and configuring New Albion GRUB2 themes.

## Adding to Your NixOS Configuration

### Method 1: Using flake inputs (recommended)

Add this flake as an input to your system flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    new-albion-grub = {
      url = "github:Sanatana-Linux/new-albion-grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, new-albion-grub, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        new-albion-grub.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
```

### Method 2: Direct import

```nix
# In your configuration.nix or flake
{
  imports = [
    (builtins.getFlake "github:Sanatana-Linux/new-albion-grub2-themes").nixosModules.default
  ];
}
```

## Configuration Options

Enable and configure the theme in your NixOS configuration:

```nix
{
  boot.loader.grub.new-albion-theme = {
    enable = true;
    theme = "yerba-buena";      # yerba-buena, fog, 580W, golden-gate
    style = "window";      # window, float, sharp, blur  
    side = "left";         # left, right
    color = "dark";        # dark
    screen = "1080p";      # 1080p, 2k, 4k
    
    # Optional: custom resolution override
    # customResolution = "1600x900";
    
    # Optional: custom background image
    # customBackground = ./my-background.jpg;
  };
}
```

## Available Options

- **theme**: Background variant (`yerba-buena`, `fog`, `580W`, `golden-gate`)
- **style**: Theme style (`window`, `float`, `sharp`, `blur`)
- **side**: Picture display side (`left`, `right`)
- **color**: Color scheme (`dark`)
- **screen**: Resolution preset (`1080p`, `2k`, `4k`)
- **customResolution**: Override with custom resolution (e.g., `"1600x900"`)
- **customBackground**: Path to custom background image

## Examples

### Fog theme with float style:
```nix
boot.loader.grub.elegant-theme = {
  enable = true;
  theme = "fog";
  style = "float";
  side = "right";
  color = "dark";
  screen = "2k";
};
```

### 580W theme with custom background:
```nix
boot.loader.grub.elegant-theme = {
  enable = true;
  theme = "580W";
  style = "sharp";
  customBackground = ./wallpapers/my-mountain.jpg;
};
```

## Requirements

- NixOS with flakes enabled
- GRUB bootloader (the module automatically configures GRUB settings)

The module will automatically handle theme generation, installation, and GRUB configuration.
