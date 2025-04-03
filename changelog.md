# Costume Scheduler – Changelog

## v0.3.0 – April 2, 2025
- 🎨 **Gantt Chart Renderer**:
  - Displays scheduled tasks per selected date.
  - Filters entries by ISO date and renders a table in the DOM.
- 🪟 **Debug Panel**:
  - `<pre>` element in the UI shows raw JSON from `/api/data`.
  - Helps with offline or airgapped debugging.
- 📋 **Copy Button**:
  - One-click button copies the current JSON data to the clipboard.
- 🧠 **Console Output**:
  - Logs full API payload, filtered schedule data, and version info.
- 🧼 **Improved script structure**:
  - All renderers and utility functions are isolated and readable.

## v0.2.9
- 🔍 Adds version reporting in browser console: `Frontend Script Version: v0.2.9`
- 🧩 Injects version string into page via `<span id="versionTag">`
- 💡 Adds support for dynamic version cache-busting using `?v=...` on JS/CSS
- 🧪 Initial support for rendering filtered data (not visible yet)

## v0.2.8 and earlier
- Versioning infrastructure, script patchers, and JSON loaders established.
- Data validation and shell utility `check_frontend.sh` introduced.
- JSON structure standardized across `schedules`, `tasks`, `wardrobe_items`, and `agents`.


