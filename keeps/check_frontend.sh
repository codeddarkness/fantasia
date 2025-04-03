#!/bin/bash

PORT=${1:-5000}
LOGDIR=logs
LOGFILE=${LOGDIR}/"costume_check_$(date +%Y%m%d_%H%M%S).log"
URL="http://127.0.0.1:$PORT"

[[ -d "$LOGDIR" ]] || mkdir -pv ${LOGDIR}

echo "🔎 Checking Costume Scheduler at $URL" | tee "$LOGFILE"

# Check base functionality
echo -e "\n[1] Checking root /" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL" | tee -a "$LOGFILE"

echo -e "\n[2] Checking /api/data" | tee -a "$LOGFILE"
curl -s -o /tmp/api_data.json "$URL/api/data"
cat /tmp/api_data.json | tee -a "$LOGFILE"

echo -e "\n[3] Checking JS script" | tee -a "$LOGFILE"
curl -s -I "$URL/static/js/script.js" | tee -a "$LOGFILE"

echo -e "\n[4] Checking core HTML template" | tee -a "$LOGFILE"
curl -s "$URL" | grep -i "<html" &>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ HTML page detected." | tee -a "$LOGFILE"
else
    echo "❌ HTML not detected in root response." | tee -a "$LOGFILE"
fi

# Check new test page
echo -e "\n[5] Checking test page" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/gantt" | tee -a "$LOGFILE"

echo -e "\n[6] Checking test JS" | tee -a "$LOGFILE"
curl -s -I "$URL/static/js/test/gantt-test.js" | tee -a "$LOGFILE"

# Verify data format - extract wardrobe items count
ITEMS_COUNT=$(cat /tmp/api_data.json | grep -o '"wardrobe_items"' | wc -l)
SCHEDULES_COUNT=$(cat /tmp/api_data.json | grep -o '"schedules"' | wc -l)

echo -e "\n[7] Data validation" | tee -a "$LOGFILE"
echo "  - Wardrobe items found: $ITEMS_COUNT" | tee -a "$LOGFILE"
echo "  - Schedule entries found: $SCHEDULES_COUNT" | tee -a "$LOGFILE"

if [ $ITEMS_COUNT -gt 0 ] && [ $SCHEDULES_COUNT -gt 0 ]; then
    echo "✅ Data format appears valid" | tee -a "$LOGFILE"
else
    echo "⚠️ Data format may be incomplete" | tee -a "$LOGFILE"
fi

# Summary
echo -e "\n===== SUMMARY =====" | tee -a "$LOGFILE"
MAIN_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
TEST_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/gantt")

echo "Main page (/) status: $MAIN_PAGE" | tee -a "$LOGFILE"
echo "Test page (/test/gantt) status: $TEST_PAGE" | tee -a "$LOGFILE"

if [ "$MAIN_PAGE" == "200" ]; then
    echo "✅ Main page is accessible" | tee -a "$LOGFILE"
else
    echo "❌ Main page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$TEST_PAGE" == "200" ]; then
    echo "✅ Test page is accessible" | tee -a "$LOGFILE"
else
    echo "❌ Test page is NOT accessible" | tee -a "$LOGFILE"
fi

echo -e "\n📄 Full log saved to $LOGFILE"

# Create or update status.html with results
cat << EOF > status.html
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler Status</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
    .status-good { color: green; }
    .status-bad { color: red; }
    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
    th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #f2f2f2; }
    .action-button { display: inline-block; margin: 5px; padding: 8px 16px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>Costume Scheduler Status</h1>
  <p>Last checked: $(date)</p>
  
  <table>
    <tr>
      <th>Feature</th>
      <th>Status</th>
    </tr>
    <tr>
      <td>Main Page</td>
      <td class="$([ "$MAIN_PAGE" == "200" ] && echo "status-good" || echo "status-bad")">
        $([ "$MAIN_PAGE" == "200" ] && echo "✅ Available" || echo "❌ Not Available")
      </td>
    </tr>
    <tr>
      <td>Test Page</td>
      <td class="$([ "$TEST_PAGE" == "200" ] && echo "status-good" || echo "status-bad")">
        $([ "$TEST_PAGE" == "200" ] && echo "✅ Available" || echo "❌ Not Available")
      </td>
    </tr>
    <tr>
      <td>Data Integrity</td>
      <td class="$([ $ITEMS_COUNT -gt 0 ] && [ $SCHEDULES_COUNT -gt 0 ] && echo "status-good" || echo "status-bad")">
        $([ $ITEMS_COUNT -gt 0 ] && [ $SCHEDULES_COUNT -gt 0 ] && echo "✅ Valid" || echo "⚠️ Issues Detected")
      </td>
    </tr>
  </table>
  
  <h2>Quick Actions</h2>
  <a href="$URL" class="action-button">View Main Page</a>
  <a href="$URL/test/gantt" class="action-button">View Test Page</a>
  <a href="$URL/api/data" class="action-button">View API Data</a>
  
  <h2>Log Excerpt</h2>
  <pre>$(tail -n 20 "$LOGFILE")</pre>
</body>
</html>
EOF

echo "✅ Status page generated: status.html"
echo "To open status page: open status.html"
