#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
chmod -R a-w "$SCRIPT_DIR/raw/"
echo "raw/ 已锁定为只读"
