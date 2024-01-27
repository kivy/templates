#!/usr/bin/env bash
set -euxo pipefail

ROOT=$(realpath $(dirname "$0")/../..)

[[ -d "$ROOT"/build/windows ]] \
  || mkdir -p "$ROOT"/build/windows

(
  cd "$ROOT"/build/windows
  export HOME="$PWD"

  python -m venv venv
  source venv/Scripts/activate

  python -m pip install --upgrade pip
  python -m pip install -r "$ROOT"/tools/build/requirements.txt \
                        -r "$ROOT"/tools/build/requirements.windows.txt

  # copy app sources for cythonization
  rm -rf waverianapp; cp -r "$ROOT"/waverianapp waverianapp
  python "$ROOT"/tools/build/prebuild.py --inline_kv waverianapp

  VSPATH=$(/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/Installer/vswhere.exe -products 'Microsoft.VisualStudio.Product.BuildTools' -latest -property installationPath)
  [[ ! -z "$VSPATH" ]] \
    || { echo Error: failed to identify build tools path >&2; exit 1; }

  # CMD with vcvars
  {
    echo call \"${VSPATH}\\VC\\Auxiliary\\Build\\vcvars64.bat\";
    echo python \"..\\..\\tools\\build\\prebuild.py\" --cythonize waverianapp;
    echo exit %ERRORLEVEL%;
  } | cmd.exe

  # remove PyInstaller's dist directory if exists
  rm -rf dist

  python -m PyInstaller --clean "$ROOT"/tools/build/waverianapp.windows.spec
)

# sanity check
PACKAGE="$ROOT"\\build\\windows\\dist\\waverian.exe
[[ -f "$PACKAGE" ]] \
  || { echo Error: "$PACKAGE" doesn\'t exist >&2; exit 1; }

echo Successfully built "$PACKAGE"