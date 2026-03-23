{ lib }:

let
  # Parse a colors.toml file into a Nix attribute set.
  # Format: key = "value" (one per line, # comments allowed)
  parseColorsToml = file:
    let
      content = builtins.readFile file;
      lines = lib.splitString "\n" content;
      nonEmpty = builtins.filter (l: l != "" && !(lib.hasPrefix "#" (lib.trim l))) lines;
      parseLine = line:
        let
          parts = lib.splitString "=" line;
          key = lib.trim (builtins.head parts);
          rawValue = lib.trim (lib.concatStringsSep "=" (builtins.tail parts));
          value = lib.replaceStrings [ "\"" ] [ "" ] rawValue;
        in
        { name = key; value = lib.trim value; };
    in
    builtins.listToAttrs (map parseLine nonEmpty);

  # Convert hex color "#rrggbb" to decimal "r,g,b"
  hexToRgb = hex:
    let
      h = lib.removePrefix "#" hex;
      hexDigit = c:
        let
          digits = {
            "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
            "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
            "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
            "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
          };
        in
        digits.${c} or 0;
      parseHexByte = s: (hexDigit (builtins.substring 0 1 s)) * 16 + (hexDigit (builtins.substring 1 1 s));
      r = parseHexByte (builtins.substring 0 2 h);
      g = parseHexByte (builtins.substring 2 2 h);
      b = parseHexByte (builtins.substring 4 2 h);
    in
    "${toString r},${toString g},${toString b}";

  # Apply template substitutions to a template string.
  # Replaces {{ key }}, {{ key_strip }}, {{ key_rgb }}
  applyTemplate = colors: templateContent:
    let
      keys = builtins.attrNames colors;
      applyKey = acc: key:
        let
          value = colors.${key};
          stripped = lib.removePrefix "#" value;
          rgb = if lib.hasPrefix "#" value then hexToRgb value else "";
        in
        builtins.replaceStrings
          [ "{{ ${key} }}" "{{ ${key}_strip }}" "{{ ${key}_rgb }}" ]
          [ value stripped rgb ]
          acc;
    in
    builtins.foldl' applyKey templateContent keys;

  # Apply template substitutions reading from a template file
  applyTemplateFile = colors: templatePath:
    applyTemplate colors (builtins.readFile templatePath);

in
{
  inherit parseColorsToml hexToRgb applyTemplate applyTemplateFile;
}
