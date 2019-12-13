# Help is available in the conf manual
# (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  hardware.pulseaudio.enable = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  
  networking.hostName = "nixos";

  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

  # System profile packages
  environment.sessionVariables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [

    # Console apps
    tmux htop stow git cscope ctags tig

    # Graphical apps
    evince scrot

    # Custom desktop environment dependencies
    dmenu gmrun haskellPackages.xmobar libcanberra-gtk2 sound-theme-freedesktop
      firefox i3lock xrandr-invert-colors alacritty

    # Use a customized vim
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.packages.myVimPackage.start = with vimPlugins; [ fugitive ];
    })

  ];

  # Program options
  programs.autojump.enable = true;
  programs.xss-lock.enable = true;

  # Services
  services.autorandr.enable = true; # Change the monitor config automatically.
  services.openssh.enable = true; # Enable sshd.
  services.redshift = { # Make the screen more eye-friendly
    enable = true;
    extraOptions = [ "-m vidmode" ];
  };
  services.xserver = {
    enable = true;
    layout = "us,us";
    xkbVariant = ",colemak";
    xkbOptions = "grp:shift_toggle";
    libinput.enable = true; # Enable touchpads
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  # Users
  users.extraUsers.nchery = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "19.09";
}
