#!/bin/bash

PORT=${1:-5000}
LOGDIR=logs
LOGFILE=${LOGDIR}/"frontend_check_$(date +%Y%m%d_%H%M%S).log"
URL="http://127.0.0.1:$PORT"

[[ -d "$LOGDIR" ]] || mkdir -pv ${LOGDIR}

echo "🔎 Checking Costume Scheduler at $URL" | tee "$LOGFILE"

# Check base functionality
echo -e "\n[1] Checking root /" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL" | tee -a "$LOGFILE"

echo -e "\n[2] Checking /api/data" | tee -a "$LOGFILE"
curl -s -o /tmp/api_data.json "$URL/api/data"
if [ -s /tmp/api_data.json ]; then
  echo "✅ API data endpoint is working" | tee -a "$LOGFILE"
else
  echo "❌ API data endpoint is NOT working" | tee -a "$LOGFILE"
fi

echo -e "\n[3] Checking main JS script" | tee -a "$LOGFILE"
curl -s -I "$URL/static/js/script.js" | tee -a "$LOGFILE"

echo -e "\n[4] Checking core HTML template" | tee -a "$LOGFILE"
curl -s "$URL" | grep -i "<html" &>/dev/null
if [ $? -eq 0 ]; then
  echo "✅ HTML page detected." | tee -a "$LOGFILE"
else
  echo "❌ HTML not detected in root response." | tee -a "$LOGFILE"
fi

# Check all new pages
echo -e "\n[5] Checking test/gantt" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/gantt" | tee -a "$LOGFILE"

echo -e "\n[6] Checking test/extended" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/extended" | tee -a "$LOGFILE"

echo -e "\n[7] Checking test/editor" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/editor" | tee -a "$LOGFILE"

echo -e "\n[8] Checking dashboard" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/dashboard" | tee -a "$LOGFILE"

# Summary
echo -e "\n===== SUMMARY =====" | tee -a "$LOGFILE"
MAIN_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
GANTT_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/gantt")
EXTENDED_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/extended")
EDITOR_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/editor")
DASHBOARD_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/dashboard")

echo "Main page (/) status: $MAIN_PAGE" | tee -a "$LOGFILE"
echo "Gantt page (/test/gantt) status: $GANTT_PAGE" | tee -a "$LOGFILE"
echo "Extended page (/test/extended) status: $EXTENDED_PAGE" | tee -a "$LOGFILE"
echo "Editor page (/test/editor) status: $EDITOR_PAGE" | tee -a "$LOGFILE"
echo "Dashboard page (/dashboard) status: $DASHBOARD_PAGE" | tee -a "$LOGFILE"

# Check for version
VERSION=$(grep -o '"version":"[^"]*"' /tmp/api_data.json | head -1 | cut -d'"' -f4)
if [ -n "$VERSION" ]; then
  echo "API version: $VERSION" | tee -a "$LOGFILE"
else
  echo "API version: Could not detect" | tee -a "$LOGFILE"
fi

# Evaluations
if [ "$MAIN_PAGE" == "200" ]; then
  echo "✅ Main page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Main page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$GANTT_PAGE" == "200" ]; then
  echo "✅ Gantt page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Gantt page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$EXTENDED_PAGE" == "200" ]; then
  echo "✅ Extended page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Extended page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$EDITOR_PAGE" == "200" ]; then
  echo "✅ Editor page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Editor page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$DASHBOARD_PAGE" == "200" ]; then
  echo "✅ Dashboard page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Dashboard page is NOT accessible" | tee -a "$LOGFILE"
fi

echo -e "\n📄 Full log saved to $LOGFILE"
