#!/usr/bin/env bash
# Wraps src/qe-health-check.html in a full HTML document so it opens offline in any browser.
set -euo pipefail
cd "$(dirname "$0")/.."
{
  printf '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><style>[hidden]{display:none!important}body{margin:0}</style></head><body>'
  cat src/qe-health-check.html
  printf '</body></html>\n'
} > dist/QE-Health-Check.html
echo "Wrote dist/QE-Health-Check.html"
