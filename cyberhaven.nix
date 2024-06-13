{
  stdenv,
  requireFile,
  autoPatchelfHook,
  dpkg,
  openssl,
  libgcc,
  xz,
  zlib,
  bzip2,
  keyutils,
  buildFHSUserEnv,
  writeShellScript,
}: let
  cyberhaven = stdenv.mkDerivation rec {
    pname = "cyberhaven";
    version = "24.04.01.56";
    ref = "6cedb0";

    src = requireFile {
      name = "Cyberhaven-${version}-${ref}.deb";
      url = "https://drive.google.com/drive/folders/12cIRewEoypqr0f5jmAXMW_iXZumTLf9h";
      sha256 = "0qp5xzvds330sqvg4c08ny4fh23j0k1rr9jpws6xjijxdc4v50nh";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    buildInputs = [
      openssl
      libgcc.lib
      xz
      zlib
      bzip2
      keyutils.lib
    ];

    installPhase = ''
      runHook preInstall

      dpkg -X $src $out
      rm $out/opt/cyberhaven/lib/libcyberhavennet-legacy.so

      runHook postInstall
    '';
  };
in
  buildFHSUserEnv {
    name = cyberhaven.pname;

    targetPkgs = pkgs: [
      cyberhaven
      pkgs.openssl
    ];

    runScript = writeShellScript "cyberhaven" ''
      backend="$1"
      installToken="$2"
      shift 2

      mkdir -p /etc/opt/cyberhaven /var/lib/cyberhaven
      mount -t tmpfs none /etc/opt/cyberhaven
      mount -t tmpfs none /var/lib/cyberhaven

      echo ">>> Installing cyberhaven"
      ${cyberhaven}/opt/cyberhaven/cyberhaven --set-backend-url "$backend" --set-install-token "$installToken"

      echo ">>> Running cyberhaven"
      exec ${cyberhaven}/opt/cyberhaven/cyberhaven "$@"
    '';
  }
