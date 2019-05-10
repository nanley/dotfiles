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
  networking.networkmanager.enable = true; 

  time.timeZone = "America/Los_Angeles";

  # System profile packages
  environment.systemPackages = with pkgs; [

    # Console apps
    tmux htop rsync stow git cscope tig udisks

    # Graphical apps
    evince scrot

    # Custom desktop environment dependencies
    dmenu gmrun haskellPackages.xmobar libcanberra sound-theme-freedesktop
      terminator firefox i3lock xrandr-invert-colors

    # Use a customized vim
    (vim_configurable.customize {
      name = "vim2";
      vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ fugitive ];
     };
    })

  ];

  # Program options
  programs.autojump.enable = true;
  programs.bash.enableCompletion = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.vim.defaultEditor = true;
  programs.xss-lock.enable = true;

  # Services
  services.autorandr.enable = true; # Change the monitor config automatically.
  services.openssh.enable = true; # Enable sshd.
  services.timesyncd.enable = true; # Synchronize the time.
  services.redshift = { # Make the screen more eye-friendly
    enable = true;
    provider = "geoclue2";
    extraOptions = [ "-m vidmode" ];
  };
  services.xserver = {
    enable = true;
    layout = "us,us";
    xkbVariant = ",colemak";
    xkbOptions = "grp:shift_toggle";
    libinput.enable = true; # Enable touchpads
    videoDrivers = [ "modesetting" ]; # Use a maintained x11 ddx
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  # Users
  users.extraUsers.nchery = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive;
  };

  system.stateVersion = "19.03";
}
