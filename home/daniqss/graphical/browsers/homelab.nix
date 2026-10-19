{
  outputs,
  pkgs,
  lib,
  config,
  ...
}: let
  certutil = lib.getExe' pkgs.nss.tools "certutil";
  nssdb = "sql:${config.home.homeDirectory}/.pki/nssdb";
in {
  # homelab caddy cas from lib/homelab.nix
  config = lib.mkIf (config.graphical.browsers.enable && config.terminal.ssh.homelab.enable) {
    home.activation.trustHomelab = lib.hm.dag.entryAfter ["writeBoundary"] (''
        run mkdir -p ${config.home.homeDirectory}/.pki/nssdb
        if ! ${certutil} -L -d ${nssdb} >/dev/null 2>&1; then
          run ${certutil} -N -d ${nssdb} --empty-password
        fi
      ''
      + lib.concatMapStrings (server:
        lib.concatMapStrings (ca: ''
          run ${certutil} -A -d ${nssdb} -t "C,," -n "${server.hostname} caddy" -i ${ca}
        '')
        server.ca)
      outputs.lib.homelab);
  };
}
