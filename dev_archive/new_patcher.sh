#!/bin/bash

cat << 'OVERLAP_DATA_SCRIPT' > add_overlap_data.sh
#!/bin/bash
set -e

echo "🔧 Adding overlapping data and entry form..."

# Create new test data with overlapping schedules
cat << 'EOF' > data/overlap_test_data.json
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
      "duration_minutes": 15
    },
    {
      "actor": "Bob",
      "dresser": "Dana",
      "item": "suit001",
      "time": "2025-04-03T18:10:00",
      "duration_minutes": 12
    },
    {
      "actor": "Charlie",
      "dresser": "Dana",
      "item": "coat001",
      "time": "2025-04-03T18:05:00",
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
      "dresser": "Eli",
      "item": "cape001",
      "time": "2025-04-03T19:15:00",
      "duration_minutes": 12
    },
    {
      "actor": "Frank",
      "dresser": "Fiona",
      "item": "hat001",
      "time": "2025-04-03T19:50:00",
      "duration_minutes": 5
    },
    {
      "actor": "Alice",
      "dresser": "Eli",
      "item": "hat002",
      "time": "2025-04-03T18:20:00",
      "duration_minutes": 10
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

# Update the test page to add a data entry form
cat << 'EOF' > frontend/templates/test/gantt.html
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler - Gantt Chart</title>
  <link rel="stylesheet" href="/static/css/styles.css">
  <style>
    /* Layout */
    body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
    h1 { margin-bottom: 20px; }
    
    /* Controls */
    .controls { margin-bottom: 20px; padding: 10px; background-color: #f5f5f5; border-radius: 4px; }
    .controls label { margin-right: 10px; }
    #date-selector { padding: 8px; font-size: 16px; }
    #refresh-btn { padding: 8px 16px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
    
    /* Tabs */
    .tabs { display: flex; border-bottom: 1px solid #ccc; margin-bottom: 20px; }
    .tab { padding: 10px 20px; cursor: pointer; border: 1px solid transparent; border-bottom: none; }
    .tab.active { background-color: #f5f5f5; border-color: #ccc; border-radius: 4px 4px 0 0; }
    
    /* Content areas */
    .content { display: none; padding: 20px; border: 1px solid #ccc; border-top: none; }
    .content.active { display: block; }
    
    /* Schedule items */
    .schedule-item { 
      background-color: #4CAF50; 
      color: white; 
      padding: 10px 15px; 
      margin-bottom: 10px; 
      border-radius: 4px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    /* Schedule by dresser - for overlap visibility */
    .dresser-section { 
      margin-bottom: 30px;
      padding: 10px;
      border: 1px solid #eee;
      border-radius: 4px;
      background-color: #f9f9f9;
    }
    
    .dresser-name {
      font-weight: bold;
      margin-bottom: 10px;
      padding-bottom: 5px;
      border-bottom: 1px solid #ddd;
    }
    
    .timeline {
      position: relative;
      height: 150px;
      background-color: #fff;
      border: 1px solid #eee;
      margin-top: 10px;
    }
    
    .time-markers {
      display: flex;
      border-bottom: 1px solid #ddd;
    }
    
    .time-marker {
      flex: 1;
      text-align: center;
      font-size: 12px;
      padding: 5px;
      color: #888;
    }
    
    .time-event {
      position: absolute;
      height: 30px;
      background-color: #4CAF50;
      color: white;
      padding: 5px;
      font-size: 12px;
      border-radius: 4px;
      z-index: 1;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    
    .overlap {
      background-color: #f44336;
    }
    
    /* Wardrobe table */
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #f2f2f2; }
    
    /* Status indicators */
    .available { color: green; }
    .in-use { color: blue; }
    .cleaning { color: orange; }
    
    /* Search */
    .search-box { width: 100%; padding: 10px; margin-bottom: 20px; font-size: 16px; }
    
    /* Form styles */
    .form-container {
      background-color: #f9f9f9;
      padding: 15px;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    
    .form-row {
      display: flex;
      margin-bottom: 10px;
      align-items: center;
    }
    
    .form-label {
      width: 120px;
      font-weight: bold;
    }
    
    .form-input {
      flex: 1;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    
    .form-button {
      padding: 10px 15px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      margin-top: 10px;
    }
    
    .form-button:hover {
      background-color: #45a049;
    }
  </style>
</head>
<body>
  <h1>Costume Scheduler</h1>
  
  <div class="controls">
    <label for="date-selector">Date:</label>
    <input type="date" id="date-selector">
    <button id="refresh-btn">Refresh</button>
  </div>
  
  <div class="tabs">
    <div class="tab active" data-tab="schedule">Schedule</div>
    <div class="tab" data-tab="overlap">Overlap View</div>
    <div class="tab" data-tab="entry">Add New</div>
    <div class="tab" data-tab="wardrobe">Wardrobe</div>
    <div class="tab" data-tab="debug">Debug</div>
  </div>
  
  <div id="schedule" class="content active">
    <h2>Costume Change Schedule</h2>
    <div id="schedule-list"></div>
  </div>
  
  <div id="overlap" class="content">
    <h2>Dresser Overlap View</h2>
    <p>This view shows potential scheduling conflicts where a dresser has overlapping assignments.</p>
    <div id="overlap-view"></div>
  </div>
  
  <div id="entry" class="content">
    <h2>Add New Schedule Entry</h2>
    <div class="form-container">
      <div class="form-row">
        <label class="form-label">Actor:</label>
        <select id="actor-select" class="form-input"></select>
      </div>
      <div class="form-row">
        <label class="form-label">Dresser:</label>
        <select id="dresser-select" class="form-input"></select>
      </div>
      <div class="form-row">
        <label class="form-label">Item:</label>
        <select id="item-select" class="form-input"></select>
      </div>
      <div class="form-row">
        <label class="form-label">Date & Time:</label>
        <input type="datetime-local" id="time-input" class="form-input">
      </div>
      <div class="form-row">
        <label class="form-label">Duration (min):</label>
        <input type="number" id="duration-input" class="form-input" value="10" min="1" max="60">
      </div>
      <button id="add-entry-btn" class="form-button">Add Schedule Entry</button>
      <div id="form-status" style="margin-top: 10px; color: green;"></div>
    </div>
  </div>
  
  <div id="wardrobe" class="content">
    <h2>Wardrobe Inventory</h2>
    <input type="text" id="search-box" class="search-box" placeholder="Search inventory...">
    <div id="wardrobe-list"></div>
  </div>
  
  <div id="debug" class="content">
    <h2>Debug Data</h2>
    <pre id="debug-data" style="background:#f5f5f5; padding:10px; overflow:auto; max-height:500px;"></pre>
  </div>
  
  <script src="/static/js/test/gantt.js"></script>
</body>
</html>
EOF

# Update the JavaScript to handle overlap detection and data entry
cat << 'EOF' > frontend/static/js/test/gantt.js
// Global data
let globalData = null;

// Initialize UI
document.addEventListener('DOMContentLoaded', function() {
  // Set date to today
  const dateSelector = document.getElementById('date-selector');
  const today = new Date().toISOString().split('T')[0];
  dateSelector.value = today;
  
  // Setup tab switching
  const tabs = document.querySelectorAll('.tab');
  tabs.forEach(tab => {
    tab.addEventListener('click', function() {
      // Update active tab
      tabs.forEach(t => t.classList.remove('active'));
      this.classList.add('active');
      
      // Update active content
      const tabId = this.getAttribute('data-tab');
      document.querySelectorAll('.content').forEach(c => c.classList.remove('active'));
      document.getElementById(tabId).classList.add('active');
    });
  });
  
  // Setup refresh button
  document.getElementById('refresh-btn').addEventListener('click', loadData);
  
  // Setup search functionality
  document.getElementById('search-box').addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    const rows = document.querySelectorAll('#wardrobe-list tr');
    
    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      row.style.display = text.includes(searchTerm) ? '' : 'none';
    });
  });
  
  // Setup add entry form submission
  document.getElementById('add-entry-btn').addEventListener('click', addNewEntry);
  
  // Load data initially
  loadData();
});

// Load data from API and update UI
function loadData() {
  const selectedDate = document.getElementById('date-selector').value;
  
  fetch('/api/data')
    .then(response => response.json())
    .then(data => {
      globalData = data;
      renderSchedule(data, selectedDate);
      renderOverlapView(data, selectedDate);
      renderWardrobe(data.wardrobe_items);
      renderDebugData(data);
      populateFormDropdowns(data);
    })
    .catch(error => {
      console.error('Error loading data:', error);
    });
}

// Render schedule for selected date
function renderSchedule(data, selectedDate) {
  const container = document.getElementById('schedule-list');
  container.innerHTML = '';
  
  const schedules = data.schedules || [];
  const filtered = schedules.filter(entry => entry.time.startsWith(selectedDate));
  
  if (filtered.length === 0) {
    container.innerHTML = '<p>No schedule entries found for selected date.</p>';
    return;
  }
  
  // Sort by time
  filtered.sort((a, b) => new Date(a.time) - new Date(b.time));
  
  // Create schedule items
  filtered.forEach(entry => {
    const time = new Date(entry.time);
    const timeStr = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    
    const item = document.createElement('div');
    item.className = 'schedule-item';
    item.innerHTML = `
      <strong>${timeStr}</strong> - 
      <strong>${entry.actor}</strong> - 
      ${entry.item} with 
      <em>${entry.dresser}</em> 
      (${entry.duration_minutes} min)
    `;
    
    container.appendChild(item);
  });
}

// Check if two time ranges overlap
function checkOverlap(start1, duration1, start2, duration2) {
  const s1 = new Date(start1).getTime();
  const e1 = s1 + (duration1 * 60 * 1000);
  const s2 = new Date(start2).getTime();
  const e2 = s2 + (duration2 * 60 * 1000);
  
  return (s1 < e2 && s2 < e1);
}

// Render overlap view
function renderOverlapView(data, selectedDate) {
  const container = document.getElementById('overlap-view');
  container.innerHTML = '';
  
  const schedules = data.schedules || [];
  const filtered = schedules.filter(entry => entry.time.startsWith(selectedDate));
  
  if (filtered.length === 0) {
    container.innerHTML = '<p>No schedule entries found for selected date.</p>';
    return;
  }
  
  // Group by dresser
  const dressers = {};
  filtered.forEach(entry => {
    if (!dressers[entry.dresser]) {
      dressers[entry.dresser] = [];
    }
    dressers[entry.dresser].push(entry);
  });
  
  // Determine time range for the day
  const timeRange = {
    start: new Date(selectedDate + 'T17:00:00'), // 5 PM
    end: new Date(selectedDate + 'T22:00:00')    // 10 PM
  };
  
  const totalMinutes = (timeRange.end - timeRange.start) / (60 * 1000);
  const pixelsPerMinute = 2;
  
  // Create a section for each dresser
  Object.keys(dressers).forEach(dresserName => {
    const dresserEntries = dressers[dresserName];
    
    // Check for overlaps
    for (let i = 0; i < dresserEntries.length; i++) {
      dresserEntries[i].hasOverlap = false;
      for (let j = 0; j < dresserEntries.length; j++) {
        if (i !== j && checkOverlap(
          dresserEntries[i].time, dresserEntries[i].duration_minutes,
          dresserEntries[j].time, dresserEntries[j].duration_minutes
        )) {
          dresserEntries[i].hasOverlap = true;
          break;
        }
      }
    }
    
    // Create dresser section
    const section = document.createElement('div');
    section.className = 'dresser-section';
    
    // Add dresser name
    const title = document.createElement('div');
    title.className = 'dresser-name';
    title.textContent = dresserName;
    section.appendChild(title);
    
    // Create timeline
    const timeline = document.createElement('div');
    timeline.className = 'timeline';
    
    // Add time markers
    const timeMarkers = document.createElement('div');
    timeMarkers.className = 'time-markers';
    
    for (let hour = 17; hour <= 22; hour++) {
      const marker = document.createElement('div');
      marker.className = 'time-marker';
      marker.textContent = `${hour}:00`;
      timeMarkers.appendChild(marker);
    }
    
    timeline.appendChild(timeMarkers);
    
    // Add events to timeline
    dresserEntries.forEach(entry => {
      const entryTime = new Date(entry.time);
      const startMinutes = (entryTime - timeRange.start) / (60 * 1000);
      const duration = entry.duration_minutes;
      
      const event = document.createElement('div');
      event.className = 'time-event' + (entry.hasOverlap ? ' overlap' : '');
      event.style.left = (startMinutes * pixelsPerMinute) + 'px';
      event.style.width = (duration * pixelsPerMinute) + 'px';
      event.style.top = '40px';
      event.textContent = `${entry.actor} - ${entry.item}`;
      event.title = `${entry.actor} - ${entry.item} (${duration} min)`;
      
      timeline.appendChild(event);
    });
    
    section.appendChild(timeline);
    container.appendChild(section);
  });
}

// Render wardrobe inventory
function renderWardrobe(items) {
  const container = document.getElementById('wardrobe-list');
  container.innerHTML = '';
  
  if (!items || items.length === 0) {
    container.innerHTML = '<p>No wardrobe items found.</p>';
    return;
  }
  
  // Create table
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
        <tr>
          <td>${item.id || ''}</td>
          <td>${item.name || ''}</td>
          <td>${item.size || ''}</td>
          <td class="${(item.status || 'available').toLowerCase().replace(/\s+/g, '-')}">${item.status || 'Available'}</td>
        </tr>
      `).join('')}
    </tbody>
  `;
  
  container.appendChild(table);
}

// Render debug data
function renderDebugData(data) {
  const container = document.getElementById('debug-data');
  container.textContent = JSON.stringify(data, null, 2);
}

// Populate form dropdowns
function populateFormDropdowns(data) {
  // Actor dropdown
  const actorSelect = document.getElementById('actor-select');
  actorSelect.innerHTML = '';
  data.agents.actors.forEach(actor => {
    const option = document.createElement('option');
    option.value = actor;
    option.textContent = actor;
    actorSelect.appendChild(option);
  });
  
  // Dresser dropdown
  const dresserSelect = document.getElementById('dresser-select');
  dresserSelect.innerHTML = '';
  data.agents.dressers.forEach(dresser => {
    const option = document.createElement('option');
    option.value = dresser;
    option.textContent = dresser;
    dresserSelect.appendChild(option);
  });
  
  // Item dropdown
  const itemSelect = document.getElementById('item-select');
  itemSelect.innerHTML = '';
  data.wardrobe_items.forEach(item => {
    const option = document.createElement('option');
    option.value = item.id;
    option.textContent = `${item.name} (${item.id})`;
    itemSelect.appendChild(option);
  });
  
  // Set default date/time
  const timeInput = document.getElementById('time-input');
  const now = new Date();
  now.setMinutes(Math.ceil(now.getMinutes() / 5) * 5); // Round to next 5 minutes
  timeInput.value = now.toISOString().slice(0, 16);
}

// Add a new schedule entry
function addNewEntry() {
  const actor = document.getElementById('actor-select').value;
  const dresser = document.getElementById('dresser-select').value;
  const item = document.getElementById('item-select').value;
  const time = document.getElementById('time-input').value;
  const duration = parseInt(document.getElementById('duration-input').value);
  const status = document.getElementById('form-status');
  
  if (!actor || !dresser || !item || !time || isNaN(duration)) {
    status.textContent = 'Please fill all fields correctly.';
    status.style.color = 'red';
    return;
  }
  
  // Create new entry
  const newEntry = {
    actor: actor,
    dresser: dresser,
    item: item,
    time: time + ':00', // Add seconds
    duration_minutes: duration
  };
  
  // Add to global data
  globalData.schedules.push(newEntry);
  
  // Update API
  fetch('/api/update', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(globalData)
  })
  .then(response => response.json())
  .then(data => {
    // Show success message
    status.textContent = 'Entry added successfully!';
    status.style.color = 'green';
    
    // Refresh views
    const selectedDate = document.getElementById('date-selector').value;
    renderSchedule(globalData, selectedDate);
    renderOverlapView(globalData, selectedDate);
    renderDebugData(globalData);
    
    // Clear form
    document.getElementById('duration-input').value = '10';
    
    // Refresh form after 3 seconds
    setTimeout(() => {
      status.textContent = '';
    }, 3000);
  })
  .catch(error => {
    console.error('Error updating data:', error);
    status.textContent = 'Error adding entry. Please try again.';
    status.style.color = 'red';
  });
}
EOF

# Apply the new data
cp data/overlap_test_data.json data/data.json

echo "✅ Added overlapping data and entry form"
echo "🔹 Restart your Flask server with: python3 backend/app.py"
echo "🔹 Then visit: http://127.0.0.1:5000/test/gantt"
OVERLAP_DATA_SCRIPT

chmod +x add_overlap_data.sh
echo "✅ Created script to add overlapping data and entry form. Run it with: ./add_overlap_data.sh"
