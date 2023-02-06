{
  pkgs? import <nixpkgs> {}
}:

with pkgs; with python3.pkgs; buildPythonPackage rec {
  name = "volare";

  version_file = builtins.readFile ./volare/__init__.py;
  version_list = builtins.match ''.+''\n__version__ = "([^"]+)"''\n.+''$'' version_file;
  version = builtins.head version_list;

  src = builtins.filterSource (path: type:
    (builtins.match ''${builtins.toString ./.}/((volare(/.+)?)|(setup.py)|(requirements(_dev)?.txt)|(Readme.md))'' path) != null &&
    (builtins.match ''.+__pycache__.*'' path == null)
  ) ./.;

  doCheck = false;
  PIP_DISABLE_PIP_VERSION_CHECK = "1";

  propagatedBuildInputs = [
    click
    pyyaml
    rich
    requests
    pcpp
  ];
}