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
    tmux autojump htop rsync stow git tig udisks

    # Graphical apps
    evince scrot

    # Custom desktop environment dependencies
    dmenu gmrun haskellPackages.xmobar libcanberra sound-theme-freedesktop
      terminator firefox

    # Use a customized vim
    (vim_configurable.customize {
      name = "vim2";
      vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ fugitive ];
     };
    })

  ];

  # Program options
  programs.bash.enableCompletion = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.vim.defaultEditor = true;

  # Services
  services.autorandr.enable = true; # Change the monitor config automatically.
  services.openssh.enable = true; # Enable sshd.
  services.physlock.enable = true; # Lock the screen before suspending.
  services.timesyncd.enable = true; # Synchronize the time.
  services.compton = { # Improve UI rendering.
    enable = true;
    backend = "glx";
    #XXX: Avoid partly transparent Terminator window borders:
    #Start workaround
    shadow = true;
    shadowOffsets = [ (-2) (-2) ];
    shadowOpacity = "1.0";
    extraOptions = "shadow-radius = 1;";
    #End workaround
  };
  services.redshift = { # Make the screen more eye-friendly
    enable = true;
    provider = "geoclue2";
    brightness.night = "0.5";
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

  system.stateVersion = "18.03";
  system.autoUpgrade.enable = true;
}
