#!/bin/bash

cat << 'GANTT_TEST_PAGE' > create_test_pages.sh
#!/bin/bash
set -e

echo "🧪 Creating test pages for Costume Scheduler..."

# Create the Gantt chart test page
mkdir -p frontend/templates/test
mkdir -p frontend/static/js/test

# Create the main test page
cat << 'EOF' > frontend/templates/test/gantt.html
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler - Test Page</title>
  <link rel="stylesheet" href="/static/css/styles.css">
  <script src="https://cdn.jsdelivr.net/npm/vis-timeline@7.7.0/dist/vis-timeline-graph2d.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/vis-timeline@7.7.0/dist/vis-timeline-graph2d.min.css" rel="stylesheet" type="text/css" />
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; }
    #gantt-container, #wardrobe-container { margin-top: 20px; margin-bottom: 30px; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
    #timeline { height: 300px; }
    .tab-container { margin-top: 20px; }
    .tab-button { padding: 10px 20px; margin-right: 5px; cursor: pointer; border: 1px solid #ccc; border-bottom: none; border-radius: 5px 5px 0 0; }
    .tab-button.active { background-color: #f0f0f0; }
    .tab-content { display: none; padding: 20px; border: 1px solid #ccc; }
    .tab-content.active { display: block; }
    .actor-name { font-weight: bold; color: #2c3e50; }
    .dresser-name { color: #16a085; }
    .item-name { font-style: italic; color: #8e44ad; }
    .time-info { color: #c0392b; }
    .gantt-bar { background-color: #3498db; color: white; padding: 8px; margin: 8px 0; border-radius: 4px; box-shadow: 2px 2px 4px rgba(0,0,0,0.2); }
    .gantt-row { margin-bottom: 12px; }
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
    tr:hover { background-color: #f5f5f5; }
    th { background-color: #f0f0f0; }
    .search-box { padding: 8px; margin-bottom: 15px; width: 100%; box-sizing: border-box; }
    .inventory-item { border: 1px solid #ddd; padding: 10px; margin: 5px 0; border-radius: 4px; }
    .control-panel { margin-bottom: 20px; padding: 10px; background-color: #f9f9f9; border-radius: 5px; }
  </style>
</head>
<body>
  <h1>Costume Scheduler - Test Page</h1>
  
  <div class="tab-container">
    <button class="tab-button active" onclick="openTab('schedule')">Schedule View</button>
    <button class="tab-button" onclick="openTab('wardrobe')">Wardrobe Inventory</button>
    <button class="tab-button" onclick="openTab('debug')">Debug Panel</button>
  </div>
  
  <div id="schedule" class="tab-content active">
    <div class="control-panel">
      <h3>Schedule Controls</h3>
      <label>Date: <input type="date" id="date-selector"></label>
      <button onclick="refreshGanttChart()">Refresh</button>
    </div>
    
    <h2>Gantt Chart View</h2>
    <div id="timeline"></div>
    
    <h2>List View</h2>
    <div id="gantt-container"></div>
  </div>
  
  <div id="wardrobe" class="tab-content">
    <div class="control-panel">
      <h3>Wardrobe Controls</h3>
      <input type="text" id="inventory-search" class="search-box" placeholder="Search inventory...">
    </div>
    
    <h2>Wardrobe Inventory</h2>
    <div id="wardrobe-container"></div>
  </div>
  
  <div id="debug" class="tab-content">
    <h2>Raw Data</h2>
    <pre id="debug-panel" style="max-height: 400px; overflow: auto; background: #f5f5f5; padding: 10px;"></pre>
  </div>
  
  <script src="/static/js/test/gantt-test.js"></script>
</body>
</html>
EOF

# Create the JavaScript file for the test page
cat << 'EOF' > frontend/static/js/test/gantt-test.js
// Global variables
let scheduleData = null;

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Set date selector to today
  const dateSelector = document.getElementById('date-selector');
  const today = new Date().toISOString().split('T')[0];
  dateSelector.value = today;
  
  // Add event listener for inventory search
  document.getElementById('inventory-search').addEventListener('input', filterInventory);
  
  // Load data
  fetchData();
});

// Tab functionality
function openTab(tabName) {
  // Hide all tab contents
  const tabContents = document.getElementsByClassName('tab-content');
  for (let i = 0; i < tabContents.length; i++) {
    tabContents[i].classList.remove('active');
  }
  
  // Remove active class from all tab buttons
  const tabButtons = document.getElementsByClassName('tab-button');
  for (let i = 0; i < tabButtons.length; i++) {
    tabButtons[i].classList.remove('active');
  }
  
  // Show the selected tab content and mark its button as active
  document.getElementById(tabName).classList.add('active');
  
  // Find and activate the button for this tab
  const buttons = document.getElementsByClassName('tab-button');
  for (let i = 0; i < buttons.length; i++) {
    if (buttons[i].textContent.toLowerCase().includes(tabName)) {
      buttons[i].classList.add('active');
    }
  }
}

// Fetch data from API
function fetchData() {
  fetch('/api/data')
    .then(response => response.json())
    .then(data => {
      scheduleData = data;
      refreshGanttChart();
      renderWardrobeInventory(data.wardrobe_items);
      renderDebugPanel(data);
    })
    .catch(error => {
      console.error('Error fetching data:', error);
      document.getElementById('gantt-container').innerHTML = '<p>Error loading data. Please check console.</p>';
    });
}

// Refresh Gantt chart based on selected date
function refreshGanttChart() {
  if (!scheduleData) return;
  
  const selectedDate = document.getElementById('date-selector').value;
  renderGanttChart(scheduleData, selectedDate);
  renderTimelineChart(scheduleData, selectedDate);
}

// Render Gantt chart
function renderGanttChart(data, selectedDate) {
  const container = document.getElementById('gantt-container');
  container.innerHTML = '';
  
  const schedules = data.schedules || [];
  const filtered = schedules.filter(entry => entry.time.startsWith(selectedDate));
  
  if (filtered.length === 0) {
    container.innerHTML = '<p>No schedule entries found for the selected date.</p>';
    return;
  }
  
  // Sort by time
  filtered.sort((a, b) => new Date(a.time) - new Date(b.time));
  
  // Create list view
  filtered.forEach(entry => {
    const row = document.createElement('div');
    row.className = 'gantt-row';
    
    const timeStr = new Date(entry.time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    const durationStr = entry.duration_minutes ? `(${entry.duration_minutes} min)` : '';
    
    row.innerHTML = `
      <div class="gantt-bar">
        <span class="time-info">${timeStr} ${durationStr}</span> - 
        <span class="actor-name">${entry.actor}</span> with 
        <span class="dresser-name">${entry.dresser}</span> for 
        <span class="item-name">${entry.item}</span>
      </div>
    `;
    container.appendChild(row);
  });
}

// Render Timeline chart using vis.js
function renderTimelineChart(data, selectedDate) {
  const container = document.getElementById('timeline');
  container.innerHTML = '';
  
  const schedules = data.schedules || [];
  const filtered = schedules.filter(entry => entry.time.startsWith(selectedDate));
  
  if (filtered.length === 0) {
    container.innerHTML = '<p>No schedule entries found for the selected date.</p>';
    return;
  }
  
  // Create dataset for timeline
  const items = new vis.DataSet(
    filtered.map((entry, index) => {
      const startTime = new Date(entry.time);
      const endTime = new Date(startTime.getTime() + (entry.duration_minutes * 60000));
      
      return {
        id: index,
        content: `<b>${entry.actor}</b>: ${entry.item}`,
        start: startTime,
        end: endTime,
        group: entry.dresser
      };
    })
  );
  
  // Get unique dressers for groups
  const dressers = [...new Set(filtered.map(entry => entry.dresser))];
  const groups = new vis.DataSet(
    dressers.map((dresser, index) => ({
      id: dresser,
      content: dresser
    }))
  );
  
  // Configure timeline options
  const options = {
    stack: true,
    editable: false,
    margin: {
      item: 10,
      axis: 5
    }
  };
  
  // Initialize the timeline
  new vis.Timeline(container, items, groups, options);
}

// Render wardrobe inventory
function renderWardrobeInventory(items) {
  const container = document.getElementById('wardrobe-container');
  container.innerHTML = '';
  
  if (!items || items.length === 0) {
    container.innerHTML = '<p>No wardrobe items found.</p>';
    return;
  }
  
  // Create wardrobe table
  const table = document.createElement('table');
  table.innerHTML = `
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Size</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      ${items.map(item => `
        <tr class="inventory-item">
          <td>${item.id || ''}</td>
          <td>${item.name || ''}</td>
          <td>${item.size || ''}</td>
          <td>${item.status || 'Available'}</td>
        </tr>
      `).join('')}
    </tbody>
  `;
  
  container.appendChild(table);
}

// Filter inventory based on search input
function filterInventory() {
  const searchTerm = document.getElementById('inventory-search').value.toLowerCase();
  const rows = document.querySelectorAll('#wardrobe-container .inventory-item');
  
  rows.forEach(row => {
    const text = row.textContent.toLowerCase();
    if (text.includes(searchTerm)) {
      row.style.display = '';
    } else {
      row.style.display = 'none';
    }
  });
}

// Render debug panel
function renderDebugPanel(data) {
  const debugPanel = document.getElementById('debug-panel');
  debugPanel.textContent = JSON.stringify(data, null, 2);
}
EOF

# Create a route to serve the test page
cat << 'EOF' > gantt_route_patch.py
from flask import render_template

# Add this to your Flask routes in backend/app.py:
@app.route('/test/gantt')
def test_gantt():
    return render_template('test/gantt.html')
EOF

# Generate a sample data file
cat << 'EOF' > data/sample_costume_data.json
{
  "version": "v0.3.5",
  "agents": {
    "actors": ["Alice", "Bob", "Charlie", "David", "Emily", "Frank"],
    "dressers": ["Dana", "Eli", "Fiona"],
    "managers": ["Morgan"]
  },
  "wardrobe_items": [
    { "id": "hat001", "name": "Top Hat", "size": "M", "status": "Available" },
    { "id": "dress001", "name": "Red Evening Gown", "size": "S", "status": "In Use" },
    { "id": "coat001", "name": "Trench Coat", "size": "L", "status": "Available" },
    { "id": "cape001", "name": "Velvet Cape", "size": "M", "status": "Cleaning" },
    { "id": "boots001", "name": "Leather Boots", "size": "42", "status": "Available" },
    { "id": "hat002", "name": "Bowler Hat", "size": "S", "status": "Available" },
    { "id": "dress002", "name": "Blue Cocktail Dress", "size": "M", "status": "Available" },
    { "id": "suit001", "name": "Tuxedo", "size": "L", "status": "Available" },
    { "id": "suit002", "name": "Victorian Suit", "size": "M", "status": "Available" },
    { "id": "gloves001", "name": "White Gloves", "size": "S", "status": "Available" }
  ],
  "schedules": [
    {
      "actor": "Alice",
      "dresser": "Dana",
      "item": "dress001",
      "time": "2025-04-03T18:00:00",
      "duration_minutes": 10
    },
    {
      "actor": "Bob",
      "dresser": "Eli",
      "item": "suit001",
      "time": "2025-04-03T18:15:00",
      "duration_minutes": 12
    },
    {
      "actor": "Charlie",
      "dresser": "Dana",
      "item": "coat001",
      "time": "2025-04-03T18:30:00",
      "duration_minutes": 8
    },
    {
      "actor": "Alice",
      "dresser": "Fiona",
      "item": "dress002",
      "time": "2025-04-03T19:10:00",
      "duration_minutes": 15
    },
    {
      "actor": "David",
      "dresser": "Eli",
      "item": "suit002",
      "time": "2025-04-03T19:20:00",
      "duration_minutes": 10
    },
    {
      "actor": "Emily",
      "dresser": "Dana",
      "item": "cape001",
      "time": "2025-04-03T19:40:00",
      "duration_minutes": 7
    },
    {
      "actor": "Frank",
      "dresser": "Fiona",
      "item": "hat001",
      "time": "2025-04-03T19:50:00",
      "duration_minutes": 5
    }
  ],
  "tasks": [
    {
      "name": "Steam Red Evening Gown",
      "assigned_to": "Eli",
      "deadline": "2025-04-03T17:45:00"
    },
    {
      "name": "Repair Trench Coat Button",
      "assigned_to": "Dana",
      "deadline": "2025-04-03T18:10:00"
    },
    {
      "name": "Clean Velvet Cape",
      "assigned_to": "Fiona",
      "deadline": "2025-04-03T18:50:00"
    },
    {
      "name": "Polish Leather Boots",
      "assigned_to": "Morgan",
      "deadline": "2025-04-03T19:30:00"
    }
  ]
}
EOF

echo "✅ Created test pages and sample data"
echo "📋 To use:"
echo "  1. Add the route from gantt_route_patch.py to your backend/app.py file"
echo "  2. Copy the sample data: cp data/sample_costume_data.json data/data.json"
echo "  3. Run the server: python3 backend/app.py"
echo "  4. Visit http://127.0.0.1:5000/test/gantt in your browser"
GANTT_TEST_PAGE

chmod +x create_test_pages.sh
echo "Test page creation script is ready. Run it with: ./create_test_pages.sh"
