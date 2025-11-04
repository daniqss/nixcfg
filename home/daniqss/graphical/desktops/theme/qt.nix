{
  pkgs,
  lib,
  config,
  ...
}: let
  qtConfig = n: ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt${n}ct/matugen.conf
    custom_palette=true

    [Fonts]
    fixed="CaskaydiaCove Nerd Font Mono,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
    general="Cantarell,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=0
    double_click_interval=400
    gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
    keyboard_scheme=2
    menus_have_icons=false
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=2
    wheel_scroll_lines=4

    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\ak\0\0\x3\xf4\0\0\0\0\0\0\0\0\0\0\a\x7f\0\0\x4\x37\0\0\0\0\x2\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\ak\0\0\x3\xf4)
  '';
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [
      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ];

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };

    home.file.".config/qt5ct/qt5ct.conf".text = qtConfig "5";
    home.file.".config/qt6ct/qt6ct.conf".text = qtConfig "6";
  };
}
