# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in
{
imports =
	[
	./hardware-configuration.nix
	];

users.users.sara =
	{
	isNormalUser = true;
	description = "Sára";
    extraGroups = [ "networkmanager" "wheel" "i2c" ];
# List packages installed in user profile
	packages = with pkgs;
		[
		# Basic Apps
		brave
		libreoffice-fresh
		mpv
		stremio
		signal-desktop
		speedcrunch
		telegram-desktop
		thunderbird
		vesktop
		drum-machine
		fragments
		errands
		unstable.obsidian
		unstable.vscode
		gimp3-with-plugins
		zed-editor
		# Games	and it's dependences
		prismlauncher
		# Tweaks
		aria2
		menulibre
		git
		github-desktop
		# Gnome Extenstion
		gnomeExtensions.ddterm	# Drop-down terminal
		gnomeExtensions.clipboard-indicator
		gnomeExtensions.brightness-control-using-ddcutil
		gnomeExtensions.just-perfection
		gnomeExtensions.middle-click-to-close-in-overview
		gnomeExtensions.nightscout
		gnomeExtensions.quick-settings-audio-devices-hider
		gnomeExtensions.quick-settings-audio-devices-renamer
		gnomeExtensions.simple-timer
		gnomeExtensions.gtile
		gnomeExtensions.top-bar-organizer
		gnomeExtensions.blur-my-shell
		# Theme
		papirus-folders
		papirus-icon-theme
		];
	};

# Steam,
programs.steam =
	{
	enable = true;
	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

programs.steam.extraCompatPackages = with pkgs;
	[
	proton-ge-bin
	];

# Optional: If you encounter amdgpu issues with newer kernels (e.g., 6.10+ reported issues),
# you might consider using the LTS kernel or a known stable version.
# boot.kernelPackages = pkgs.linuxPackages_lts; # Example for LTS

#LibreOffice
environment.sessionVariables = { SAL_USE_VCLPLUGIN = "gtk3"; };

# List packages installed in system profile
environment.systemPackages = with pkgs;
	[
	# Tweaks
	gnome-tweaks
	gnome-disk-utility
	ddcutil
	dconf
	dconf-editor
	#nh
	# Terminal
	fastfetch
	fish
	#gnome-terminal
	lf # terminal file manager
	micro-full #micro with copy paste outside of the terminal
	nix-search-cli
	hyfetch
	## TLDR variant
	tealdeer
	# Font
	hack-font
	lexend
	redhat-official-fonts
	];

# Remove Gnome apps
environment.gnome.excludePackages = with pkgs;
	[
	atomix			# puzzle game
	#baobab			# disk usage analyzer
	cheese			# take photos
	#eog			# image viewer
	epiphany		# web browser
	evince			# document viewer
	#file-roller	# archive manager
	geary			# email client
	#gedit       	# text editor
	#gnome-calculator
	gnome-calendar
	gnome-characters
	#gnome-clocks
	gnome-connections
	gnome-contacts
	gnome-disk-utility
	gnome-font-viewer
	gnome-logs
	gnome-maps
	gnome-music
	#gnome-screenshot
	#gnome-system-monitor
	gnome-tour
	#gnome-weather
	#seahorse    	# password manager
	simple-scan 	# document scanner
	snapshot		# camera
	#totem 			# video player
	yelp			# help viewer
	];


# gamescoop
programs.gamescope.enable = true;
programs.steam.gamescopeSession.enable = true;

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# Flatpak
services.flatpak.enable = true;

# Remove NixOS Manual
documentation.nixos.enable = false;

# Pro spouštění binárky
programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs;
	[
	# Add any missing dynamic libraries for unpackaged programs
	# here, NOT in environment.systemPackages
	];

# Remove xterm
services.xserver.excludePackages = [ pkgs.xterm ];

# Default shell Fish
programs.fish.enable = true;
users.defaultUserShell = pkgs.fish;

#For gnomeExtensions.brightness-control-using-ddcutil and ddcutil to work. Add "i2c" to wheel.
hardware.i2c.enable = true;

# Whether to enable udisks2, a DBus service that allows applications to query and manipulate storage devices.
services.udisks2.enable = true;

# HDD
boot.supportedFilesystems = [ "ntfs" ];

fileSystems."/mnt/HDD" =
	{
	device = "/dev/disk/by-uuid/A8AE01CAAE01924C";
	fsType = "ntfs-3g";
	options = [ "rw" ];
	};
# Flakes
nix.settings.experimental-features = [ "nix-command" "flakes" ];


# ----


# Bootloader
boot.loader.systemd-boot.enable = false;
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.grub.enable = true;
boot.loader.grub.devices = [ "nodev" ];
boot.loader.grub.efiSupport = true;
boot.loader.grub.useOSProber = true; #Finding new OS

networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
networking.networkmanager.enable = true;

# Set your time zone.
time.timeZone = "Europe/Prague";

# Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";

i18n.extraLocaleSettings =
	{
	LC_ADDRESS = "cs_CZ.UTF-8";
	LC_IDENTIFICATION = "cs_CZ.UTF-8";
	LC_MEASUREMENT = "cs_CZ.UTF-8";
	LC_MONETARY = "cs_CZ.UTF-8";
	LC_NAME = "cs_CZ.UTF-8";
	LC_NUMERIC = "cs_CZ.UTF-8";
	LC_PAPER = "cs_CZ.UTF-8";
	LC_TELEPHONE = "cs_CZ.UTF-8";
	LC_TIME = "cs_CZ.UTF-8";
	};

# Enable the X11 windowing system.
services.xserver.enable = true;

# Enable the GNOME Desktop Environment.
services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;

# Configure keymap in X11
services.xserver.xkb =
	{
	layout = "cz";
	variant = "qwerty_bksl";
	};

# Configure console keymap
console.keyMap = "cz-lat2";

# Enable CUPS to print documents.
services.printing.enable = true;

# Enable sound with pipewire.
services.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire =
	{
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	# If you want to use JACK applications, uncomment this
	#jack.enable = true;
	# use the example session manager (no others are packaged yet so this is enabled by default,
	# no need to redefine it in your config for now)
	#media-session.enable = true;
	};

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;








# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent =
#	{
#   enable = true;
#   enableSSHSupport = true;
# 	};

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "25.05"; # Did you read the comment?

}
