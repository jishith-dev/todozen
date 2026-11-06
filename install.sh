#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/jishith-dev/todozen.git"
MIN_VERSION="3.1.1"
APP="todozen"

info() {
  echo "[todozen] $1"
}

fail() {
  echo "[todozen] ERROR: $1" >&2
  exit 1
}

# Requirements
command -v git >/dev/null 2>&1 || fail "git is not installed."
command -v zen >/dev/null 2>&1 || fail "Zen is not installed."

# Zen version check
ZEN_VERSION="$(zen --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)"

if [ -z "$ZEN_VERSION" ]; then
  fail "Could not detect the Zen version."
fi

LOWEST="$(printf '%s\n%s\n' "$MIN_VERSION" "$ZEN_VERSION" | sort -V | head -n 1)"

if [ "$LOWEST" != "$MIN_VERSION" ]; then
  fail "Zen $MIN_VERSION or higher is required (found $ZEN_VERSION)."
fi

info "Zen $ZEN_VERSION detected."

# Install location
NEEDS_PATH=0

if [ -n "${PREFIX:-}" ] && [ -d "$PREFIX/bin" ]; then
  BIN_DIR="$PREFIX/bin"
else
  BIN_DIR="$HOME/.local/bin"
  NEEDS_PATH=1
fi

mkdir -p "$BIN_DIR"

# Clone and build in a temporary directory
WORK_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$WORK_DIR"
}

trap cleanup EXIT

info "Downloading source..."
git clone --depth 1 "$REPO_URL" "$WORK_DIR/src" >/dev/null 2>&1 || fail "Clone failed."

cd "$WORK_DIR/src"

info "Building..."
zen build main.zen || fail "Build failed."

[ -f build/main ] || fail "Build did not produce build/main."

install -m 755 build/main "$BIN_DIR/$APP"

# Add to PATH when needed
if [ "$NEEDS_PATH" -eq 1 ]; then
  case ":$PATH:" in
    *":$BIN_DIR:"*)
      ;;
    *)
      PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

      for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$RC" ] && ! grep -qF "$PATH_LINE" "$RC"; then
          echo "$PATH_LINE" >> "$RC"
        fi
      done

      info "Added $BIN_DIR to PATH. Restart your shell or run: source ~/.bashrc"
      ;;
  esac
fi

info "Installed: $BIN_DIR/$APP"
info "Run: $APP help"

