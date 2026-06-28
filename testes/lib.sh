#!/usr/bin/env bash

ok(){ echo "[OK] $*"; }
info(){ echo "[INFO] $*"; }
warn(){ echo "[WARN] $*" >&2; }
erro(){ echo "[ERRO] $*" >&2; }
