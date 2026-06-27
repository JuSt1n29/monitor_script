# 📊 Bash Server Monitor with Telegram Alerts

![Bash](https://img.shields.io/badge/script-bash-4eaa25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/os-linux-222222?style=for-the-badge&logo=linux&logoColor=white)
![Telegram](https://img.shields.io/badge/alerts-telegram-0088cc?style=for-the-badge&logo=telegram&logoColor=white)

A lightweight, production-ready Bash script designed for automated real-time monitoring of critical Linux server metrics. When any resource exceeds safe thresholds or system services fail, the script instantly dispatches formatted alert notifications to your Telegram channel or chat. Perfect for managing independent VPS units or production server clusters.

---

## 🚀 Core Monitoring Features

* **Storage System:** Monitors percentage utilization of the root filesystem (`/`).
* **Memory Management:** Computes total active RAM consumption metrics.
* **CPU Core Dynamics:** Evaluates total CPU usage percentage and tracks system `Load Average`.
* **Service Health (Systemd):** Continuously tracks state processes of critical daemons (default configuration: `sshd`, `docker`, `nginx`).
* **Software Stability:** Scans for hidden `Zombie processes` that signal resource leaks or software bugs.
* **Network Stack Integrity:** Executes ICMP ping sweeps to public gateways (`8.8.8.8`) for early detection of routing failures or network drops.
* **OS Logging Integration:** Automatically writes check-up summaries directly to the Linux system journal (`/var/log/syslog`) using the native `logger` mechanism.

---

## 📋 Environment Prerequisites

The script leverages standard low-level system utilities, eliminating the need for heavy third-party monitoring agents:
* Linux-family Operating System (Ubuntu, Debian, CentOS, RHEL, Arch)
* Core packages: `curl`, `awk`, `grep`, `sed`, `ping`, `top`
* An active Telegram Bot API Token and your personal Chat ID

---

## ⚙️ Deployment & Setup Guide

### 1. Telegram Bot Provisioning
1. Search for the `@BotFather` bot in Telegram, execute the `/newbot` command, and securely copy your generated **API Token**.
2. Retrieve your unique personal account identifier via the `@myidbot` (**Chat ID**).
3. **Critical Step:** Access your newly created bot in Telegram and click **Start (`/start`)**. Telegram completely restricts bots from sending automated system messages until you initiate a chat history first.

### 2. Script Installation on the Server
Create a secure scripts directory, download the file, and open it for configuration:

```bash
mkdir -p ~/scripts && cd ~/scripts
nano monitor.sh
