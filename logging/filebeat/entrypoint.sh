#!/usr/bin/env bash
set -euo pipefail

# Config is baked into the image at /usr/share/filebeat/filebeat.yml
# Start Filebeat in the foreground
exec filebeat -e -c /usr/share/filebeat/filebeat.yml
