# Server Performance Stats

A bash script that prints a quick snapshot of a Linux server's health: CPU, memory, disk, and the busiest processes.

Part of the [roadmap.sh Server Stats project](https://roadmap.sh/projects/server-stats).

## What it shows

| Stat | Source | Notes |
|---|---|---|
| CPU usage | `vmstat` | 100 minus idle %, sampled over 5 seconds |
| Memory | `free -m` | Used and available, in MB and % |
| Disk (`/`) | `df -m /` | Used, free, total, and use % |
| Top 5 processes by CPU | `top` | Current usage, not a lifetime average |
| Top 5 processes by memory | `top` | Sorted by `%MEM` |

## Requirements

- Linux with bash 4+
- `procps` tools (`vmstat`, `free`, `top`), preinstalled on most distros
- `awk`, `grep`, `tail` (standard)

## Getting started

1. **Clone the repository**
```bash
   git clone git@github.com:tamilore-dev/server-stats.git
   cd server-stats
```

2. **Make the script executable**
```bash
   chmod +x server-stats.sh
```

3. **Run it**
```bash
   ./server-stats.sh
```

The script takes about 7 seconds because it samples CPU over time instead of reading a single instant value.

## Sample output

```
===================================================================
                Server Performance Stats Checker
===================================================================

CPU Usage:    28%
Memory:       Used 3623MB (46%) | Available 4179MB (53%) | Total 7804MB
Disk (/):     Used 71070MB (24%) | Free 228406MB | Total 302596MB

Top 5 processes by CPU:
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   3083 tamilore  20   0 7421576 326920 148964 S  20.3   4.1   5:38.15 gnome-s+
   ...
```

## How it works

- **CPU:** `vmstat 5 2` prints
