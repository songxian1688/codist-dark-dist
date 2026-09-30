#!/bin/bash
# 把 Codist Dark 主题同步安装到本机 VS Code 扩展目录
set -e
SRC_DIR="$(cd "$(dirname "$0")" && pwd)/codist-dark"
VERSION=$(python3 -c "import json; print(json.load(open('${SRC_DIR}/package.json'))['version'])")
DEST="$HOME/.vscode/extensions/local.codist-dark-${VERSION}"
mkdir -p "$DEST/themes"
cp "$SRC_DIR/themes/codist-dark-color-theme.json" "$DEST/themes/"
cp "$SRC_DIR/package.json" "$DEST/"
echo "installed -> $DEST"
echo "VS Code 里 Ctrl+K Ctrl+T 选择 'Codist Dark'"
