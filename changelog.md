# Costume Scheduler – Changelog

## v0.4.0 – April 2025
- 🔄 **Fixed Missing Templates**:
  - Added missing `wardrobe_editor.html` template
  - Fixed 404 errors at `/test/editor`
- 📊 **New Dashboard Feature**:
  - Created comprehensive dashboard at `/dashboard`
  - Shows today's schedule, inventory summary, and tasks
  - Displays system status and version information
  - Provides quick access to all system features
- 🧭 **Navigation Improvements**:
  - Added navigation menus to all sub-pages
  - Consistent interface across all views
  - Better user flow between different functionalities
- 🧪 **Testing Enhancements**:
  - Created `check_frontend_enhanced.sh` for testing all routes
  - Improved error reporting and system diagnostics
  - Better version tracking and status checking
- 🔄 **Version Alignment**:
  - Updated both frontend and backend to v0.4.0
  - Centralized version management in version.json

## v0.3.6 – April 2025
- 🛠️ **Wardrobe Editor**:
  - Added inventory editor at `/test/editor`
  - Full CRUD functionality for wardrobe items
  - Category filtering and search capability
  - Detailed item view with condition and pricing
- 📈 **Extended Timeline View**:
  - Added `/test/extended` for scheduling visualization
  - Better handling of longer costume changes
  - Conflict detection and highlighting
  - Detailed timeline with improved UI
- 📋 **Inventory Backfill**:
  - Added comprehensive inventory categorization
  - Implemented pricing structure for rentals
  - Added location tracking for all items
  - Enhanced item condition monitoring

## v0.3.0 – April 2025
- 🎨 **Gantt Chart Renderer**:
  - Displays scheduled tasks per selected date
  - Filters entries by ISO date and renders a table in the DOM
- 🪟 **Debug Panel**:
  - Added raw JSON viewer in the UI
  - Helps with offline or airgapped debugging
- 📋 **Copy Button**:
  - One-click button copies the current JSON data to the clipboard
- 🧠 **Console Output**:
  - Logs full API payload, filtered schedule data, and version info
- 🧼 **Improved script structure**:
  - All renderers and utility functions are isolated and readable

## v0.2.9 – April 2025
- 🔍 Adds version reporting in browser console: `Frontend Script Version: v0.2.9`
- 🧩 Injects version string into page via `<span id="versionTag">`
- 💡 Adds support for dynamic version cache-busting using `?v=...` on JS/CSS
- 🧪 Initial support for rendering filtered data

## v0.2.6 – April 2025
- 🧵 **Backend Improvements**:
  - Improved port handling and conflict resolution
  - Better error reporting and logging
  - Added file download and upload capabilities
  - Improved data management and validation

## v0.2.1 – April 2025
- 💾 **Smart Port Handling**:
  - Adds port availability check to `app.py`
  - Automatically identifies the PID using port 5000
  - Prompts the user to kill or select an alternate port
  - Prevents Flask from crashing if the port is already bound

## v0.1.0 – April 2025
- 🚀 **Initial Release**:
  - Basic Flask application with static file serving
  - Simple JSON data structure for costume scheduling
  - Basic Gantt chart visualization
  - Frontend and backend integration
  - Directory structure and file organization
