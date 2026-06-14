pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  // flat accessors so widgets keep using Colors.<name>; values come from
  // colors.json when present, otherwise the fallbacks in the Color component
  readonly property color background: jsonAdapter.color.background
  readonly property color error: jsonAdapter.color.error
  readonly property color error_container: jsonAdapter.color.error_container
  readonly property color inverse_on_surface: jsonAdapter.color.inverse_on_surface
  readonly property color inverse_primary: jsonAdapter.color.inverse_primary
  readonly property color inverse_surface: jsonAdapter.color.inverse_surface
  readonly property color on_background: jsonAdapter.color.on_background
  readonly property color on_error: jsonAdapter.color.on_error
  readonly property color on_error_container: jsonAdapter.color.on_error_container
  readonly property color on_primary: jsonAdapter.color.on_primary
  readonly property color on_primary_container: jsonAdapter.color.on_primary_container
  readonly property color on_primary_fixed: jsonAdapter.color.on_primary_fixed
  readonly property color on_primary_fixed_variant: jsonAdapter.color.on_primary_fixed_variant
  readonly property color on_secondary: jsonAdapter.color.on_secondary
  readonly property color on_secondary_container: jsonAdapter.color.on_secondary_container
  readonly property color on_secondary_fixed: jsonAdapter.color.on_secondary_fixed
  readonly property color on_secondary_fixed_variant: jsonAdapter.color.on_secondary_fixed_variant
  readonly property color on_surface: jsonAdapter.color.on_surface
  readonly property color on_surface_variant: jsonAdapter.color.on_surface_variant
  readonly property color on_tertiary: jsonAdapter.color.on_tertiary
  readonly property color on_tertiary_container: jsonAdapter.color.on_tertiary_container
  readonly property color on_tertiary_fixed: jsonAdapter.color.on_tertiary_fixed
  readonly property color on_tertiary_fixed_variant: jsonAdapter.color.on_tertiary_fixed_variant
  readonly property color outline: jsonAdapter.color.outline
  readonly property color outline_variant: jsonAdapter.color.outline_variant
  readonly property color primary: jsonAdapter.color.primary
  readonly property color primary_container: jsonAdapter.color.primary_container
  readonly property color primary_fixed: jsonAdapter.color.primary_fixed
  readonly property color primary_fixed_dim: jsonAdapter.color.primary_fixed_dim
  readonly property color scrim: jsonAdapter.color.scrim
  readonly property color secondary: jsonAdapter.color.secondary
  readonly property color secondary_container: jsonAdapter.color.secondary_container
  readonly property color secondary_fixed: jsonAdapter.color.secondary_fixed
  readonly property color secondary_fixed_dim: jsonAdapter.color.secondary_fixed_dim
  readonly property color shadow: jsonAdapter.color.shadow
  readonly property color surface: jsonAdapter.color.surface
  readonly property color surface_bright: jsonAdapter.color.surface_bright
  readonly property color surface_container: jsonAdapter.color.surface_container
  readonly property color surface_container_high: jsonAdapter.color.surface_container_high
  readonly property color surface_container_highest: jsonAdapter.color.surface_container_highest
  readonly property color surface_container_low: jsonAdapter.color.surface_container_low
  readonly property color surface_container_lowest: jsonAdapter.color.surface_container_lowest
  readonly property color surface_dim: jsonAdapter.color.surface_dim
  readonly property color surface_tint: jsonAdapter.color.surface_tint
  readonly property color surface_variant: jsonAdapter.color.surface_variant
  readonly property color tertiary: jsonAdapter.color.tertiary
  readonly property color tertiary_container: jsonAdapter.color.tertiary_container
  readonly property color tertiary_fixed: jsonAdapter.color.tertiary_fixed
  readonly property color tertiary_fixed_dim: jsonAdapter.color.tertiary_fixed_dim

  // tonal palette, available as Colors.palette.<name><shade>
  readonly property alias palette: jsonAdapter.palette

  function withAlpha(c: color, alpha: real): color {
    return Qt.rgba(c.r, c.g, c.b, alpha);
  }

  FileView {
    path: Quickshell.dataPath("colors.json")
    watchChanges: true
    onFileChanged: reload()

    JsonAdapter {
      id: jsonAdapter

      readonly property Color color: Color {}
      readonly property Palette palette: Palette {}
    }
  }

  component Color: JsonObject {
    property string background: "#121318"
    property string error: "#ffb4ab"
    property string error_container: "#93000a"
    property string inverse_on_surface: "#2f3036"
    property string inverse_primary: "#465d91"
    property string inverse_surface: "#e2e2e9"
    property string on_background: "#e2e2e9"
    property string on_error: "#690005"
    property string on_error_container: "#ffdad6"
    property string on_primary: "#142f60"
    property string on_primary_container: "#d9e2ff"
    property string on_primary_fixed: "#001944"
    property string on_primary_fixed_variant: "#2d4578"
    property string on_secondary: "#293042"
    property string on_secondary_container: "#dbe2f9"
    property string on_secondary_fixed: "#141b2c"
    property string on_secondary_fixed_variant: "#404659"
    property string on_surface: "#e2e2e9"
    property string on_surface_variant: "#c5c6d0"
    property string on_tertiary: "#412742"
    property string on_tertiary_container: "#fdd7fb"
    property string on_tertiary_fixed: "#2a132c"
    property string on_tertiary_fixed_variant: "#593e5a"
    property string outline: "#8f9099"
    property string outline_variant: "#44464f"
    property string primary: "#afc6ff"
    property string primary_container: "#2d4578"
    property string primary_fixed: "#d9e2ff"
    property string primary_fixed_dim: "#afc6ff"
    property string scrim: "#000000"
    property string secondary: "#bfc6dc"
    property string secondary_container: "#404659"
    property string secondary_fixed: "#dbe2f9"
    property string secondary_fixed_dim: "#bfc6dc"
    property string shadow: "#000000"
    property string surface: "#121318"
    property string surface_bright: "#38393e"
    property string surface_container: "#1e1f25"
    property string surface_container_high: "#282a2f"
    property string surface_container_highest: "#33353a"
    property string surface_container_low: "#1a1b20"
    property string surface_container_lowest: "#0c0e13"
    property string surface_dim: "#121318"
    property string surface_tint: "#afc6ff"
    property string surface_variant: "#44464f"
    property string tertiary: "#dfbbde"
    property string tertiary_container: "#593e5a"
    property string tertiary_fixed: "#fdd7fb"
    property string tertiary_fixed_dim: "#dfbbde"
  }

  component Palette: JsonObject {
    property string error0: "transparent"
    property string error5: "transparent"
    property string error10: "transparent"
    property string error15: "transparent"
    property string error20: "transparent"
    property string error25: "transparent"
    property string error30: "transparent"
    property string error35: "transparent"
    property string error40: "transparent"
    property string error50: "transparent"
    property string error60: "transparent"
    property string error70: "transparent"
    property string error80: "transparent"
    property string error90: "transparent"
    property string error95: "transparent"
    property string error98: "transparent"
    property string error99: "transparent"
    property string error100: "transparent"

    property string neutral0: "transparent"
    property string neutral5: "transparent"
    property string neutral10: "transparent"
    property string neutral15: "transparent"
    property string neutral20: "transparent"
    property string neutral25: "transparent"
    property string neutral30: "transparent"
    property string neutral35: "transparent"
    property string neutral40: "transparent"
    property string neutral50: "transparent"
    property string neutral60: "transparent"
    property string neutral70: "transparent"
    property string neutral80: "transparent"
    property string neutral90: "transparent"
    property string neutral95: "transparent"
    property string neutral98: "transparent"
    property string neutral99: "transparent"
    property string neutral100: "transparent"

    property string neutral_variant0: "transparent"
    property string neutral_variant5: "transparent"
    property string neutral_variant10: "transparent"
    property string neutral_variant15: "transparent"
    property string neutral_variant20: "transparent"
    property string neutral_variant25: "transparent"
    property string neutral_variant30: "transparent"
    property string neutral_variant35: "transparent"
    property string neutral_variant40: "transparent"
    property string neutral_variant50: "transparent"
    property string neutral_variant60: "transparent"
    property string neutral_variant70: "transparent"
    property string neutral_variant80: "transparent"
    property string neutral_variant90: "transparent"
    property string neutral_variant95: "transparent"
    property string neutral_variant98: "transparent"
    property string neutral_variant99: "transparent"
    property string neutral_variant100: "transparent"

    property string primary0: "transparent"
    property string primary5: "transparent"
    property string primary10: "transparent"
    property string primary15: "transparent"
    property string primary20: "transparent"
    property string primary25: "transparent"
    property string primary30: "transparent"
    property string primary35: "transparent"
    property string primary40: "transparent"
    property string primary50: "transparent"
    property string primary60: "transparent"
    property string primary70: "transparent"
    property string primary80: "transparent"
    property string primary90: "transparent"
    property string primary95: "transparent"
    property string primary98: "transparent"
    property string primary99: "transparent"
    property string primary100: "transparent"

    property string secondary0: "transparent"
    property string secondary5: "transparent"
    property string secondary10: "transparent"
    property string secondary15: "transparent"
    property string secondary20: "transparent"
    property string secondary25: "transparent"
    property string secondary30: "transparent"
    property string secondary35: "transparent"
    property string secondary40: "transparent"
    property string secondary50: "transparent"
    property string secondary60: "transparent"
    property string secondary70: "transparent"
    property string secondary80: "transparent"
    property string secondary90: "transparent"
    property string secondary95: "transparent"
    property string secondary98: "transparent"
    property string secondary99: "transparent"
    property string secondary100: "transparent"

    property string tertiary0: "transparent"
    property string tertiary5: "transparent"
    property string tertiary10: "transparent"
    property string tertiary15: "transparent"
    property string tertiary20: "transparent"
    property string tertiary25: "transparent"
    property string tertiary30: "transparent"
    property string tertiary35: "transparent"
    property string tertiary40: "transparent"
    property string tertiary50: "transparent"
    property string tertiary60: "transparent"
    property string tertiary70: "transparent"
    property string tertiary80: "transparent"
    property string tertiary90: "transparent"
    property string tertiary95: "transparent"
    property string tertiary98: "transparent"
    property string tertiary99: "transparent"
    property string tertiary100: "transparent"
  }
}
