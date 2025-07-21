#!/bin/bash

while true; do
    clear
    echo "=== AIS Stack Monitor - $(date) ==="
    echo ""
    docker-compose ps
    echo ""
    echo "=== Resource Usage ==="
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
    sleep 5
done