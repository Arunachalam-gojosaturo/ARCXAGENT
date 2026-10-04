#!/usr/bin/env bash
# ==============================================================================
#  ⚡ ARC X AGENT - One-Line Installer
#  Usage: curl -fsSL https://raw.githubusercontent.com/Arunachalam-gojosaturo/ARCXAGENT/main/install.sh | bash
# ==============================================================================
set -euo pipefail

# ANSI Palette
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    CYAN='\033[0;36m'
    LIGHT_CYAN='\033[1;36m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    DIM='\033[2m'
    NC='\033[0m'
else
    CYAN="" LIGHT_CYAN="" GREEN="" YELLOW="" RED="" BLUE="" BOLD="" DIM="" NC=""
fi

print_banner() {
    printf '%b\n' "${LIGHT_CYAN}"
    cat << 'ART'
█████╗ ██████╗  ██████╗  ██╗  ██╗   █████╗  ██████╗ ███████╗███╗   ██╗████████╗
██╔══██╗██╔══██╗██╔════╝ ╚██╗██╔╝  ██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝
███████║██████╔╝██║        ╚███╔╝   ███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║   
██╔══██║██╔══██╗██║        ██╔██╗   ██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║   
██║  ██║██║  ██║╚██████╗  ██╔╝ ██╗  ██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═╝  ╚═╝  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   
ART
    printf '%b\n' "${DIM}─────────────────────────────────────────────────────────────────────────────${NC}"
    printf '%b\n' "${BOLD}${GREEN}          ⚡ ARC X AGENT - Autonomous Executive AI Agent Installer          ${NC}"
    printf '%b\n' "${DIM}─────────────────────────────────────────────────────────────────────────────${NC}\n"
}

log() { printf "%b[+]%b %b%s%b\n" "${LIGHT_CYAN}" "${NC}" "${BOLD}" "$1" "${NC}"; }
log_success() { printf "%b[✓]%b %s\n" "${GREEN}" "${NC}" "$1"; }
log_warn() { printf "%b[!]%b %s\n" "${YELLOW}" "${NC}" "$1"; }
log_error() { printf "%b[✗]%b %s\n" "${RED}" "${NC}" "$1" >&2; }
log_info() { printf "%b[·]%b %s\n" "${BLUE}" "${NC}" "$1"; }

REPO_URL="${ARCX_REPO_URL:-https://github.com/Arunachalam-gojosaturo/ARCXAGENT.git}"
BRANCH="${ARCX_BRANCH:-main}"
INSTALL_DIR="${ARCX_INSTALL_DIR:-$HOME/.arc-x/arc-x-agent}"
BIN_DIR="${HOME}/.local/bin"

print_banner

log "1/5: Checking system dependencies..."
if ! command -v git >/dev/null 2>&1; then
    log_error "git is required but not installed. Please install git and re-run."
    exit 1
fi
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    log_error "curl or wget is required. Please install one and re-run."
    exit 1
fi
log_success "System dependencies verified (OS: $(uname -s), Arch: $(uname -m))"

log "2/5: Fetching ARC X AGENT codebase..."
mkdir -p "$(dirname "$INSTALL_DIR")"
if [ -d "$INSTALL_DIR/.git" ]; then
    log_info "Existing repository found at $INSTALL_DIR. Updating to latest $BRANCH..."
    git -C "$INSTALL_DIR" fetch --depth=1 origin "$BRANCH"
    git -C "$INSTALL_DIR" checkout -f "$BRANCH"
    git -C "$INSTALL_DIR" reset --hard "origin/$BRANCH"
else
    log_info "Cloning $REPO_URL to $INSTALL_DIR..."
    git clone --depth=1 --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi
log_success "Codebase staged at $INSTALL_DIR"

log "3/5: Bootstrapping runtime environment & packages..."
cd "$INSTALL_DIR"
chmod +x scripts/run-in-hermes-env bin/* arc-x arcx 2>/dev/null || true

# Run runtime environment bootstrap
"./scripts/run-in-hermes-env" python3 -c "import sys; print(f'Python runtime: {sys.version}')"
log_success "Runtime environment verified."

log "4/5: Installing command line executables..."
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/bin/arc-x" "$BIN_DIR/arc-x"
ln -sf "$INSTALL_DIR/bin/arcx" "$BIN_DIR/arcx"
ln -sf "$INSTALL_DIR/bin/arcxagent" "$BIN_DIR/arcxagent"
ln -sf "$INSTALL_DIR/bin/arc" "$BIN_DIR/arc"
log_success "Installed binaries to $BIN_DIR"

# Ensure ~/.local/bin is in PATH for bash and zsh
SHELL_CONFIG=""
if [ -n "${BASH_VERSION:-}" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -n "${ZSH_VERSION:-}" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q 'export PATH=.*\.local/bin' "$SHELL_CONFIG" 2>/dev/null; then
        printf '\n# ARC X AGENT PATH\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$SHELL_CONFIG"
        log_info "Added ~/.local/bin to PATH in $SHELL_CONFIG"
    fi
fi
export PATH="$BIN_DIR:$PATH"

log "5/5: Running ARC X health check..."
"$BIN_DIR/arc-x" --version

printf "\n%b─────────────────────────────────────────────────────────────────────────────%b\n" "${LIGHT_CYAN}" "${NC}"
printf "%b✨ ARC X AGENT SUCCESSFULLY INSTALLED!%b\n" "${BOLD}${GREEN}" "${NC}"
printf "%b─────────────────────────────────────────────────────────────────────────────%b\n\n" "${LIGHT_CYAN}" "${NC}"

echo "To start chatting with ARC X AGENT:"
echo "  1. Reload your shell:  source ~/.bashrc  (or source ~/.zshrc)"
echo "  2. Start the agent:    arc-x"
echo "  3. Or use alias:       arcx"
echo "  4. Configure provider: arc-x setup"
echo ""
