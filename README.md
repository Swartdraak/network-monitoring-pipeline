# 🚀 NetFlow Monitoring Pipeline

A ready-to-deploy, **Docker Compose-based** NetFlow v9 monitoring pipeline, ideal for home or small office (SOHO) networks. This pipeline captures NetFlow data, enriches it, stores it, and visualizes network traffic clearly and intuitively.

---

## 📑 Table of Contents

* [✨ Overview](#-overview)
* [📡 Architecture](#-architecture)
* [🛠️ Prerequisites](#-prerequisites)
* [📂 Directory Structure](#-directory-structure)
* [🔧 Environment Variables & Configuration](#-environment-variables--configuration)
* [🚀 Deployment Instructions](#-deployment-instructions)
* [📊 Grafana Dashboard](#-grafana-dashboard)
* [⚙️ Data Retention & Performance](#-data-retention--performance)
* [💾 Backup & Restore](#-backup--restore)
* [🎛️ Customization & Scaling](#-customization--scaling)
* [🔍 Troubleshooting](#-troubleshooting)

---

## ✨ Overview

This pipeline collects **NetFlow v9 data** from your EdgeRouter, enriches it via **Vector**, stores metrics in **InfluxDB 2.x**, and visualizes traffic clearly using **Grafana**.

**Features:**

* Device identification via DNS
* Application mapping (HTTP, HTTPS, DNS, SSH, etc.)
* Metrics: IPs, Ports, Protocols, Bytes, Packets
* Pre-built Grafana dashboards with alerting capability
* Simple backup & restore procedures

---

## 📡 Architecture

```
EdgeRouter (NetFlow v9) ──UDP:2055──▶ goFlow2 ──UDP──▶ Vector (Enrichment)
                                    │
                                    ▼ HTTP
                                InfluxDB 2.x ◀───┐
                                    │            │ Flux Queries
                                    ▼            │
                                Grafana ─────────┘
```

---

## 🛠️ Prerequisites

* **Docker & Docker Compose** (v1.27+)
* **EdgeRouter Configuration**: Export NetFlow v9 to host IP on UDP `2055`

  ```bash
  configure
  set system flow-accounting interface eth0
  set system flow-accounting netflow-server 192.168.40.100 port 2055 version 9
  commit; save; exit
  ```
* **DNS**: Internal DNS resolution for hostnames
* Ports: `2055/UDP`, `8086/TCP`, `3000/TCP`, `9000/TCP` (optional)

---

## 📂 Directory Structure

```
network-monitoring-pipeline/
├── .gitignore
├── README.md
├── docker-compose.yml
├── config/
│   ├── goflow2/goflow2.env
│   ├── vector/vector.toml
│   ├── influxdb/influxdb.env
│   └── grafana/provisioning/
│       ├── datasources.yml
│       └── dashboards/netflow-dashboard.json
├── data/
│   ├── influxdb/
│   ├── grafana/
│   └── flows/
└── scripts/
    ├── backup.sh
    └── restore.sh
```

---

## 🔧 Environment Variables & Configuration

Create a `.env` file based on the provided template and adjust accordingly:

```env
NETFLOW_PORT=2055
INFLUX_USER=netflow_user
INFLUX_PASSWORD=ReplaceWithSecurePassword
INFLUX_ORG=netflow_org
INFLUX_BUCKET=netflow
INFLUX_RETENTION=30d
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=ReplaceWithSecurePassword
INFLUXDB_GRAFANA_TOKEN=ReplaceWithGrafanaReadToken
INFLUXDB_URL=http://influxdb:8086
TZ=America/Anchorage
```

See individual service configuration files (`goflow2.env`, `vector.toml`, `influxdb.env`, and Grafana provisioning files) for additional customization.

---

## 🚀 Deployment Instructions

**Clone & Setup:**

```bash
git clone https://github.com/yourusername/network-monitoring-pipeline.git
cd network-monitoring-pipeline
cp .env.example .env
# Edit `.env` with your configurations
docker-compose up -d
```

**Verify Deployment:**

* Grafana: `http://<host_ip>:3000` (login with admin credentials)
* InfluxDB: `http://<host_ip>:8086/health`

---

## 📊 Grafana Dashboard

Pre-built dashboards visualize:

* Top internal upload/download hosts
* Traffic by application
* Historical usage trends

Adjust as needed in Grafana UI.

---

## ⚙️ Data Retention & Performance

* Default retention: **30 days** (changeable in InfluxDB)
* Downsample historical data for performance optimization (example provided in scripts)

---

## 💾 Backup & Restore

Automated scripts for easy backup:

```bash
# Backup
./scripts/backup.sh ./backups

# Restore
./scripts/restore.sh backups/influxdb_<timestamp>.tar.gz backups/grafana_<timestamp>.tar.gz
```

---

## 🎛️ Customization & Scaling

* Change NetFlow ports, add application mappings, or scale Vector replicas.
* High-availability setups available via clustered InfluxDB or external Grafana backends.

---

## 🔍 Troubleshooting

* **No Flows:** Verify EdgeRouter exports, inspect logs (`docker-compose logs -f vector`).
* **Grafana Issues:** Verify datasource and logs (`docker-compose logs -f grafana`).
* **InfluxDB Auth:** Confirm tokens and org names.

---

## 📌 Contribute

Feel free to open issues or submit PRs for enhancements. Enjoy detailed visibility into your network traffic!