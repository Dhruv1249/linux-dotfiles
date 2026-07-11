#!/usr/bin/env bash
#
# post-install.sh — Arch/CachyOS post-install provisioning script
# Run as a normal user with sudo privileges (NOT as root, NOT in chroot).
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_TARGET="${STOW_TARGET:-$HOME}"

# Packages that stow directly against $HOME 
STOW_PACKAGES=(
    btop
    cava
    DankMaterialShell
    fastfetch
    fish
    foot
    ghostty
    hypr
    matugen
    niri
    nvim
    starship
    tmux
)

log()  { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[-]\033[0m %s\n' "$*" >&2; }

require_not_root() {
    if [[ $EUID -eq 0 ]]; then
        err "Do not run this script as root. Run as your normal user; it will call sudo when needed."
        exit 1
    fi
}

log_dotfiles_dir() {
    log "Dotfiles directory (auto-derived from script location): $DOTFILES_DIR"
}

# ---------------------------------------------------------------------------
# 1. Package installation
# ---------------------------------------------------------------------------
install_pacman_packages() {
    log "Installing pacman packages..."
    sudo pacman -S --needed --noconfirm \
        alsa-utils base base-devel bluez bluez-utils btrfs-progs \
        cachyos-keyring cachyos-mirrorlist cachyos-v3-mirrorlist cachyos-v4-mirrorlist \
        cava clang dms-shell dms-shell-niri docker earlyoom easyeffects fd filelight \
        firefox fish fzf gammastep ghostty git github-cli go gparted grub-btrfs gthumb \
        gvfs gvfs-mtp imagemagick inotify-tools iwd kimageformats lazygit \
        libva-nvidia-driver libva-utils lld lua51 luarocks man-db matugen mesa-utils \
        mpv nasm neovim networkmanager niri noto-fonts-cjk noto-fonts-emoji ntfs-3g \
        onlyoffice-bin pacman-contrib pavucontrol pipewire pipewire-alsa pipewire-jack \
        pipewire-pulse playerctl plocate polkit-gnome poppler psensor qt5-multimedia \
        qt6-multimedia-ffmpeg qt6-virtualkeyboard reflector ripgrep rustup sddm \
        sof-firmware stow sudo thunar thunar-archive-plugin timeshift tmux \
        ttf-cascadia-code ttf-fira-code ttf-jetbrains-mono tty-clock tumbler unzip vim \
        virt-manager wf-recorder wireplumber wl-mirror xarchiver xdg-desktop-portal-wlr \
        xdg-user-dirs xwayland-satellite yay yazi zip zoxide zram-generator 7zip foot \
        lua-luarocks lua54 luajit noto-fonts xorg-xwayland zstd \
        qemu-desktop \
        nvidia-utils lib32-nvidia-utils nvidia-settings egl-wayland
}

install_aur_packages() {
    log "Installing AUR packages..."
    yay -S --needed --noconfirm \
        antigravity-cli brave-origin-nightly-bin docker-desktop \
        gitmux mpvpaper ttf-courier-prime 
}

# ---------------------------------------------------------------------------
# 2. zram
# ---------------------------------------------------------------------------
setup_zram() {
    local conf=/etc/systemd/zram-generator.conf

    if [[ -f "$conf" ]]; then
        log "zram-generator.conf already exists at $conf, leaving as-is."
    else
        log "Writing $conf..."
        sudo tee "$conf" >/dev/null <<'EOF'
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF
    fi

    log "Reloading systemd and activating zram0 now..."
    sudo systemctl daemon-reload
    sudo systemctl start systemd-zram-setup@zram0.service || \
        warn "Could not start zram0 now — it will activate on next boot instead."
}

# ---------------------------------------------------------------------------
# 3. Services
# ---------------------------------------------------------------------------
enable_services() {
    log "Enabling system services..."
    local services=(
        NetworkManager
        bluetooth
        docker
        sddm
        earlyoom
        libvirtd
        reflector.timer
        paccache.timer
    )
    for svc in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "^${svc}"; then
            sudo systemctl enable --now "$svc" 2>/dev/null || warn "Could not enable $svc"
        else
            warn "$svc not found, skipping"
        fi
    done

    log "Adding $USER to docker, libvirt, kvm groups..."
    sudo usermod -aG docker,libvirt,kvm "$USER"
}

# ---------------------------------------------------------------------------
# 4. Dotfiles via stow
# ---------------------------------------------------------------------------
stow_dotfiles() {
    log "Stowing dotfiles from $DOTFILES_DIR into $STOW_TARGET..."
    cd "$DOTFILES_DIR"

    for pkg in "${STOW_PACKAGES[@]}"; do
        if [[ -d "$pkg" ]]; then
            log "  stow -> $pkg"
            stow --restow --target="$STOW_TARGET" "$pkg" || warn "  stow failed for $pkg (check for conflicting files)"
        else
            warn "  $pkg not found in dotfiles repo, skipping"
        fi
    done
}

# ---------------------------------------------------------------------------
# 5. Fish shell: fisher, tide, nvm, node
# ---------------------------------------------------------------------------
set_default_shell_fish() {
    local fish_path
    fish_path="$(command -v fish)"
    if [[ "$SHELL" != "$fish_path" ]]; then
        log "Setting fish as default shell..."
        chsh -s "$fish_path" "$USER"
    else
        log "fish is already the default shell."
    fi
}

install_fisher_and_plugins() {
    log "Installing fisher and fish plugins..."
    fish -c '
        if not functions -q fisher
            curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
            fisher install jorgebucaran/fisher
        else
            echo "fisher already installed"
        end

        if not fisher list | grep -q "IlanCosman/tide"
            fisher install IlanCosman/tide@v6
        else
            echo "tide already installed"
        end

        if not fisher list | grep -q "jorgebucaran/nvm.fish"
            fisher install jorgebucaran/nvm.fish
        else
            echo "nvm.fish already installed"
        end
    '
}

install_node_via_nvm() {
    log "Installing latest Node.js LTS via nvm.fish..."
    fish -c '
        nvm install lts
        nvm use lts --write
    '
}

# ---------------------------------------------------------------------------
# 6. tree-sitter CLI (via cargo, since rustup/cargo are already present)
# ---------------------------------------------------------------------------
install_tree_sitter_cli() {
    if command -v tree-sitter &>/dev/null; then
        log "tree-sitter CLI already installed."
        return
    fi
    log "Installing rust stable toolchain (if needed) and tree-sitter-cli via cargo..."
    rustup toolchain install stable --profile minimal -y 2>/dev/null || true
    rustup default stable
    cargo install tree-sitter-cli
}

# ---------------------------------------------------------------------------
# 7. lazygit check (already in pacman list, but verify)
# ---------------------------------------------------------------------------
verify_lazygit() {
    if command -v lazygit &>/dev/null; then
        log "lazygit present: $(lazygit --version | head -n1)"
    else
        warn "lazygit missing despite being in package list — installing via pacman."
        sudo pacman -S --needed --noconfirm lazygit
    fi
}

# ---------------------------------------------------------------------------
# 8. TPM (Tmux Plugin Manager)
# ---------------------------------------------------------------------------
install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        log "TPM already installed at $tpm_dir."
    else
        log "Cloning TPM into $tpm_dir..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
    warn "Remember: open tmux and press prefix + I to fetch plugins listed in .tmux.conf."
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    require_not_root
    log_dotfiles_dir
    install_pacman_packages
    install_aur_packages
    setup_zram
    enable_services
    stow_dotfiles
    set_default_shell_fish
    install_fisher_and_plugins
    install_node_via_nvm
    install_tree_sitter_cli
    verify_lazygit
    install_tpm

    log "Done. Log out/in (or reboot) for group membership and shell changes to fully apply."
}

main "$@"
