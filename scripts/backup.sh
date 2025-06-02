#!/usr/bin/env bash
#
# backup.sh — Backup InfluxDB & Grafana volumes
#
# Usage: ./backup.sh <backup-directory>
#
# Creates a timestamped backup of InfluxDB and Grafana data.

set -euo pipefail

BACKUP_DIR="${1:-./backups}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Ensure backup directory exists
mkdir -p "${BACKUP_DIR}"

echo "🚀 Starting backup at ${TIMESTAMP}..."

# 1. Backup InfluxDB v2 bucket data via influx CLI (optional if RESTORE)
#    Alternatively, just snapshot the volume:
echo "Backing up InfluxDB volume..."
docker run --rm \
  -v "$(pwd)/data/influxdb:/var/lib/influxdb2" \
  -v "${BACKUP_DIR}:/backup" \
  alpine sh -c "cd /var/lib/influxdb2 && tar czf /backup/influxdb_${TIMESTAMP}.tar.gz ."

# 2. Backup Grafana data
echo "Backing up Grafana volume..."
docker run --rm \
  -v "$(pwd)/data/grafana:/var/lib/grafana" \
  -v "${BACKUP_DIR}:/backup" \
  alpine sh -c "cd /var/lib/grafana && tar czf /backup/grafana_${TIMESTAMP}.tar.gz ."

echo "✅ Backup completed. Files saved in ${BACKUP_DIR}:"
ls -1 "${BACKUP_DIR}"