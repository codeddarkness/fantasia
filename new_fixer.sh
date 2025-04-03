#!/bin/bash

cat << 'MANUAL_FIX' > fix_gantt_manual.sh
#!/bin/bash
set -e

echo "🔧 Fixing Gantt chart page implementation..."

# Create required directories
mkdir -p frontend/templates/test
mkdir -p frontend/static/js/test
mkdir -p frontend/static/css/test

# First, let's create a simple backup of app.py
cp backend/app.py backend/app.py.bak

# Now, manually add the route to app.py by appending it before the main block
ROUTE_TO_ADD="
@app.route('/test/gantt')
def test_gantt():
    return render_template('test/gantt.html')
"

# Find the line number where if __name__ starts
LINE_NUM=$(grep -n "if __name__" backend/app.py | head -1 | cut -d':' -f1)

if [ -n "$LINE_NUM" ]; then
    # Use head and tail to split the file and insert our route
    head -n $(($LINE_NUM - 1)) backend/app.py > backend/app.py.temp
    echo "$ROUTE_TO_ADD" >> backend/app.py.temp
    tail -n +$LINE_NUM backend/app.py >> backend/app.py.temp
    mv backend/app.py.temp backend/app.py
    echo "✅ Added route to app.py"
else
    # If we can't find the if __name__ line, just append the route to the end
    echo "$ROUTE_TO_ADD" >> backend/app.py
    echo "⚠️ Appended route to end of app.py - check format"
fi

# Create the basic templates and JS files
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
    <div class="tab" data-tab="wardrobe">Wardrobe</div>
    <div class="tab" data-tab="debug">Debug</div>
  </div>
  
  <div id="schedule" class="content active">
    <h2>Costume Change Schedule</h2>
    <div id="schedule-list"></div>
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

cat << 'EOF' > frontend/static/js/test/gantt.js
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
  
  // Load data initially
  loadData();
});

// Load data from API and update UI
function loadData() {
  const selectedDate = document.getElementById('date-selector').value;
  
  fetch('/api/data')
    .then(response => response.json())
    .then(data => {
      renderSchedule(data, selectedDate);
      renderWardrobe(data.wardrobe_items);
      renderDebugData(data);
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
EOF

echo "✅ Created Gantt chart implementation"
echo "🔹 Restart your Flask server with: python3 backend/app.py"
echo "🔹 Then visit: http://127.0.0.1:5000/test/gantt"
MANUAL_FIX

chmod +x fix_gantt_manual.sh
echo "✅ Created simplified fix script. Run it with: ./fix_gantt_manual.sh"
