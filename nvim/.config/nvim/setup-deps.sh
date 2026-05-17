#!/usr/bin/env bash
set -euo pipefail

# Cross-distro installer for Neovim development dependencies
# Usage:
#   sudo bash install-deps.sh

PKGS_COMMON=(git curl wget unzip tar)
PKGS_BUILD_DEBS=(build-essential cmake make gcc g++)
PKGS_BUILD_DNF=(make gcc gcc-c++ cmake)
PKGS_BUILD_PACMAN=(base-devel cmake)

APT_RUNTIME_PKGS=(
  python3
  python3-pip
  nodejs
  npm
  ripgrep
  fd-find
  fzf
)

DNF_RUNTIME_PKGS=(
  nodejs
  npm
  ripgrep
  fzf
)

PACMAN_RUNTIME_PKGS=(
  python
  python-pip
  nodejs
  npm
  ripgrep
  fd
  fzf
)

ZYPPER_RUNTIME_PKGS=(
  python3
  python3-pip
  nodejs
  npm
  ripgrep
  fzf
)

APK_RUNTIME_PKGS=(
  python3
  py3-pip
  nodejs
  npm
  ripgrep
  fzf
)

DNF_PYTHON_VENV_PACKAGES=(
  python3-virtualenv
  python3-venv
  python3-devel
)

DNF_OPENJDK_PACKAGE=java-17-openjdk-devel

install_apt() {
  if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_24.x | bash - || true
  fi

  apt update

  apt install -y \
    "${PKGS_COMMON[@]}" \
    "${PKGS_BUILD_DEBS[@]}" \
    "${APT_RUNTIME_PKGS[@]}" \
    clang llvm clangd

  # Ubuntu/Debian provide fdfind instead of fd
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi
}

install_dnf() {
  if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://rpm.nodesource.com/setup_24.x | bash - || true
  fi

  dnf install -y \
    "${PKGS_COMMON[@]}" \
    "${PKGS_BUILD_DNF[@]}" \
    "${DNF_RUNTIME_PKGS[@]}" \
    clang llvm clang-tools-extra

  # Install newer Python (needed for black/isort/pylint in Mason)
  if dnf list --available python3.11 >/dev/null 2>&1; then
    dnf install -y python3.11 python3.11-pip python3.11-devel
  else
    dnf install -y python3 python3-pip
  fi

  # Python venv support
  for pkg in "${DNF_PYTHON_VENV_PACKAGES[@]}"; do
    if dnf list --available "$pkg" >/dev/null 2>&1; then
      dnf install -y "$pkg" || true
    fi
  done

  # Java
  if dnf list --available "${DNF_OPENJDK_PACKAGE}" >/dev/null 2>&1; then
    dnf install -y "${DNF_OPENJDK_PACKAGE}" || true
  fi
}

install_pacman() {
  pacman -Sy --noconfirm \
    "${PKGS_COMMON[@]}" \
    "${PKGS_BUILD_PACMAN[@]}" \
    "${PACMAN_RUNTIME_PKGS[@]}" \
    clang llvm
}

install_zypper() {
  zypper refresh

  zypper install -y \
    ${PKGS_COMMON[*]} \
    ${PKGS_BUILD_DNF[*]} \
    ${ZYPPER_RUNTIME_PKGS[*]} \
    clang llvm
}

install_apk() {
  apk update

  apk add --no-cache \
    ${PKGS_COMMON[*]} \
    build-base \
    cmake \
    ${APK_RUNTIME_PKGS[*]} \
    openjdk11-jdk \
    clang
}

install_brew() {
  brew update

  brew install \
    git curl wget \
    cmake make gcc \
    python \
    node \
    openjdk@17 \
    ripgrep \
    fd \
    fzf \
    clang
}

install_lazygit_from_release() {
  local arch
  arch=$(uname -m)

  case "$arch" in
    aarch64|arm64)
      arch="arm64"
      ;;
    x86_64)
      arch="x86_64"
      ;;
    *)
      arch="x86_64"
      ;;
  esac

  local tag
  tag=$(
    curl -sSfL \
      "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
      | grep -Po '"tag_name": "\K[^"]+'
  ) || true

  if [ -z "${tag:-}" ]; then
    echo "Could not determine latest lazygit release"
    return
  fi

  local url
  url="https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${tag#v}_Linux_${arch}.tar.gz"

  local tmp
  tmp=$(mktemp -d)

  curl -sSL "$url" -o "$tmp/lazygit.tar.gz" || {
    echo "Failed to download lazygit"
    rm -rf "$tmp"
    return
  }

  tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp"

  if [ -f "$tmp/lazygit" ]; then
    mv "$tmp/lazygit" /usr/local/bin/lazygit
    chmod +x /usr/local/bin/lazygit
  fi

  rm -rf "$tmp"
}

bootstrap_user_tools() {
  echo
  echo "Run these AS YOUR NORMAL USER (not root):"
  echo

  if command -v pip3 >/dev/null 2>&1; then
    echo "pip3 install --user pynvim black isort pylint"
  fi

  echo

  if command -v npm >/dev/null 2>&1; then
    echo "npm install -g neovim prettier eslint_d"
  fi

  echo

  echo "Optional Rust install (needed for asm-lsp):"
  echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
}

main() {
  if [[ $(id -u) -ne 0 ]]; then
    echo "Please run with sudo:"
    echo "  sudo bash install-deps.sh"
    exit 1
  fi

  if command -v apt >/dev/null 2>&1; then
    install_apt

  elif command -v dnf >/dev/null 2>&1; then
    install_dnf

  elif command -v pacman >/dev/null 2>&1; then
    install_pacman

  elif command -v zypper >/dev/null 2>&1; then
    install_zypper

  elif command -v apk >/dev/null 2>&1; then
    install_apk

  elif command -v brew >/dev/null 2>&1; then
    install_brew

  else
    echo "Unsupported package manager"
    exit 2
  fi

  bootstrap_user_tools

  if ! command -v lazygit >/dev/null 2>&1; then
    echo
    echo "Installing lazygit from GitHub releases..."
    install_lazygit_from_release || true
  fi

  echo
  echo "Done."
  echo
  echo "Recommended next steps:"
  echo "  1. Run :checkhealth inside Neovim"
  echo "  2. Run :Mason"
  echo "  3. Install your LSPs/tools"
  echo

  echo "Versions detected:"
  command -v node >/dev/null 2>&1 && echo "Node: $(node -v)"
  command -v npm >/dev/null 2>&1 && echo "npm:  $(npm -v)"
  command -v python3 >/dev/null 2>&1 && echo "Python: $(python3 --version)"
  command -v cargo >/dev/null 2>&1 && echo "Cargo: $(cargo --version)"
}

main "$@"
