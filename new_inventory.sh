#!/bin/bash

cat << 'DASHBOARD_FIX_SCRIPT' > fix_and_update.sh
#!/bin/bash
set -e

echo "🔧 Fixing editor issues and creating dashboard..."

# Update version information
cat << 'EOF' > version.json
{
  "backend": "v0.4.0",
  "frontend": "v0.4.0"
}
EOF
echo "✅ Updated version information to v0.4.0"

# Create missing wardrobe_editor.html with correct path
cat << 'EOF' > frontend/templates/test/wardrobe_editor.html
<!DOCTYPE html>
<html>
<head>
  <title>Wardrobe Inventory Editor</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    
    h1, h2, h3 {
      color: #333;
    }
    
    /* Navigation */
    .nav-menu {
      background: #333;
      padding: 10px;
      margin-bottom: 20px;
      border-radius: 4px;
    }
    
    .nav-menu a {
      color: white;
      text-decoration: none;
      padding: 8px 12px;
      margin-right: 5px;
      border-radius: 4px;
    }
    
    .nav-menu a:hover {
      background: #555;
    }
    
    .nav-menu a.active {
      background: #4CAF50;
    }
    
    /* Toolbar */
    .toolbar {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
      padding: 15px;
      background: #f5f5f5;
      border-radius: 4px;
    }
    
    .toolbar-section {
      display: flex;
      gap: 10px;
      align-items: center;
    }
    
    button, select, input[type="text"] {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    
    button {
      background: #4CAF50;
      color: white;
      border: none;
      cursor: pointer;
    }
    
    button:hover {
      background: #45a049;
    }
    
    button.delete {
      background: #f44336;
    }
    
    button.delete:hover {
      background: #d32f2f;
    }
    
    .search-box {
      padding: 8px 12px;
      width: 250px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
      font-size: 14px;
    }
    
    th {
      background: #f2f2f2;
      text-align: left;
      padding: 10px;
      border-bottom: 2px solid #ddd;
    }
    
    td {
      padding: 10px;
      border-bottom: 1px solid #ddd;
    }
    
    tr:hover {
      background: #f9f9f9;
    }
    
    .status-available { color: green; }
    .status-in-use { color: blue; }
    .status-cleaning { color: orange; }
    .status-in-repair { color: red; }
    
    /* Modal styles */
    .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.5);
      z-index: 1000;
    }
    
    .modal-content {
      background: white;
      margin: 10% auto;
      padding: 20px;
      border-radius: 5px;
      width: 60%;
      max-width: 800px;
      max-height: 80vh;
      overflow-y: auto;
    }
    
    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #ddd;
      padding-bottom: 10px;
      margin-bottom: 20px;
    }
    
    .close {
      font-size: 24px;
      cursor: pointer;
    }
    
    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
    }
    
    .form-field {
      margin-bottom: 15px;
    }
    
    .form-field label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    
    .form-field input, .form-field select, .form-field textarea {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    
    .form-field textarea {
      min-height: 80px;
    }
    
    .form-field.full-width {
      grid-column: 1 / span 2;
    }
    
    .modal-footer {
      margin-top: 20px;
      text-align: right;
      border-top: 1px solid #ddd;
      padding-top: 15px;
    }
  </style>
</head>
<body>
  <div class="nav-menu">
    <a href="/">Home</a>
    <a href="/test/gantt">Gantt Chart</a>
    <a href="/test/extended">Extended View</a>
    <a href="/test/editor" class="active">Inventory Editor</a>
    <a href="/dashboard">Dashboard</a>
  </div>

  <h1>Wardrobe Inventory Editor</h1>
  <p>Manage and edit the costume inventory, including pricing and details.</p>
  
  <div class="toolbar">
    <div class="toolbar-section">
      <button id="add-item-btn">Add New Item</button>
      <button id="edit-selected-btn" disabled>Edit Selected</button>
      <button id="delete-selected-btn" class="delete" disabled>Delete Selected</button>
    </div>
    
    <div class="toolbar-section">
      <select id="category-filter">
        <option value="all">All Categories</option>
        <!-- Categories will be added here dynamically -->
      </select>
      <input type="text" id="search-box" class="search-box" placeholder="Search inventory...">
    </div>
  </div>
  
  <table id="inventory-table">
    <thead>
      <tr>
        <th><input type="checkbox" id="select-all"></th>
        <th>ID</th>
        <th>Name</th>
        <th>Category</th>
        <th>Size</th>
        <th>Status</th>
        <th>Price</th>
        <th>Location</th>
        <th>Condition</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <!-- Inventory items will be added here dynamically -->
    </tbody>
  </table>
  
  <!-- Edit/Add Item Modal -->
  <div id="item-modal" class="modal">
    <div class="modal-content">
      <div class="modal-header">
        <h3 id="modal-title">Add New Item</h3>
        <span class="close">&times;</span>
      </div>
      
      <form id="item-form">
        <input type="hidden" id="item-id">
        
        <div class="form-grid">
          <div class="form-field">
            <label for="item-name">Name:</label>
            <input type="text" id="item-name" required>
          </div>
          
          <div class="form-field">
            <label for="item-category">Category:</label>
            <select id="item-category" required>
              <!-- Categories will be added here dynamically -->
            </select>
          </div>
          
          <div class="form-field">
            <label for="item-size">Size:</label>
            <input type="text" id="item-size" required>
          </div>
          
          <div class="form-field">
            <label for="item-status">Status:</label>
            <select id="item-status" required>
              <option value="Available">Available</option>
              <option value="In Use">In Use</option>
              <option value="Cleaning">Cleaning</option>
              <option value="In Repair">In Repair</option>
            </select>
          </div>
          
          <div class="form-field">
            <label for="item-price">Price ($):</label>
            <input type="number" id="item-price" min="0" max="200" required>
          </div>
          
          <div class="form-field">
            <label for="item-location">Location:</label>
            <input type="text" id="item-location" required>
          </div>
          
          <div class="form-field">
            <label for="item-condition">Condition:</label>
            <select id="item-condition" required>
              <option value="Excellent">Excellent</option>
              <option value="Good">Good</option>
              <option value="Fair">Fair</option>
              <option value="Poor">Poor</option>
            </select>
          </div>
          
          <div class="form-field">
            <label for="item-id-code">ID Code:</label>
            <input type="text" id="item-id-code" required>
          </div>
          
          <div class="form-field full-width">
            <label for="item-notes">Notes:</label>
            <textarea id="item-notes"></textarea>
          </div>
        </div>
        
        <div class="modal-footer">
          <button type="button" class="close-btn">Cancel</button>
          <button type="submit" id="save-item-btn">Save Item</button>
        </div>
      </form>
    </div>
  </div>
  
  <script src="/static/js/test/wardrobe_editor.js"></script>
</body>
</html>
EOF

# Create dashboard HTML
cat << 'EOF' > frontend/templates/dashboard.html
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler Dashboard</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }
    
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 20px;
    }
    
    header {
      background-color: #333;
      color: white;
      padding: 20px;
      margin-bottom: 20px;
    }
    
    h1 {
      margin: 0;
      font-size: 24px;
    }
    
    .main-nav {
      background-color: #444;
      display: flex;
      padding: 10px 20px;
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
    
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      grid-template-rows: auto auto;
      gap: 20px;
      margin-bottom: 20px;
    }
    
    .dashboard-card {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      padding: 20px;
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
    
    .card-actions a {
      text-decoration: none;
      color: #4CAF50;
      font-size: 14px;
    }
    
    .today-schedule, .inventory-summary, .tasks, .system-info {
      height: 300px;
      overflow-y: auto;
    }
    
    .schedule-item {
      background-color: #f9f9f9;
      border-left: 4px solid #4CAF50;
      padding: 10px;
      margin-bottom: 10px;
      border-radius: 0 4px 4px 0;
    }
    
    .schedule-time {
      font-weight: bold;
      color: #4CAF50;
    }
    
    .inventory-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      margin-bottom: 15px;
    }
    
    .category-item {
      display: flex;
      justify-content: space-between;
      padding: 8px;
      background-color: #f5f5f5;
      border-radius: 4px;
    }
    
    .category-name {
      font-weight: bold;
    }
    
    .task-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px;
      margin-bottom: 10px;
      border-bottom: 1px solid #eee;
    }
    
    .task-complete {
      text-decoration: line-through;
      color: #888;
    }
    
    .status-badge {
      padding: 4px 8px;
      border-radius: 10px;
      font-size: 12px;
      color: white;
    }
    
    .status-completed { background-color: #4CAF50; }
    .status-in-progress { background-color: #2196F3; }
    .status-pending { background-color: #FF9800; }
    .status-not-started { background-color: #9E9E9E; }
    
    .system-info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }
    
    .info-item {
      padding: 10px;
      background-color: #f5f5f5;
      border-radius: 4px;
      display: flex;
      justify-content: space-between;
    }
    
    .info-label {
      font-weight: bold;
    }
    
    .version-tag {
      color: #4CAF50;
      font-weight: bold;
    }
    
    #date-selector {
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <header>
    <h1>Costume Scheduler Dashboard</h1>
  </header>
  
  <div class="main-nav">
    <a href="/" class="active">Dashboard</a>
    <a href="/test/gantt">Gantt Chart</a>
    <a href="/test/extended">Extended View</a>
    <a href="/test/editor">Inventory Editor</a>
    <a href="#">Reports</a>
  </div>
  
  <div class="container">
    <div class="date-selector" style="margin-bottom: 20px;">
      <label for="date-selector">Show schedule for: </label>
      <input type="date" id="date-selector">
      <button id="refresh-btn" style="padding: 8px 16px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">Refresh</button>
    </div>
    
    <div class="dashboard-grid">
      <div class="dashboard-card today-schedule">
        <div class="card-header">
          <h2 class="card-title">Today's Schedule</h2>
          <div class="card-actions">
            <a href="/test/gantt">View Full Schedule</a>
          </div>
        </div>
        <div id="schedule-list">
          <!-- Schedule items will be added here dynamically -->
        </div>
      </div>
      
      <div class="dashboard-card inventory-summary">
        <div class="card-header">
          <h2 class="card-title">Inventory Summary</h2>
          <div class="card-actions">
            <a href="/test/editor">Manage Inventory</a>
          </div>
        </div>
        <div id="inventory-summary">
          <!-- Inventory summary will be added here dynamically -->
        </div>
      </div>
      
      <div class="dashboard-card tasks">
        <div class="card-header">
          <h2 class="card-title">Wardrobe Tasks</h2>
          <div class="card-actions">
            <a href="#" id="add-task-btn">Add Task</a>
          </div>
        </div>
        <div id="task-list">
          <!-- Tasks will be added here dynamically -->
        </div>
      </div>
      
      <div class="dashboard-card system-info">
        <div class="card-header">
          <h2 class="card-title">System Information</h2>
          <div class="card-actions">
            <a href="#" id="check-system-btn">Check System</a>
          </div>
        </div>
        <div class="system-info-grid">
          <div class="info-item">
            <span class="info-label">Backend Version:</span>
            <span id="backend-version" class="version-tag">-</span>
          </div>
          <div class="info-item">
            <span class="info-label">Frontend Version:</span>
            <span id="frontend-version" class="version-tag">-</span>
          </div>
          <div class="info-item">
            <span class="info-label">Database Status:</span>
            <span id="db-status">-</span>
          </div>
          <div class="info-item">
            <span class="info-label">Last Updated:</span>
            <span id="last-updated">-</span>
          </div>
          <div class="info-item">
            <span class="info-label">Total Inventory Items:</span>
            <span id="inventory-count">-</span>
          </div>
          <div class="info-item">
            <span class="info-label">Total Schedule Entries:</span>
            <span id="schedule-count">-</span>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <script>
    // Global data
    let globalData = null;
    
    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
      // Set date to today
      const dateSelector = document.getElementById('date-selector');
      const today = new Date().toISOString().split('T')[0];
      dateSelector.value = today;
      
      // Setup refresh button
      document.getElementById('refresh-btn').addEventListener('click', fetchData);
      
      // Fetch initial data
      fetchData();
      
      // Set up system check button
      document.getElementById('check-system-btn').addEventListener('click', checkSystem);
    });
    
    // Fetch data from API
    function fetchData() {
      const date = document.getElementById('date-selector').value;
      
      fetch('/api/data')
        .then(response => response.json())
        .then(data => {
          globalData = data;
          
          // Render all dashboard sections
          renderSchedule(data.schedules, date);
          renderInventorySummary(data.wardrobe_items);
          renderTasks(data.tasks);
          updateSystemInfo(data);
        })
        .catch(error => {
          console.error('Error fetching data:', error);
        });
    }
    
    // Render schedule for selected date
    function renderSchedule(schedules, date) {
      const container = document.getElementById('schedule-list');
      container.innerHTML = '';
      
      const filtered = schedules.filter(entry => entry.time.startsWith(date));
      
      if (filtered.length === 0) {
        container.innerHTML = '<p>No schedule entries for selected date.</p>';
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
        
        let itemHtml = `
          <div class="schedule-time">${timeStr}</div>
          <div><strong>${entry.actor}</strong> - ${entry.item}</div>
          <div>Dresser: ${entry.dresser} (${entry.duration_minutes} min)</div>
        `;
        
        if (entry.notes) {
          itemHtml += `<div style="font-style: italic; margin-top: 5px;">${entry.notes}</div>`;
        }
        
        item.innerHTML = itemHtml;
        container.appendChild(item);
      });
    }
    
    // Render inventory summary
    function renderInventorySummary(items) {
      const container = document.getElementById('inventory-summary');
      container.innerHTML = '';
      
      if (!items || items.length === 0) {
        container.innerHTML = '<p>No inventory items found.</p>';
        return;
      }
      
      // Group by category
      const categories = {};
      items.forEach(item => {
        const category = item.category || 'Uncategorized';
        if (!categories[category]) {
          categories[category] = 0;
        }
        categories[category]++;
      });
      
      // Status counts
      const statuses = {
        'Available': 0,
        'In Use': 0,
        'Cleaning': 0,
        'In Repair': 0
      };
      
      items.forEach(item => {
        const status = item.status || 'Available';
        if (statuses[status] !== undefined) {
          statuses[status]++;
        }
      });
      
      // Create category grid
      const grid = document.createElement('div');
      grid.className = 'inventory-grid';
      
      Object.keys(categories).forEach(category => {
        const item = document.createElement('div');
        item.className = 'category-item';
        item.innerHTML = `
          <span class="category-name">${category}</span>
          <span>${categories[category]} items</span>
        `;
        grid.appendChild(item);
      });
      
      container.appendChild(grid);
      
      // Add status summary
      const statusSummary = document.createElement('div');
      statusSummary.innerHTML = `
        <h3 style="margin-top: 20px;">Item Status</h3>
        <div class="inventory-grid">
          <div class="category-item">
            <span class="category-name" style="color: green;">Available</span>
            <span>${statuses['Available']} items</span>
          </div>
          <div class="category-item">
            <span class="category-name" style="color: blue;">In Use</span>
            <span>${statuses['In Use']} items</span>
          </div>
          <div class="category-item">
            <span class="category-name" style="color: orange;">Cleaning</span>
            <span>${statuses['Cleaning']} items</span>
          </div>
          <div class="category-item">
            <span class="category-name" style="color: red;">In Repair</span>
            <span>${statuses['In Repair']} items</span>
          </div>
        </div>
      `;
      
      container.appendChild(statusSummary);
    }
    
    // Render tasks
    function renderTasks(tasks) {
      const container = document.getElementById('task-list');
      container.innerHTML = '';
      
      if (!tasks || tasks.length === 0) {
        container.innerHTML = '<p>No tasks found.</p>';
        return;
      }
      
      // Sort by deadline
      tasks.sort((a, b) => new Date(a.deadline) - new Date(b.deadline));
      
      // Create task items
      tasks.forEach(task => {
        const item = document.createElement('div');
        item.className = 'task-item';
        
        const isCompleted = task.status === 'Completed';
        const nameClass = isCompleted ? 'task-complete' : '';
        
        let statusClass = 'status-not-started';
        
        switch (task.status) {
          case 'Completed':
            statusClass = 'status-completed';
            break;
          case 'In Progress':
            statusClass = 'status-in-progress';
            break;
          case 'Pending':
            statusClass = 'status-pending';
            break;
        }
        
        item.innerHTML = `
          <div>
            <div class="${nameClass}">${task.name}</div>
            <div style="font-size: 12px; color: #666;">Assigned to: ${task.assigned_to}</div>
          </div>
          <div class="status-badge ${statusClass}">${task.status || 'Not Started'}</div>
        `;
        
        container.appendChild(item);
      });
    }
    
    // Update system information
    function updateSystemInfo(data) {
      document.getElementById('backend-version').textContent = data.version || 'Unknown';
      document.getElementById('frontend-version').textContent = data.version || 'Unknown';
      document.getElementById('db-status').textContent = 'Connected';
      document.getElementById('last-updated').textContent = new Date().toLocaleString();
      document.getElementById('inventory-count').textContent = data.wardrobe_items.length;
      document.getElementById('schedule-count').textContent = data.schedules.length;
    }
    
    // Check system status
    function checkSystem() {
      fetch('/api/data')
        .then(response => {
          if (response.ok) {
            alert('System is working properly! Data API is responding.');
          } else {
            alert('System error: Data API is not responding correctly.');
          }
        })
        .catch(error => {
          alert('System error: ' + error.message);
        });
    }
  </script>
</body>
</html>
EOF

# Update the frontend_checker.sh script
cat << 'EOF' > check_frontend_enhanced.sh
#!/bin/bash

PORT=${1:-5000}
LOGDIR=logs
LOGFILE=${LOGDIR}/"frontend_check_$(date +%Y%m%d_%H%M%S).log"
URL="http://127.0.0.1:$PORT"

[[ -d "$LOGDIR" ]] || mkdir -pv ${LOGDIR}

echo "🔎 Checking Costume Scheduler at $URL" | tee "$LOGFILE"

# Check base functionality
echo -e "\n[1] Checking root /" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL" | tee -a "$LOGFILE"

echo -e "\n[2] Checking /api/data" | tee -a "$LOGFILE"
curl -s -o /tmp/api_data.json "$URL/api/data"
if [ -s /tmp/api_data.json ]; then
  echo "✅ API data endpoint is working" | tee -a "$LOGFILE"
else
  echo "❌ API data endpoint is NOT working" | tee -a "$LOGFILE"
fi

echo -e "\n[3] Checking main JS script" | tee -a "$LOGFILE"
curl -s -I "$URL/static/js/script.js" | tee -a "$LOGFILE"

echo -e "\n[4] Checking core HTML template" | tee -a "$LOGFILE"
curl -s "$URL" | grep -i "<html" &>/dev/null
if [ $? -eq 0 ]; then
  echo "✅ HTML page detected." | tee -a "$LOGFILE"
else
  echo "❌ HTML not detected in root response." | tee -a "$LOGFILE"
fi

# Check all new pages
echo -e "\n[5] Checking test/gantt" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/gantt" | tee -a "$LOGFILE"

echo -e "\n[6] Checking test/extended" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/extended" | tee -a "$LOGFILE"

echo -e "\n[7] Checking test/editor" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/test/editor" | tee -a "$LOGFILE"

echo -e "\n[8] Checking dashboard" | tee -a "$LOGFILE"
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/dashboard" | tee -a "$LOGFILE"

# Summary
echo -e "\n===== SUMMARY =====" | tee -a "$LOGFILE"
MAIN_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
GANTT_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/gantt")
EXTENDED_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/extended")
EDITOR_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/test/editor")
DASHBOARD_PAGE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/dashboard")

echo "Main page (/) status: $MAIN_PAGE" | tee -a "$LOGFILE"
echo "Gantt page (/test/gantt) status: $GANTT_PAGE" | tee -a "$LOGFILE"
echo "Extended page (/test/extended) status: $EXTENDED_PAGE" | tee -a "$LOGFILE"
echo "Editor page (/test/editor) status: $EDITOR_PAGE" | tee -a "$LOGFILE"
echo "Dashboard page (/dashboard) status: $DASHBOARD_PAGE" | tee -a "$LOGFILE"

# Check for version
VERSION=$(grep -o '"version":"[^"]*"' /tmp/api_data.json | head -1 | cut -d'"' -f4)
if [ -n "$VERSION" ]; then
  echo "API version: $VERSION" | tee -a "$LOGFILE"
else
  echo "API version: Could not detect" | tee -a "$LOGFILE"
fi

# Evaluations
if [ "$MAIN_PAGE" == "200" ]; then
  echo "✅ Main page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Main page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$GANTT_PAGE" == "200" ]; then
  echo "✅ Gantt page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Gantt page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$EXTENDED_PAGE" == "200" ]; then
  echo "✅ Extended page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Extended page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$EDITOR_PAGE" == "200" ]; then
  echo "✅ Editor page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Editor page is NOT accessible" | tee -a "$LOGFILE"
fi

if [ "$DASHBOARD_PAGE" == "200" ]; then
  echo "✅ Dashboard page is accessible" | tee -a "$LOGFILE"
else
  echo "❌ Dashboard page is NOT accessible" | tee -a "$LOGFILE"
fi

echo -e "\n📄 Full log saved to $LOGFILE"
EOF

# Create the dashboard route
cat << 'EOF' > add_dashboard_route.py
#!/usr/bin/env python3
import os

def add_routes_to_app():
    app_file = "backend/app.py"

    # Read the current content
    with open(app_file, "r") as f:
        content = f.read()

    # Create the routes to add
    routes_to_add = """
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html')
"""

    # Find if there are any missing routes
    missing_routes = []

    if "@app.route('/dashboard')" not in content:
        missing_routes.append("/dashboard")

    if not missing_routes:
        print("✅ All routes already exist in app.py")
        return

    # Insert the routes
    if "if __name__ == \"__main__\"" in content:
        content = content.replace("if __name__ == \"__main__\"", routes_to_add + "\nif __name__ == \"__main__\"")

        # Write back to the file
        with open(app_file, "w") as f:
            f.write(content)

        print(f"✅ Added routes to app.py: {', '.join(missing_routes)}")
    else:
        print("❌ Could not find the right position to insert the routes")
        print("Please manually add the following to your app.py file:")
        print(routes_to_add)

if __name__ == "__main__":
    add_routes_to_app()
EOF

# Make the Python script executable
chmod +x add_dashboard_route.py

# Add the route to app.py
python3 add_dashboard_route.py

echo "✅ Fixed editor template issue and added dashboard"
echo "✅ Updated version to v0.4.0"
echo "✅ Created enhanced frontend checker"
echo "🔹 Restart your Flask server with: python3 backend/app.py"
echo "🔹 Run the enhanced checker with: ./check_frontend_enhanced.sh"
DASHBOARD_FIX_SCRIPT

chmod +x fix_and_update.sh
echo "✅ Created fix script. Run it with: ./fix_and_update.sh"
