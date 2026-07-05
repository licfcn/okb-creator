#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
chmod -R u+w "$SCRIPT_DIR/raw/"
echo "raw/ 已解锁，添加完文件后运行 ./lock-raw.sh"
