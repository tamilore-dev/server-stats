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
   7753 tamilore  20   0 1452.0g 454216 164184 S   4.8   5.7   1:24.41 brave
  13355 tamilore  20   0  236284   6728   4516 R   1.9   0.1   0:00.08 top
     11 root      20   0       0      0      0 I   1.0   0.0   0:03.02 kworker+
    659 root      20   0       0      0      0 I   1.0   0.0   0:01.51 kworker+
```

The memory list uses the same columns, sorted by `%MEM`.

## How it works

- **CPU:** `vmstat 5 2` prints two samples. The first is an average since boot, so the script keeps only the last line and calculates `100 - idle` from column 15.
- **Memory and disk:** `free` and `df` print tables. `awk` picks one line and one column from each, for example `awk 'NR==2{print $3}'` means "line 2, column 3".
- **Percentages:** bash only does whole-number math, so the script multiplies by 100 before dividing. Dividing first would round everything down to 0.
- **Top processes:** `top` runs twice, 1 second apart. The first snapshot is a lifetime average, so `grep -A 5 'PID'` grabs the header plus 5 rows from each snapshot, and `tail -n 6` keeps the second one.

## Notes

- In `top`, 100% CPU means one full core, so a process can show more than 100% on a multi-core machine.
- Values change constantly, so two runs will never match exactly. The `top` command itself often shows up in the CPU list.
- Percentages are rounded down, not to the nearest number.
- Tested on Fedora Workstation. It should work on other Linux distros with `procps`, but I haven't tried them.
