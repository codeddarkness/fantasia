#!/bin/bash
# Route and Link Checking Tool for Costume Scheduler

PORT=${1:-5000}
URL="http://127.0.0.1:${PORT}"
PAGES=("/dashboard" "/gantt" "/extended" "/editor" "/reports" "/legacy" "/test/dashboard")

echo "🔍 Checking Costume Scheduler Pages"
echo "=================================="

for page in "${PAGES[@]}"; do
  echo -n "Testing ${page}... "
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${URL}${page})
  if [ "$STATUS" == "200" ]; then
    echo "✅ [${STATUS}]"
    # Extract links
    LINKS=$(curl -s ${URL}${page} | grep -o 'href="[^"]*"' | sed 's/href="//' | sed 's/"//' | grep -v "^#" | grep -v "^http" | sort | uniq)
    echo "  Links found:"
    for link in $LINKS; do
      if [[ $link == /* ]]; then
        echo -n "    ${link}... "
        LINK_STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${URL}${link})
        if [ "$LINK_STATUS" == "200" ]; then
          echo "✅ [${LINK_STATUS}]"
        else
          echo "❌ [${LINK_STATUS}]"
        fi
      fi
    done
  else
    echo "❌ [${STATUS}]"
  fi
  echo ""
done

echo "Checking API Endpoints"
echo "======================"
API_ENDPOINTS=("/api/data" "/api/upload" "/api/download")

for endpoint in "${API_ENDPOINTS[@]}"; do
  echo -n "Testing ${endpoint}... "
  if [[ "${endpoint}" == "/api/upload" ]]; then
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d '{"test":"data"}' ${URL}${endpoint})
  else
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${URL}${endpoint})
  fi

  if [ "$STATUS" == "200" ]; then
    echo "✅ [${STATUS}]"
  else
    echo "❌ [${STATUS}]"
  fi
done

echo ""
echo "Checking Static Resources"
echo "========================="
RESOURCES=("/static/js/script.js" "/static/css/styles.css" "/static/js/utils/responsive-menu.js" "/static/js/upload.js")

for resource in "${RESOURCES[@]}"; do
  echo -n "Testing ${resource}... "
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${URL}${resource})
  if [ "$STATUS" == "200" ]; then
    echo "✅ [${STATUS}]"
  else
    echo "❌ [${STATUS}]"
  fi
done

echo ""
echo "Done! Run this script after starting the Flask server to verify all routes and links."
