# Costume Scheduler – Changelog

## v0.5.0 – April 2025
- 🧭 **Unified Navigation System**:
  - Added consistent navigation menu across all pages
  - Improved user flow between different features
  - Added help documentation for each feature
- 📊 **Enhanced Timeline View**:
  - Changed time frame from 8am to 12pm
  - Added time frame selector to zoom in on blocks of time
  - Added minute-level precision for scheduling
  - Implemented time increment selector per show
- 🏠 **Updated Routes Structure**:
  - Moved stable features from `/test/*` to `/feature/*`
  - Set dashboard as the initial landing page at `/`
  - Moved original page to `/legacy` for backward compatibility
- 💾 **Export/Import Improvements**:
  - Added export CSV button to all data views
  - Improved download/upload functionality
  - Added "Copy to Clipboard" button to all feature pages
- 🧪 **Experimental Dashboard**:
  - Created at `/test/dashboard`
  - Added feature menu on right 20% side of page
  - Implemented dynamic content loading in 80% of page
  - Added auto-scaling to window width
- 🔄 **Git Management Tool**:
  - Added interactive branch management
  - Implemented automatic version tagging
  - Created conflict resolution tools
  - Added .gitignore management functionality
  - Implemented file restoration from previous commits
- 📄 **Reports Page**:
  - Created comprehensive reporting system
  - Added inventory summary reports
  - Implemented schedule analysis reports
  - Added dresser workload reports
  - Added CSV and clipboard export options
- 📥 **PDF Import Tool**:
  - Created PDF to CSV converter for inventory imports
  - Added automatic field mapping
  - Implemented "review" placeholder for missing data
  - Added batch processing capability
- 🔧 **Bug Fixes**:
  - Fixed route conflicts in Flask application
  - Resolved duplicate endpoint function issue
  - Fixed template missing errors
  - Improved error handling throughout application
- 📚 **Documentation Improvements**:
  - Updated README.md with full deployment instructions
  - Enhanced project directory documentation
  - Added help sections to all feature pages
  - Fixed formatting in summary.md

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
