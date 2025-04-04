#!/bin/bash
# Costume Scheduler Patch Script - v1.2
# This script implements fixes for menu standardization, route normalization,
# upload functionality, dashboard layout optimization, and gantt chart task entry.

set -e  # Exit on error

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'  # No Color

echo -e "${BLUE}=== Costume Scheduler Patch Script ===${NC}"
echo "This script will apply fixes for menu standardization, route normalization,"
echo "upload functionality, and dashboard layout optimization."
echo

# Check if we're in the right directory
if [ ! -f "backend/app.py" ] || [ ! -d "frontend/templates" ]; then
    echo -e "${RED}Error: This script must be run from the project root directory.${NC}"
    exit 1
fi

# Create backups
echo -e "${BLUE}Creating backups...${NC}"
timestamp=$(date +%Y%m%d_%H%M%S)
mkdir -p backup_${timestamp}/{backend,frontend}
cp -r backend backup_${timestamp}/
cp -r frontend backup_${timestamp}/
echo -e "${GREEN}Backups created in backup_${timestamp}/${NC}"
echo

# 1. Update Dashboard Layout (keep 80/20 split)
echo -e "${BLUE}Updating dashboard layout...${NC}"
cat > frontend/templates/dashboard_new.html <<'EOT'
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler - Dashboard</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
    
    header {
      background-color: #333;
      color: white;
      padding: 20px;
    }
    
    h1, h2, h3 {
      margin: 0;
    }
    
    .container {
      display: flex;
      flex: 1;
      height: calc(100vh - 100px); /* Adjust for header and status bar */
    }
    
    .content-area {
      flex: 0.8; /* 80% of space */
      padding: 20px;
      overflow: auto;
    }
    
    .side-menu {
      flex: 0.2; /* 20% of space */
      background-color: #444;
      color: white;
      padding: 20px;
      box-shadow: -2px 0 5px rgba(0, 0, 0, 0.1);
    }
    
    .feature-button {
      display: block;
      width: 100%;
      padding: 12px;
      margin-bottom: 10px;
      background-color: #555;
      color: white;
      border: none;
      border-radius: 4px;
      text-align: left;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    
    .feature-button:hover {
      background-color: #4CAF50;
    }
    
    .feature-button.active {
      background-color: #4CAF50;
    }
    
    .feature-icon {
      margin-right: 10px;
    }
    
    iframe {
      width: 100%;
      height: 100%;
      border: none;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .welcome-content {
      background-color: white;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      height: calc(100% - 60px); /* Account for padding */
    }
    
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      grid-template-rows: auto auto;
      gap: 20px;
      margin-top: 20px;
    }
    
    .dashboard-card {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      padding: 20px;
      height: 200px;
      overflow: hidden;
    }
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      border-bottom: 1px solid #eee;
      padding-bottom: 10px;
    }
    
    .card-title {
      margin: 0;
      font-size: 18px;
      color: #333;
    }
    
    .help-section {
      margin-top: 30px;
      padding-top: 20px;
      border-top: 1px solid #ddd;
    }
    
    .status-bar {
      background-color: #333;
      color: white;
      padding: 8px 20px;
      font-size: 12px;
      display: flex;
      justify-content: space-between;
    }
    
    .status-indicator {
      color: #4CAF50;
      font-weight: bold;
    }
    
    .version-info {
      color: #aaa;
    }
  </style>
</head>
<body>
  <header>
    <h1>Costume Scheduler - Dashboard</h1>
  </header>
  
  <div class="container">
    <div class="content-area" id="content-area">
      <div class="welcome-content">
        <h2>Welcome to the Costume Scheduler</h2>
        <p>Use the menu on the right to navigate between features. All tools load directly in this content area.</p>
        
        <div class="dashboard-grid">
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Today's Schedule</h3>
            </div>
            <div>
              <p>12 costume changes scheduled for today</p>
              <p>3 dressers assigned</p>
              <p>First change: 18:00</p>
              <p>Last change: 21:45</p>
              <p>Scheduled Events: 48</p>
            </div>
          </div>
          
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Inventory Summary</h3>
            </div>
            <div>
              <p>Available Items: 105</p>
              <p>In Use: 41</p>
              <p>Cleaning: 8</p>
              <p>In Repair: 6</p>
              <p>Inventory Items: 160</p>
            </div>
          </div>
          
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Tasks</h3>
            </div>
            <div>
              <p>• Check costume condition (High Priority)</p>
              <p>• Order new accessories (Due: Tomorrow)</p>
              <p>• Schedule fittings (In Progress)</p>
              <p>• Update inventory database (Completed)</p>
            </div>
          </div>
          
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Recent Activity</h3>
            </div>
            <div>
              <p>• New costume item added (2 mins ago)</p>
              <p>• Schedule updated (15 mins ago)</p>
              <p>• Inventory report exported (1 hour ago)</p>
              <p>• Wardrobe location changed (2 hours ago)</p>
            </div>
          </div>
        </div>
        
        <div class="help-section">
          <h3>Getting Started</h3>
          <p>Use the menu on the right to navigate between features. Each feature will load in this content area, allowing you to work without switching pages.</p>
        </div>
      </div>
    </div>
    
    <div class="side-menu">
      <button class="feature-button active" data-url="/dashboard" onclick="loadContent(this)">
        <span class="feature-icon">📊</span> Dashboard
      </button>
      <button class="feature-button" data-url="/gantt" onclick="loadContent(this)">
        <span class="feature-icon">📅</span> Gantt Chart
      </button>
      <button class="feature-button" data-url="/extended" onclick="loadContent(this)">
        <span class="feature-icon">📈</span> Extended View
      </button>
      <button class="feature-button" data-url="/editor" onclick="loadContent(this)">
        <span class="feature-icon">🛠️</span> Inventory Editor
      </button>
      <button class="feature-button" data-url="/reports" onclick="loadContent(this)">
        <span class="feature-icon">📄</span> Reports
      </button>
      <button class="feature-button" data-url="/legacy" onclick="loadContent(this)">
        <span class="feature-icon">🧩</span> Legacy View
      </button>
    </div>
  </div>
  
  <div class="status-bar">
    <div class="status-indicator">System Status: Online</div>
    <div class="version-info">Frontend Version: v0.5.0 | Backend Version: v0.5.0</div>
  </div>
  
  <script>
    // Load content into the iframe
    function loadContent(button) {
      // Remove active class from all buttons
      const buttons = document.querySelectorAll('.feature-button');
      buttons.forEach(btn => btn.classList.remove('active'));
      
      // Add active class to clicked button
      button.classList.add('active');
      
      // Get content URL
      const url = button.getAttribute('data-url');
      
      // Clear current content
      const contentArea = document.getElementById('content-area');
      
      // If Dashboard is selected, show the welcome content
      if (url === '/dashboard') {
        contentArea.innerHTML = document.querySelector('.welcome-content').outerHTML;
        return;
      }
      
      // Create iframe for other features
      contentArea.innerHTML = '';
      const iframe = document.createElement('iframe');
      iframe.src = url;
      contentArea.appendChild(iframe);
    }
    
    // Initialize the dashboard
    document.addEventListener('DOMContentLoaded', function() {
      // Save the welcome content for later use
      const welcomeContent = document.querySelector('.welcome-content').outerHTML;
      document.querySelector('.welcome-content').setAttribute('data-original', welcomeContent);
      
      // Set the active button
      const dashboardButton = document.querySelector('[data-url="/dashboard"]');
      dashboardButton.classList.add('active');
    });
  </script>
</body>
</html>
EOT
echo -e "${GREEN}Dashboard layout updated${NC}"
echo

# 2. Add responsive menu detection to feature pages
echo -e "${BLUE}Creating responsive menu detection script...${NC}"
mkdir -p frontend/static/js/utils
cat > frontend/static/js/utils/responsive-menu.js <<'EOT'
// Responsive Menu Detection
(function() {
  function detectIframe() {
    if (window.self !== window.top) {
      // We're in an iframe, hide navigation
      const navElements = document.querySelectorAll('.main-nav, nav, header');
      navElements.forEach(el => {
        if (el) el.style.display = 'none';
      });
      
      // Add padding to body to compensate for removed nav
      document.body.style.paddingTop = '0';
      
      // Add class to body for iframe-specific styling
      document.body.classList.add('in-iframe');
    }
  }
  
  // Run on load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', detectIframe);
  } else {
    detectIframe();
  }
})();
EOT
echo -e "${GREEN}Responsive menu script created${NC}"
echo

# 3. Create the Gantt Chart with task entry
echo -e "${BLUE}Creating updated Gantt Chart template with task entry...${NC}"
cat > frontend/templates/feature/gantt.html <<'EOT'
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler - Gantt Chart</title>
  <link rel="stylesheet" href="/static/css/styles.css">
  <script src="/static/js/utils/responsive-menu.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    
    h1, h2 {
      color: #333;
    }
    
    /* Navigation */
    .main-nav {
      background-color: #444;
      display: flex;
      padding: 10px 20px;
      margin-bottom: 20px;
    }
    
    .main-nav a {
      color: white;
      text-decoration: none;
      padding: 10px 15px;
      margin-right: 5px;
      border-radius: 4px;
    }
    
    .main-nav a:hover, .main-nav a.active {
      background-color: #555;
    }
    
    /* Controls */
    .controls {
      margin-bottom: 20px;
      padding:. 10px;
      background-color: #f5f5f5;
      border-radius: 4px;
    }
    
    .controls label {
      margin-right: 10px;
    }
    
    #date-selector {
      padding: 8px;
      font-size: 16px;
    }
    
    #time-range {
      padding: 8px;
      margin-left: 10px;
      margin-right: 10px;
    }
    
    #refresh-btn {
      padding: 8px 16px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    
    /* Help link */
    .help-link {
      display: inline-block;
      margin-left: 10px;
      color: #4CAF50;
      text-decoration: none;
      font-size: 14px;
    }
    
    .help-content {
      display: none;
      background-color: #f9f9f9;
      padding: 15px;
      border-radius: 4px;
      margin-top: 10px;
      margin-bottom: 20px;
      border-left: 4px solid #4CAF50;
    }
    
    /* Schedule items */
    .schedule-item {
      background-color: #4CAF50;
      color: white;
      padding: 10px 15px;
      margin-bottom: 10px;
      border-radius: 4px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    /* Table styles */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    
    th, td {
      padding: 10px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    
    th {
      background-color: #f2f2f2;
    }
    
    /* Export buttons */
    .export-buttons {
      margin-top: 20px;
      display: flex;
      gap: 10px;
    }
    
    .export-button {
      padding: 8px 16px;
      background: #2196F3;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    
    /* Task Entry Form */
    .task-entry {
      margin-top: 30px;
      padding: 20px;
      background-color: #f9f9f9;
      border-radius: 4px;
      border-left: 4px solid #4CAF50;
    }
    
    .task-entry h3 {
      margin-top: 0;
      margin-bottom: 15px;
    }
    
    .form-group {
      margin-bottom: 15px;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    
    .form-group select,
    .form-group input {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    
    .form-group button {
      padding: 10px 16px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      margin-top: 10px;
    }
    
    .form-group button:hover {
      background-color: #45a049;
    }
  </style>
</head>
<body>
  <header>
    <h1>Costume Scheduler - Gantt Chart</h1>
  </header>
  
  <!-- Navigation Menu -->
  <div class="main-nav">
    <a href="/" id="nav-dashboard">Dashboard</a>
    <a href="/gantt" id="nav-gantt" class="active">Gantt Chart</a>
    <a href="/extended" id="nav-extended">Extended View</a>
    <a href="/editor" id="nav-editor">Inventory Editor</a>
    <a href="/reports" id="nav-reports">Reports</a>
  </div>
  
  <div class="controls">
    <label for="date-selector">Date:</label>
    <input type="date" id="date-selector">
    
    <label for="time-range">Time Range:</label>
    <select id="time-range">
      <option value="all">Full Day (8am-12am)</option>
      <option value="morning">Morning (8am-12pm)</option>
      <option value="afternoon">Afternoon (12pm-4pm)</option>
      <option value="evening">Evening (4pm-8pm)</option>
      <option value="night">Night (8pm-12am)</option>
    </select>
    
    <button id="refresh-btn">Refresh</button>
    <a href="#" class="help-link" onclick="toggleHelp(); return false;">Help</a>
  </div>
  
  <div class="help-content" id="help-content">
    <h3>Gantt Chart Help</h3>
    <p>This view shows the costume change schedule in a Gantt chart format, which allows you to visualize the timing of all costume changes for a selected date.</p>
    <ul>
      <li><strong>Date Selection:</strong> Choose a specific date to view schedule for that day.</li>
      <li><strong>Time Range:</strong> Filter the schedule to focus on a specific time period.</li>
      <li><strong>Refresh:</strong> Update the chart after changing settings.</li>
      <li><strong>Export Options:</strong> Export the schedule data as CSV or copy to clipboard.</li>
      <li><strong>Add Assignment:</strong> Use the form below to add new costume assignments.</li>
    </ul>
    <p>The chart shows each costume change with actor name, dresser, item, time, and duration. This helps you plan and manage your wardrobe department efficiently.</p>
  </div>
  
  <div id="ganttContainer"></div>
  
  <!-- Task Entry Form -->
  <div class="task-entry">
    <h3>Add Costume Assignment</h3>
    <div class="form-group">
      <label for="actor-select">Actor:</label>
      <select id="actor-select"></select>
    </div>
    <div class="form-group">
      <label for="dresser-select">Dresser:</label>
      <select id="dresser-select"></select>
    </div>
    <div class="form-group">
      <label for="costume-select">Costume Item:</label>
      <select id="costume-select"></select>
    </div>
    <div class="form-group">
      <label for="time-input">Date & Time:</label>
      <input type="datetime-local" id="time-input">
    </div>
    <div class="form-group">
      <label for="duration-input">Duration (minutes):</label>
      <input type="number" id="duration-input" value="10" min="1" max="60">
    </div>
    <div class="form-group">
      <button id="add-assignment-btn">Add Assignment</button>
      <span id="assignment-status"></span>
    </div>
  </div>
  
  <div class="export-buttons">
    <button id="export-csv-btn" class="export-button">Export as CSV</button>
    <button id="copy-btn" class="export-button">Copy to Clipboard</button>
    <a href="/api/download" download><button class="export-button">Download JSON</button></a>
  </div>
  
  <pre id="debugPanel" style="margin-top:1em; padding:1em; background:#f9f9f9; border:1px solid #ccc; max-height:300px; overflow:auto; display: none;"></pre>
  <span id="versionTag" style="font-size: 0.9em; color: gray; display: block; margin-top: 1em;"></span>
  
  <script>
    // Global variables
    let scheduleData = null;
    const timeRanges = {
      'all': { start: 8, end: 24 },
      'morning': { start: 8, end: 12 },
      'afternoon': { start: 12, end: 16 },
      'evening': { start: 16, end: 20 },
      'night': { start: 20, end: 24 }
    };
    
    // Toggle help content visibility
    function toggleHelp() {
      const helpContent = document.getElementById('help-content');
      helpContent.style.display = helpContent.style.display === 'block' ? 'none' : 'block';
    }
    
    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
      // Set date to today
      const dateSelector = document.getElementById('date-selector');
      const today = new Date().toISOString().split('T')[0];
      dateSelector.value = today;
      
      // Set up event listeners
      dateSelector.addEventListener('change', refreshView);
      document.getElementById('time-range').addEventListener('change', refreshView);
      document.getElementById('refresh-btn').addEventListener('click', fetchData);
      document.getElementById('export-csv-btn').addEventListener('click', exportCSV);
      document.getElementById('copy-btn').addEventListener('click', copyToClipboard);
      document.getElementById('add-assignment-btn').addEventListener('click', addAssignment);
      
      // Set default time for assignment
      const timeInput = document.getElementById('time-input');
      const now = new Date();
      now.setHours(18);
      now.setMinutes(0);
      timeInput.value = now.toISOString().slice(0, 16);
      
      // Initial data fetch
      fetchData();
    });
    
    // Fetch data from API
    function fetchData() {
      fetch('/api/data')
        .then(response => response.json())
        .then(data => {
          scheduleData = data;
          refreshView();
          renderDebugPanel(data);
          populateFormSelects(data);
        })
        .catch(error => {
          console.error('Error fetching data:', error);
        });
    }
    
    // Refresh view based on current settings
    function refreshView() {
      if (!scheduleData) return;
      
      const date = document.getElementById('date-selector').value;
      const timeRangeKey = document.getElementById('time-range').value;
      const { start: startHour, end: endHour } = timeRanges[timeRangeKey];
      
      renderGanttChart(scheduleData, date, startHour, endHour);
    }
    
    // Render Gantt chart
    function renderGanttChart(data, date, startHour, endHour) {
      const container = document.getElementById('ganttContainer');
      container.innerHTML = '';
      
      const schedules = data.schedules || [];
      const filtered = schedules.filter(entry => entry.time.startsWith(date));
      
      if (filtered.length === 0) {
        container.innerHTML = "<p style='padding:1em;'>No schedule entries found for selected date.</p>";
        return;
      }
      
      // Filter by time range
      const startTime = new Date(`${date}T${startHour.toString().padStart(2, '0')}:00:00`);
      const endTime = new Date(`${date}T${endHour.toString().padStart(2, '0')}:00:00`);
      
      const timeRangeFiltered = filtered.filter(entry => {
        const entryTime = new Date(entry.time);
        return entryTime >= startTime && entryTime <= endTime;
      });
      
      if (timeRangeFiltered.length === 0) {
        container.innerHTML = "<p style='padding:1em;'>No schedule entries found for the selected time range.</p>";
        return;
      }
      
      // Sort by time
      timeRangeFiltered.sort((a, b) => new Date(a.time) - new Date(b.time));
      
      // Create table
      const table = document.createElement('table');
      table.innerHTML = `
        <thead>
          <tr>
            <th>Time</th>
            <th>Actor</th>
            <th>Dresser</th>
            <th>Item</th>
            <th>Duration</th>
          </tr>
        </thead>
        <tbody>
          ${timeRangeFiltered.map(entry => {
            const time = new Date(entry.time);
            const formattedTime = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            
            return `
              <tr>
                <td>${formattedTime}</td>
                <td>${entry.actor}</td>
                <td>${entry.dresser}</td>
                <td>${entry.item}</td>
                <td>${entry.duration_minutes} min</td>
              </tr>
            `;
          }).join('')}
        </tbody>
      `;
      
      container.appendChild(table);
    }
    
    // Render debug panel
    function renderDebugPanel(data) {
      const debugEl = document.getElementById('debugPanel');
      if (debugEl) {
        debugEl.textContent = JSON.stringify(data, null, 2);
      }

      const versionTag = document.getElementById('versionTag');
      if (versionTag && data.version) {
        versionTag.textContent = `Version: ${data.version}`;
      }
    }
    
    // Populate form select options
    function populateFormSelects(data) {
      // Actors
      const actorSelect = document.getElementById('actor-select');
      actorSelect.innerHTML = '';
      
      if (data.agents && data.agents.actors) {
        data.agents.actors.forEach(actor => {
          const option = document.createElement('option');
          option.value = actor;
          option.textContent = actor;
          actorSelect.appendChild(option);
        });
      }
      
      // Dressers
      const dresserSelect = document.getElementById('dresser-select');
      dresserSelect.innerHTML = '';
      
      if (data.agents && data.agents.dressers) {
        data.agents.dressers.forEach(dresser => {
          const option = document.createElement('option');
          option.value = dresser;
          option.textContent = dresser;
          dresserSelect.appendChild(option);
        });
      }
      
      // Costume items
      const costumeSelect = document.getElementById('costume-select');
      costumeSelect.innerHTML = '';
      
      if (data.wardrobe_items) {
        data.wardrobe_items.forEach(item => {
          const option = document.createElement('option');
          option.value = item.name;
          option.textContent = item.name;
          costumeSelect.appendChild(option);
        });
      }
    }
    
    // Add new assignment
    function addAssignment() {
      const actorSelect = document.getElementById('actor-select');
      const dresserSelect = document.getElementById('dresser-select');
      const costumeSelect = document.getElementById('costume-select');
      const timeInput = document.getElementById('time-input');
      const durationInput = document.getElementById('duration-input');
      const statusEl = document.getElementById('assignment-status');
      
      // Validate inputs
      if (!actorSelect.value || !dresserSelect.value || !costumeSelect.value || !timeInput.value || !durationInput.value) {
        statusEl.textContent = 'Please fill in all fields';
        statusEl.style.color = 'red';
        return;
      }
      
      // Create new assignment
      const newAssignment = {
        actor: actorSelect.value,
        dresser: dresserSelect.value,
        item: costumeSelect.value,
        time: timeInput.value + ':00', // Add seconds
        duration_minutes: parseInt(durationInput.value, 10)
      };
      
      // Add to existing data
      scheduleData.schedules.push(newAssignment);
      
      // Save to server
      fetch('/api/update', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(scheduleData)
      })
      .then(response => response.json())
      .then(data => {
        statusEl.textContent = 'Assignment added successfully!';
        statusEl.style.color = 'green';
        
        // Refresh view
        refreshView();
        
        // Clear status after 3 seconds
        setTimeout(() => {
          statusEl.textContent = '';
        }, 3000);
      })
      .catch(error => {
        console.error('Error saving assignment:', error);
        statusEl.textContent = 'Error adding assignment';
        statusEl.style.color = 'red';
      });
    }
    
    // Export schedule as CSV
    function exportCSV() {
      if (!scheduleData) return;
      
      const date = document.getElementById('date-selector').value;
      const timeRangeKey = document.getElementById('time-range').value;
      const { start: startHour, end: endHour } = timeRanges[timeRangeKey];
      
      const schedules = scheduleData.schedules || [];
      const filtered = schedules.filter(entry => entry.time.startsWith(date));
      
      // Filter by time range
      const startTime = new Date(`${date}T${startHour.toString().padStart(2, '0')}:00:00`);
      const endTime = new Date(`${date}T${endHour.toString().padStart(2, '0')}:00:00`);

      const timeRangeFiltered = filtered.filter(entry => {
        const entryTime = new Date(entry.time);
        return entryTime >= startTime && entryTime <= endTime;
      });

      if (timeRangeFiltered.length === 0) {
        alert('No data to export');
        return;
      }

      // Create CSV content
      let csv = 'Date,Time,Actor,Dresser,Item,Duration\n';

      timeRangeFiltered.forEach(entry => {
        const time = new Date(entry.time);
        const formattedTime = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

        csv += `${date},${formattedTime},${entry.actor},${entry.dresser},"${entry.item}",${entry.duration_minutes}\n`;
      });

      // Create download link
      const blob = new Blob([csv], { type: 'text/csv' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `costume_schedule_${date}_${timeRangeKey}.csv`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }

    // Copy schedule data to clipboard
    function copyToClipboard() {
      if (!scheduleData) return;

      const date = document.getElementById('date-selector').value;
      const timeRangeKey = document.getElementById('time-range').value;
      const { start: startHour, end: endHour } = timeRanges[timeRangeKey];

      const schedules = scheduleData.schedules || [];
      const filtered = schedules.filter(entry => entry.time.startsWith(date));

      // Filter by time range
      const startTime = new Date(`${date}T${startHour.toString().padStart(2, '0')}:00:00`);
      const endTime = new Date(`${date}T${endHour.toString().padStart(2, '0')}:00:00`);

      const timeRangeFiltered = filtered.filter(entry => {
        const entryTime = new Date(entry.time);
        return entryTime >= startTime && entryTime <= endTime;
      });

      if (timeRangeFiltered.length === 0) {
        alert('No data to copy');
        return;
      }

      // Create text content
      let text = `Costume Schedule for ${date} (${timeRangeKey})\n\n`;
      text += 'Time | Actor | Dresser | Item | Duration\n';
      text += '------|-------|---------|------|----------\n';

      timeRangeFiltered.forEach(entry => {
        const time = new Date(entry.time);
        const formattedTime = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

        text += `${formattedTime} | ${entry.actor} | ${entry.dresser} | ${entry.item} | ${entry.duration_minutes} min\n`;
      });

      // Copy to clipboard
      navigator.clipboard.writeText(text)
        .then(() => alert('Schedule copied to clipboard'))
        .catch(err => console.error('Error copying to clipboard:', err));
    }
  </script>
</body>
</html>
EOT
echo -e "${GREEN}Gantt Chart template updated with task entry${NC}"
echo

# 4. Update other templates with responsive menu script (macOS compatible)
echo -e "${BLUE}Updating other feature templates...${NC}"
for template in frontend/templates/feature/*.html; do
  if [ -f "$template" ] && [ "$template" != "frontend/templates/feature/gantt.html" ]; then
    echo "Updating $template with responsive menu script"

    # Create a temporary file for processing
    temp_file=$(mktemp)

    # Check if responsive-menu.js script already exists in the file
    if ! grep -q "responsive-menu.js" "$template"; then
      # Add the script tag before the closing head tag
      awk '/<\/head>/ { print "  <script src=\"/static/js/utils/responsive-menu.js\"></script>"; print; next } { print }' "$template" > "$temp_file"
      mv "$temp_file" "$template"
    fi

    # Fix navigation links (macOS compatible)
    temp_file=$(mktemp)
    cat "$template" | sed 's|href="/test/gantt"|href="/gantt"|g' | \
                      sed 's|href="/test/extended"|href="/extended"|g' | \
                      sed 's|href="/test/editor"|href="/editor"|g' | \
                      sed 's|href="/test/dashboard"|href="/dashboard"|g' > "$temp_file"
    mv "$temp_file" "$template"
  fi
done
echo -e "${GREEN}Feature templates updated${NC}"
echo

# 5. Fix Upload Functionality
echo -e "${BLUE}Fixing upload functionality...${NC}"
cat > frontend/static/js/upload.js <<'EOT'
// Fixed file upload functionality
function uploadJSON() {
  const fileInput = document.getElementById('uploadInput');
  if (!fileInput.files || fileInput.files.length === 0) {
    alert('Please select a file to upload');
    return;
  }

  const file = fileInput.files[0];
  const reader = new FileReader();

  reader.onload = function(e) {
    try {
      const data = JSON.parse(e.target.result);

      // Log data for debugging
      console.log("Parsed JSON data:", data);

      fetch('/api/upload', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
      })
      .then(response => {
        console.log("Upload response status:", response.status);
        return response.json();
      })
      .then(result => {
        console.log("Upload result:", result);
        if (result.status === 'uploaded') {
          alert('File uploaded successfully!');
          window.location.reload();
        } else {
          alert('Upload failed: ' + (result.message || result.status));
        }
      })
      .catch(error => {
        console.error("Upload error:", error);
        alert('Upload error: ' + error);
      });
    } catch (error) {
      console.error("JSON parse error:", error);
      alert('Invalid JSON file: ' + error);
    }
  };

  reader.readAsText(file);
}

// Add event listener after DOM content is loaded
document.addEventListener('DOMContentLoaded', function() {
  const uploadButton = document.querySelector('button[onclick="uploadJSON()"]');
  if (uploadButton) {
    uploadButton.onclick = uploadJSON;
  }
});
EOT

# Update index.html to include the new upload.js script (macOS compatible)
if grep -q "/static/js/script.js" frontend/templates/index.html; then
  temp_file=$(mktemp)
  awk '/<script src="\/static\/js\/script.js/ { print "  <script src=\"/static/js/upload.js\"></script>"; print; next } { print }' frontend/templates/index.html > "$temp_file"
  mv "$temp_file" frontend/templates/index.html
fi
echo -e "${GREEN}Upload functionality fixed${NC}"
echo

# 6. Create a diagnostic tool for checking routes and links
echo -e "${BLUE}Creating diagnostic tool...${NC}"
cat > check_routes.sh <<'EOT'
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
EOT
chmod +x check_routes.sh
echo -e "${GREEN}Diagnostic tool created: check_routes.sh${NC}"
echo

# 7. Time frame selector update for extended view
echo -e "${BLUE}Updating time frame selector in extended view...${NC}"
# Create a new file with updated time ranges
if [ -f "frontend/templates/feature/extended_overlap.html" ]; then
  # Create a backup
  cp frontend/templates/feature/extended_overlap.html frontend/templates/feature/extended_overlap.html.bak

  # Create a temporary file for the updated content
  temp_file=$(mktemp)

  # Update the time ranges
  cat frontend/templates/feature/extended_overlap.html.bak | awk '
  /const timeRanges = {/ {
    print "    const timeRanges = {";
    print "      \"all\": { start: 8, end: 24 },";
    print "      \"morning\": { start: 8, end: 12 },";
    print "      \"afternoon\": { start: 12, end: 16 },";
    print "      \"evening\": { start: 16, end: 20 },";
    print "      \"night\": { start: 20, end: 24 }";
    print "    };";
    skip = 1;
    next;
  }
  /};/ {
    if (skip) {
      skip = 0;
      next;
    }
  }
  { if (!skip) print $0 }
  ' > "$temp_file"

  # Replace the original file
  mv "$temp_file" frontend/templates/feature/extended_overlap.html

  # Update dropdown options
  temp_file=$(mktemp)
  cat frontend/templates/feature/extended_overlap.html | sed 's/<option value="all">Full day.*/<option value="all">Full day (8am-12pm)<\/option>/' > "$temp_file"
  mv "$temp_file" frontend/templates/feature/extended_overlap.html

  temp_file=$(mktemp)
  cat frontend/templates/feature/extended_overlap.html | sed 's/<option value="morning">Morning.*/<option value="morning">Morning (8am-12pm)<\/option>/' > "$temp_file"
  mv "$temp_file" frontend/templates/feature/extended_overlap.html

  echo -e "${GREEN}Time frame selector updated in extended view${NC}"
else
  echo -e "${RED}Extended view template not found!${NC}"
fi
echo

# 8. Update version number
echo -e "${BLUE}Updating version numbers...${NC}"
cat > version.json <<'EOT'
{
  "backend": "v0.5.0",
  "frontend": "v0.5.0"
}
EOT
echo -e "${GREEN}Version numbers updated${NC}"
echo

# Final summary
echo -e "${BLUE}=== Patch Complete ===${NC}"
echo "The following changes have been made:"
echo "1. Dashboard layout maintained at 80/20 split"
echo "2. Responsive menu detection added to feature pages"
echo "3. Feature template links normalized (removed /test/ prefixes)"
echo "4. Upload functionality fixed"
echo "5. Task entry form added to Gantt chart page"
echo "6. Diagnostic tool created: check_routes.sh"
echo "7. Time frame selector updated in extended view"
echo "8. Version numbers updated to v0.5.0"
echo
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Start the Flask server: python backend/app.py"
echo "2. Run the diagnostic tool: ./check_routes.sh"
echo "3. Test the upload functionality with a valid JSON file"
echo "4. Try adding a new task assignment in the Gantt chart page"
echo
echo -e "${GREEN}Backup created in backup_${timestamp}/ if you need to revert changes.${NC}"
