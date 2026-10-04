#!/usr/bin/env bash
# ==============================================================================
#  ⚡ ARC X AGENT - Unified Installation & Setup Engine
#  Next-Generation Autonomous AI Agent System
# ==============================================================================
set -euo pipefail

# ANSI Palette
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    CYAN='\033[0;36m'
    LIGHT_CYAN='\033[1;36m'
    BLUE='\033[0;34m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    PURPLE='\033[0;35m'
    BOLD='\033[1m'
    DIM='\033[2m'
    NC='\033[0m'
else
    CYAN="" LIGHT_CYAN="" BLUE="" GREEN="" YELLOW="" RED="" PURPLE="" BOLD="" DIM="" NC=""
fi

print_hero() {
    printf '%b\n' "${LIGHT_CYAN}"
    cat << 'ART'
█████╗ ██████╗  ██████╗  ██╗  ██╗   █████╗  ██████╗ ███████╗███╗   ██╗████████╗
██╔══██╗██╔══██╗██╔════╝ ╚██╗██╔╝  ██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝
███████║██████╔╝██║       ╚███╔╝   ███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║   
██╔══██║██╔══██╗██║       ██╔██╗   ██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║   
██║  ██║██║  ██║╚██████╗ ██╔╝ ██╗  ██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   
ART
    printf '%b\n' "${DIM}═══════════════════════════════════════════════════════════════════════════${NC}"
    printf '%b\n' "${BOLD}${GREEN}        ⚡ ARC X AGENT - Next-Gen Autonomous AI Executive Setup        ${NC}"
    printf '%b\n' "${DIM}═══════════════════════════════════════════════════════════════════════════${NC}\n"
}

step() { printf "%b[+]%b %b%s%b\n" "${LIGHT_CYAN}" "${NC}" "${BOLD}" "$1" "${NC}"; }
success() { printf "%b[✓]%b %s\n" "${GREEN}" "${NC}" "$1"; }
warn() { printf "%b[!]%b %s\n" "${YELLOW}" "${NC}" "$1"; }
info() { printf "%b[·]%b %s\n" "${BLUE}" "${NC}" "$1"; }
error() { printf "%b[✗]%b %s\n" "${RED}" "${NC}" "$1" >&2; }

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="${HOME}/.local/bin"

print_hero

step "1/5: Analyzing Host Environment & Dependencies..."
ARCH="$(uname -m)"
OS="$(uname -s)"
info "Detected OS: ${OS} (${ARCH})"

if command -v git >/dev/null 2>&1; then
    success "Git is available: $(git --version | head -n1)"
else
    error "Git is required but not installed."
    exit 1
fi

step "2/5: Initializing Isolated ARC X Agent Runtime..."
info "Bootstrapping Python 3.14 + PM runtime environment..."
"$ROOT_DIR/scripts/run-in-hermes-env" python3 -c "import sys; print(f'Python runtime initialized: {sys.version}')"
success "Isolated runtime verified."

step "3/5: Configuring Workspace & ARC X Profile..."
ARC_HOME="${HOME}/.arc-x"
if [ ! -e "$ARC_HOME" ]; then
    ln -s "${HOME}/.hermes" "$ARC_HOME" 2>/dev/null || mkdir -p "$ARC_HOME"
fi
success "Profile ready at ${ARC_HOME}"

step "4/5: Registering Executable Binaries (arc-x, arcx, arcxagent)..."
mkdir -p "$ROOT_DIR/bin"
cat << 'BIN_EOF' > "$ROOT_DIR/bin/arc-x"
#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export ARC_X_RUNNING=1
exec "$REPO_ROOT/scripts/run-in-hermes-env" python3 -m hermes_cli.main "$@"
BIN_EOF
chmod +x "$ROOT_DIR/bin/arc-x"
cp -f "$ROOT_DIR/bin/arc-x" "$ROOT_DIR/bin/arcx"
cp -f "$ROOT_DIR/bin/arc-x" "$ROOT_DIR/bin/arcxagent"
cp -f "$ROOT_DIR/bin/arc-x" "$ROOT_DIR/bin/arc"

mkdir -p "$BIN_DIR"
ln -sf "$ROOT_DIR/bin/arc-x" "$BIN_DIR/arc-x"
ln -sf "$ROOT_DIR/bin/arcx" "$BIN_DIR/arcx"
ln -sf "$ROOT_DIR/bin/arcxagent" "$BIN_DIR/arcxagent"
ln -sf "$ROOT_DIR/bin/arc" "$BIN_DIR/arc"
success "Installed binaries to ${BIN_DIR}/"

step "5/5: Running ARC X Agent Health Verification..."
"$ROOT_DIR/bin/arc-x" --version

printf "\n%b═══════════════════════════════════════════════════════════════════════════%b\n" "${LIGHT_CYAN}" "${NC}"
printf "%b✨ ARC X AGENT INSTALLATION COMPLETE!%b\n" "${BOLD}${GREEN}" "${NC}"
printf "%b═══════════════════════════════════════════════════════════════════════════%b\n" "${LIGHT_CYAN}" "${NC}"
printf "\n%bQuickstart Commands:%b\n" "${BOLD}" "${NC}"
printf "  %barc-x%b                Launch ARC X AGENT Interactive CLI\n" "${LIGHT_CYAN}" "${NC}"
printf "  %barcx setup%b           Configure AI model providers & API keys\n" "${LIGHT_CYAN}" "${NC}"
printf "  %barcx doctor%b          Run full system diagnostic & toolcheck\n" "${LIGHT_CYAN}" "${NC}"
printf "  %barcx --tui%b           Launch full-screen TUI terminal experience\n" "${LIGHT_CYAN}" "${NC}"
printf "  %barcx gateway%b         Start multi-platform messaging gateway\n\n" "${LIGHT_CYAN}" "${NC}"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    warn "${BIN_DIR} is not in your PATH. Add it with:"
    printf "  echo 'export PATH=\"%s:\$PATH\"' >> ~/.bashrc\n\n" "$BIN_DIR"
fi
