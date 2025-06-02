#!/usr/bin/env bash
#
# restore.sh — Restore InfluxDB & Grafana from a backup tarball
#
# Usage: ./restore.sh <backup-influxdb-tar.gz> <backup-grafana-tar.gz>
#

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <influxdb-backup.tar.gz> <grafana-backup.tar.gz>"
  exit 1
fi

INFLUX_BACKUP="$1"
GRAFANA_BACKUP="$2"

echo "🛠️  Restoring InfluxDB from ${INFLUX_BACKUP}..."
# Stop InfluxDB container if running
docker-compose stop influxdb

# Clean existing data
rm -rf data/influxdb/*
tar xzf "${INFLUX_BACKUP}" -C data/influxdb

echo "🛠️  Restoring Grafana from ${GRAFANA_BACKUP}..."
docker-compose stop grafana
rm -rf data/grafana/*
tar xzf "${GRAFANA_BACKUP}" -C data/grafana

echo "✅ Restore completed. Restarting services..."
docker-compose up -d influxdb grafana