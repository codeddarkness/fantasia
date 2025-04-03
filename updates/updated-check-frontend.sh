#!/bin/bash

PORT=${1:-5000}
LOGDIR=logs
LOGFILE=${LOGDIR}/"frontend_check_$(date +%Y%m%d_%H%M%S).log"
URL="http://127.0.0.1:$PORT"

[[ -d "$LOGDIR" ]] || mkdir -pv ${LOGDIR}

echo "🔎 Checking Costume Scheduler at $URL" | tee "$LOGFILE"

# Check base functionality
echo -e "\n[1] Checking root (Dashboard) /" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL" | tee -a "$LOGFILE"

echo -e "\n[2] Checking legacy page /legacy" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/legacy" | tee -a "$LOGFILE"

echo -e "\n[3] Checking dashboard /dashboard" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/dashboard" | tee -a "$LOGFILE"

# Check primary feature pages
echo -e "\n[4] Checking Gantt Chart /gantt" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/gantt" | tee -a "$LOGFILE"

echo -e "\n[5] Checking Extended View /extended" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/extended" | tee -a "$LOGFILE"

echo -e "\n[6] Checking Inventory Editor /editor" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/editor" | tee -a "$LOGFILE"

echo -e "\n[7] Checking Reports /reports" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/reports" | tee -a "$LOGFILE"

# Check experimental page
echo -e "\n[8] Checking Experimental Dashboard /test/dashboard" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/dashboard" | tee -a "$LOGFILE"

# Check backward compatibility routes
echo -e "\n[9] Checking backward compatibility /test/gantt" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/gantt" | tee -a "$LOGFILE"

echo -e "\n[10] Checking backward compatibility /test/extended" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/extended" | tee -a "$LOGFILE"

echo -e "\n[11] Checking backward compatibility /test/editor" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/editor" | tee -a "$LOGFILE"

# Check API
echo -e "\n[12] Checking /api/data" | tee -a "$LOGFILE"
curl -s -I "$URL/api/data" | head -1 | tee -a "$LOGFILE"

echo -e "\n[13] Checking /api/download" | tee -a "$LOGFILE"
curl -s -I "$URL/api/download" | head -1 | tee -a "$LOGFILE"

# Check static resources
echo -e "\n[14] Checking JS script" | tee -a "$LOGFILE"
curl -s -I "$URL/static/js/script.js" | head -1 | tee -a "$LOGFILE"

echo -e "\n[15] Checking CSS styles" | tee -a "$LOGFILE"
curl -s -I "$URL/static/css/styles.css" | head -1 | tee -a "$LOGFILE"

# Summary
echo -e "\n===== SUMMARY =====" | tee -a "$LOGFILE"
DASHBOARD=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
LEGACY=$(curl -s -o /dev/null -w "%{http_code}" "$URL/legacy")
GANTT=$(curl -s -o /dev/null -w "%{http_code}" "$URL/gantt")
EXTENDED=$(curl -s -o /dev/null -w "%{http_code}" "$URL/extended")
EDITOR=$(curl -s -o /dev/null -w "%{http_code}" "$URL/editor")
REPORTS=$(curl -s -o /dev/null -w "%{http_code}" "$URL/reports")
API_DATA=$(curl -s -o /dev/null -w "%{http_code}" "$URL/api/data")

echo "Dashboard (/) status: $DASHBOARD" | tee -a "$LOGFILE"
echo "Legacy (/legacy) status: $LEGACY" | tee -a "$LOGFILE"
echo "Gantt Chart (/gantt) status: $GANTT" | tee -a "$LOGFILE"
echo "Extended View (/extended) status: $EXTENDED" | tee -a "$LOGFILE"
echo "Inventory Editor (/editor) status: $EDITOR" | tee -a "$LOGFILE"
echo "Reports (/reports) status: $REPORTS" | tee -a "$LOGFILE"
echo "API Data (/api/data) status: $API_DATA" | tee -a "$LOGFILE"

SUCCESS_COUNT=0
TOTAL_CHECKS=7

if [ "$DASHBOARD" == "200" ]; then
  echo "✅ Dashboard is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ Dashboard is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$LEGACY" == "200" ]; then
  echo "✅ Legacy page is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ Legacy page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$GANTT" == "200" ]; then
  echo "✅ Gantt Chart is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ Gantt Chart is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$EXTENDED" == "200" ]; then
  echo "✅ Extended View is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ Extended View is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$EDITOR" == "200" ]; then
  echo "✅ Inventory Editor is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ Inventory Editor is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$REPORTS" == "200" ]; then
  echo "✅ Reports is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ Reports is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$API_DATA" == "200" ]; then
  echo "✅ API Data is accessible" | tee -a "$LOGFILE"
  SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
  echo "❌ API Data is NOT accessible" | tee -a "$LOGFILE"
fi

# Print overall status
echo -e "\nSystem Status: $SUCCESS_COUNT/$TOTAL_CHECKS checks passed" | tee -a "$LOGFILE"
if [ "$SUCCESS_COUNT" -eq "$TOTAL_CHECKS" ]; then
  echo "✅ All checks passed!" | tee -a "$LOGFILE"
else
  echo "⚠️ Some checks failed. Review log for details." | tee -a "$LOGFILE"
fi

echo -e "\n📄 Full log saved to $LOGFILE"
