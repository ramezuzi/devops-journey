#!/bin/bash
set -euo pipefail

TARGET=${1:-"google.com"}

log() { echo "[*] $1"; }

log "=== Network Recon: $TARGET ==="

log "DNS Records:"
dig "$TARGET" A +short
dig "$TARGET" MX +short

log "Reverse DNS:"
ip=$(dig "$TARGET" A +short | head -1)
dig -x "$ip" +short

log "HTTP Status:"
curl -s -o /dev/null -w "  HTTP %{http_code}\n" "https://$TARGET" || true

log "Open ports (common):"
for port in 22 80 443 3306 5432; do
    nc -zv -w1 "$TARGET" "$port" 2>&1 | grep -E "open|refused" || true
done

log "Traceroute (5 hops):"
traceroute -m 5 -n "$TARGET" 2>/dev/null || true

log "=== Done ==="
