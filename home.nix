{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "todd";
  home.homeDirectory = "/home/todd";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    firefox
    htop
    neofetch
    signal-desktop
    vlc
    xclip
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/todd/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # General Application Configuration
  programs.git = {
    enable = true;
    userName = "Todd Bealmear";
    userEmail = "todd@t0dd.io";

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  # TODO: Enable Gnome Terminal - installs via Home Manager broken as of 2024-03-31
  # programs.gnome-terminal = {
  #   enable = true;

  #   profile = {
  #     a4f369c2-efb0-11ee-826a-a74ccf4f633b = {
  #       customCommand = "tmux";
  #     };
  #   };
  # };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      bind-key -Tcopy-mode-vi 'v' send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      set-option -g status-bg colour234
      set-option -g status-fg colour202
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "gianu";
    };
  };

  programs.vscode = {
    enable = true;

    extensions = [
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.editorconfig.editorconfig
    ];
  };
}
