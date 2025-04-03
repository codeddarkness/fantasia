#!/bin/bash

PORT=${1:-5000}
LOGDIR=logs
LOGFILE=${LOGDIR}/"frontend_debug_$(date +%Y%m%d_%H%M%S).log"
URL="http://127.0.0.1:$PORT"

[[ -d "$LOGDIR" ]] || mkdir -pv ${LOGDIR}

echo "🔎 Checking Costume Scheduler at $URL" | tee "$LOGFILE"

echo -e "\n[1] Checking root /" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL" | tee -a "$LOGFILE"

echo -e "\n[2] Checking /api/data" | tee -a "$LOGFILE"
curl -s -o - "$URL/api/data" | tee -a "$LOGFILE"

echo -e "\n[3] Checking JS script" | tee -a "$LOGFILE"
curl -s -I "$URL/static/js/script.js" | tee -a "$LOGFILE"

echo -e "\n[4] Checking HTML template" | tee -a "$LOGFILE"
curl -s "$URL" | grep -i "<html" &>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ HTML page detected." | tee -a "$LOGFILE"
else
    echo "❌ HTML not detected in root response." | tee -a "$LOGFILE"
fi

echo -e "\n📄 Full log saved to $LOGFILE"

