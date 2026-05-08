#!/bin/bash
set -euo pipefail

LOG="/var/log/health-monitor.log"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"; }
alert() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: $1" | tee -a "$LOG"; }

check_cpu() {
    local cpu_idle
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
    local cpu_used=$((100 - cpu_idle))
    log "CPU usage: ${cpu_used}%"
    if [ "$cpu_used" -gt "$CPU_THRESHOLD" ]; then
        alert "CPU usage ${cpu_used}% exceeds threshold ${CPU_THRESHOLD}%"
    fi
}

check_memory() {
    local mem_total mem_used mem_pct
    mem_total=$(free | grep Mem | awk '{print $2}')
    mem_used=$(free | grep Mem | awk '{print $3}')
    mem_pct=$(( mem_used * 100 / mem_total ))
    log "Memory usage: ${mem_pct}%"
    if [ "$mem_pct" -gt "$MEM_THRESHOLD" ]; then
        alert "Memory usage ${mem_pct}% exceeds threshold ${MEM_THRESHOLD}%"
    fi
}

check_disk() {
    local disk_pct
    disk_pct=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    log "Disk usage: ${disk_pct}%"
    if [ "$disk_pct" -gt "$DISK_THRESHOLD" ]; then
        alert "Disk usage ${disk_pct}% exceeds threshold ${DISK_THRESHOLD}%"
    fi
}

check_services() {
    local services=("ssh" "cron")
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            log "Service $service: running"
        else
            alert "Service $service is DOWN"
        fi
    done
}

log "=== Health check started ==="
check_cpu
check_memory
check_disk
check_services
log "=== Health check complete ==="
