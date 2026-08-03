#!/bin/sh
# pool_health_check.sh — Check ZFS pool status and alert on issues
# Usage: Add to cron for periodic checks

EMAIL="admin@example.com"
SUBJECT="[FreeNAS ALERT] ZFS Pool Degraded"

# Get pool status
STATUS=$(zpool status -x)

if echo "$STATUS" | grep -q "DEGRADED\|FAULTED\|UNAVAIL"; then
    echo "$STATUS" | mail -s "$SUBJECT" "$EMAIL"
    echo "WARNING: Pool issue detected. Email sent to $EMAIL"
else
    echo "OK: All pools are healthy."
    zpool status -v | head -20
fi
