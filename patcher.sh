#!/bin/bash
# Apply UI and functionality fixes to Costume Scheduler

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Costume Scheduler UI & Functionality Fixes ===${NC}"
echo ""

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p frontend/templates/feature
echo -e "${GREEN}✓ Created feature directory${NC}"
echo ""

# Create a separate updates directory to store our patches
echo -e "${BLUE}Creating patches directory...${NC}"
mkdir -p patch_files
echo -e "${GREEN}✓ Created patches directory${NC}"
echo ""

# Write utils script to prevent menu duplication in iframes
echo -e "${BLUE}Creating responsive menu utility with iframe detection...${NC}"
cat > frontend/static/js/utils/responsive-menu.js << 'EOF'
// Responsive Menu Detection with iframe protection
(function() {
  function detectIframe() {
    // Check if we're in an iframe
    if (window.self !== window.top) {
      console.log("Detected running in iframe - hiding navigation");
      
      // Hide all navigation elements
      const navElements = document.querySelectorAll('.nav-menu, .main-nav, nav, header');
      navElements.forEach(el => {
        if (el) el.style.display = 'none';
      });
      
      // Add padding to body to compensate for removed nav
      document.body.style.paddingTop = '0';
      
      // Add class to body for iframe-specific styling
      document.body.classList.add('in-iframe');
    } else {
      console.log("Running as main window - showing navigation");
    }
  }
  
  // Run on load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', detectIframe);
  } else {
    detectIframe();
  }
})();
EOF
echo -e "${GREEN}✓ Created responsive menu utility${NC}"
echo ""

# Write dashboard file with fixed content loading and sidebar
echo -e "${BLUE}Creating fixed dashboard template...${NC}"
cat > frontend/templates/dashboard_new.html << 'EOF'
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
      flex: 0.9; /* 90% of space */
      padding: 20px;
      overflow: auto;
    }
    
    .side-menu {
      flex: 0.1; /* 10% of space */
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
      text-align: center;
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
      margin-right: 5px;
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
            <div id="today-schedule">
              <p>Loading schedule data...</p>
            </div>
          </div>
          
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Inventory Summary</h3>
            </div>
            <div id="inventory-summary">
              <p>Loading inventory data...</p>
            </div>
          </div>
          
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Tasks</h3>
            </div>
            <div id="tasks-list">
              <p>Loading task data...</p>
            </div>
          </div>
          
          <div class="dashboard-card">
            <div class="card-header">
              <h3 class="card-title">Recent Activity</h3>
            </div>
            <div id="recent-activity">
              <p>Loading activity data...</p>
            </div>
          </div>
        </div>
        
        <div class="help-section">
          <h3>Getting Started</h3>
          <p>The Costume Scheduler helps theater wardrobe departments manage costumes, dressers, and scheduling. Here's how to get started:</p>
          <ul>
            <li><strong>Gantt Chart</strong> - View and manage costume change schedules in a timeline view</li>
            <li><strong>Extended View</strong> - See potential scheduling conflicts with an overlap detection system</li>
            <li><strong>Inventory Editor</strong> - Manage your costume inventory with complete CRUD functionality</li>
            <li><strong>Reports</strong> - Generate comprehensive reports on inventory and scheduling</li>
          </ul>
        </div>
      </div>
    </div>
    
    <div class="side-menu">
      <button class="feature-button active" data-title="Dashboard" data-url="/" onclick="loadContent(this)">
        📊
      </button>
      <button class="feature-button" data-title="Gantt Chart" data-url="/gantt" onclick="loadContent(this)">
        📅
      </button>
      <button class="feature-button" data-title="Extended View" data-url="/extended" onclick="loadContent(this)">
        📈
      </button>
      <button class="feature-button" data-title="Inventory" data-url="/editor" onclick="loadContent(this)">
        🛠️
      </button>
      <button class="feature-button" data-title="Reports" data-url="/reports" onclick="loadContent(this)">
        📄
      </button>
      <button class="feature-button" data-title="Legacy" data-url="/legacy" onclick="loadContent(this)">
        🧩
      </button>
    </div>
  </div>
  
  <div class="status-bar">
    <div class="status-indicator" id="status-indicator">System Status: Online</div>
    <div class="version-info" id="version-info">Frontend Version: v0.5.0 | Backend Version: v0.5.0</div>
  </div>
  
  <script>
    // Load content into the iframe or content area
    function loadContent(button) {
      const statusIndicator = document.getElementById('status-indicator');
      statusIndicator.textContent = "System Status: Loading...";
      
      // Remove active class from all buttons
      const buttons = document.querySelectorAll('.feature-button');
      buttons.forEach(btn => btn.classList.remove('active'));
      
      // Add active class to clicked button
      button.classList.add('active');
      
      // Update page title
      document.title = "Costume Scheduler - " + button.getAttribute('data-title');
      
      // Get content URL
      const url = button.getAttribute('data-url');
      
      // Clear current content
      const contentArea = document.getElementById('content-area');
      
      // If Dashboard is selected, show the welcome content
      if (url === '/') {
        if (contentArea.querySelector('iframe')) {
          contentArea.removeChild(contentArea.querySelector('iframe'));
          const welcomeContent = document.createElement('div');
          welcomeContent.className = 'welcome-content';
          welcomeContent.innerHTML = document.querySelector('.welcome-content').innerHTML;
          contentArea.appendChild(welcomeContent);
        }
        // Refresh dashboard data
        fetchDashboardData();
        return;
      }
      
      // Create iframe for other features
      contentArea.innerHTML = '';
      const iframe = document.createElement('iframe');
      iframe.src = url;
      iframe.title = button.getAttribute('data-title');
      iframe.onload = function() {
        statusIndicator.textContent = "System Status: Online";
      };
      
      contentArea.appendChild(iframe);
    }
    
    // Fetch dashboard data
    function fetchDashboardData() {
      const statusIndicator = document.getElementById('status-indicator');
      statusIndicator.textContent = "System Status: Loading Data...";
      
      fetch('/api/data')
        .then(response => response.json())
        .then(data => {
          updateDashboardCards(data);
          updateVersionInfo(data.version);
          statusIndicator.textContent = "System Status: Online";
        })
        .catch(error => {
          console.error('Error fetching data:', error);
          statusIndicator.textContent = "System Status: Error Loading Data";
        });
    }
    
    // Update dashboard cards with data
    function updateDashboardCards(data) {
      // Today's schedule
      const todaySchedule = document.getElementById('today-schedule');
      const today = new Date().toISOString().split('T')[0];
      const todayEvents = data.schedules.filter(event => event.time.startsWith(today));
      
      if (todayEvents.length > 0) {
        // Sort by time
        todayEvents.sort((a, b) => new Date(a.time) - new Date(b.time));
        
        // Get first and last times
        const firstTime = new Date(todayEvents[0].time);
        const lastTime = new Date(todayEvents[todayEvents.length - 1].time);
        
        const scheduleHtml = `
          <p>${todayEvents.length} costume changes scheduled for today</p>
          <p>${countUniqueDressers(todayEvents)} dressers assigned</p>
          <p>First change: ${formatTime(firstTime)}</p>
          <p>Last change: ${formatTime(lastTime)}</p>
          <p>Total Schedule Entries: ${data.schedules.length}</p>
        `;
        
        todaySchedule.innerHTML = scheduleHtml;
      } else {
        todaySchedule.innerHTML = `
          <p>No costume changes scheduled for today</p>
          <p>Total Schedule Entries: ${data.schedules.length}</p>
        `;
      }
      
      // Inventory summary
      const inventorySummary = document.getElementById('inventory-summary');
      const statusCounts = countByStatus(data.wardrobe_items);
      
      inventorySummary.innerHTML = `
        <p>Available Items: ${statusCounts.Available || 0}</p>
        <p>In Use: ${statusCounts['In Use'] || 0}</p>
        <p>Cleaning: ${statusCounts.Cleaning || 0}</p>
        <p>In Repair: ${statusCounts['In Repair'] || 0}</p>
        <p>Total Inventory Items: ${data.wardrobe_items.length}</p>
      `;
      
      // Tasks
      const tasksList = document.getElementById('tasks-list');
      if (data.tasks && data.tasks.length > 0) {
        const tasksHtml = data.tasks
          .slice(0, 4)
          .map(task => `<p>• ${task.name} (${task.status || 'Pending'})</p>`)
          .join('');
        
        tasksList.innerHTML = tasksHtml;
      } else {
        tasksList.innerHTML = '<p>No tasks found</p>';
      }
      
      // Recent activity (simulated)
      const recentActivity = document.getElementById('recent-activity');
      recentActivity.innerHTML = `
        <p>• Dashboard viewed (just now)</p>
        <p>• Data loaded (just now)</p>
        <p>• Application started (${formatRelativeTime(new Date())})</p>
        <p>• System check complete (${formatRelativeTime(new Date(new Date().getTime() - 120000))})</p>
      `;
    }
    
    // Helper functions
    function countUniqueDressers(schedules) {
      return new Set(schedules.map(event => event.dresser)).size;
    }
    
    function countByStatus(items) {
      const counts = {};
      items.forEach(item => {
        const status = item.status || 'Available';
        counts[status] = (counts[status] || 0) + 1;
      });
      return counts;
    }
    
    function formatTime(date) {
      return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }
    
    function formatRelativeTime(date) {
      const diff = Math.floor((new Date() - date) / 1000);
      
      if (diff < 60) return 'just now';
      if (diff < 3600) return `${Math.floor(diff / 60)} mins ago`;
      if (diff < 86400) return `${Math.floor(diff / 3600)} hours ago`;
      return `${Math.floor(diff / 86400)} days ago`;
    }
    
    // Update version info
    function updateVersionInfo(version) {
      const versionInfo = document.getElementById('version-info');
      if (version) {
        versionInfo.textContent = `Frontend Version: ${version} | Backend Version: ${version}`;
      } else {
        versionInfo.textContent = `Frontend Version: v0.5.0 | Backend Version: v0.5.0`;
      }
    }
    
    // Initialize the dashboard
    document.addEventListener('DOMContentLoaded', function() {
      // Add tooltips to buttons
      const buttons = document.querySelectorAll('.feature-button');
      buttons.forEach(button => {
        button.title = button.getAttribute('data-title');
      });
      
      // Fetch dashboard data
      fetchDashboardData();
    });
  </script>
</body>
</html>
EOF
echo -e "${GREEN}✓ Created fixed dashboard template${NC}"
echo ""

# Write fixed wardrobe editor with menu detection
echo -e "${BLUE}Creating fixed inventory editor template...${NC}"
cat > frontend/templates/feature/wardrobe_editor.html << 'EOF'
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
    
    /* Hide navigation in iframe */
    body.in-iframe .nav-menu {
      display: none;
    }
  </style>
</head>
<body>
  <div class="nav-menu">
    <a href="/">Home</a>
    <a href="/gantt">Gantt Chart</a>
    <a href="/extended">Extended View</a>
    <a href="/editor" class="active">Inventory Editor</a>
    <a href="/reports">Reports</a>
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
      <button id="export-csv-btn">Export CSV</button>
      <button id="copy-clipboard-btn">Copy to Clipboard</button>
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
  <script src="/static/js/utils/responsive-menu.js"></script>
  <script>
    // Add export CSV functionality
    document.getElementById('export-csv-btn').addEventListener('click', function() {
      if (!globalData || !globalData.wardrobe_items || globalData.wardrobe_items.length === 0) {
        alert('No inventory data to export');
        return;
      }
      
      // Create CSV content
      let csvContent = 'ID,Name,Category,Size,Status,Price,Location,Condition,Notes\n';
      
      globalData.wardrobe_items.forEach(item => {
        const row = [
          item.id,
          item.name || '',
          item.category || '',
          item.size || '',
          item.status || 'Available',
          item.price || '',
          item.location || '',
          item.condition || '',
          (item.notes || '').replace(/,/g, ';') // Replace commas in notes
        ];
        
        csvContent += row.join(',') + '\n';
      });
      
      // Create download link
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
      const link = document.createElement('a');
      const url = URL.createObjectURL(blob);
      link.setAttribute('href', url);
      link.setAttribute('download', 'inventory_' + new Date().toISOString().split('T')[0] + '.csv');
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    });
    
    // Add copy to clipboard functionality
    document.getElementById('copy-clipboard-btn').addEventListener('click', function() {
      if (!globalData) {
        alert('No data to copy');
        return;
      }
      
      const textToCopy = JSON.stringify(globalData, null, 2);
      
      navigator.clipboard.writeText(textToCopy)
        .then(() => {
          alert('Inventory data copied to clipboard');
        })
        .catch(err => {
          console.error('Failed to copy: ', err);
          alert('Failed to copy to clipboard: ' + err);
        });
    });
  </script>
</body>
</html>
EOF
echo -e "${GREEN}✓ Created fixed inventory editor template${NC}"
echo ""

# Create improved PDF to CSV converter
echo -e "${BLUE}Creating improved PDF to CSV converter...${NC}"
cat > pdf_to_csv.py << 'EOF'
#!/usr/bin/env python3

import os
import sys
import pandas as pd
import csv
import logging
from datetime import datetime
import traceback

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("pdf_converter.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Ensure directories exist
def ensure_dirs():
    """Create"""Create necessary directories if they don't exist"""
    os.makedirs("pdf_imports", exist_ok=True)
    os.makedirs("pdf_conversions", exist_ok=True)

def extract_text_from_pdf(pdf_path):
    """Extract text from PDF using PyMuPDF"""
    try:
        import fitz  # PyMuPDF
        
        logger.info(f"Processing {pdf_path}")
        doc = fitz.open(pdf_path)
        
        # Extract text from all pages
        all_text = []
        for page_num in range(len(doc)):
            page = doc.load_page(page_num)
            all_text.append(page.get_text())
        
        return "\n".join(all_text)
    except ImportError:
        logger.error("PyMuPDF (fitz) not installed. Install with: pip install PyMuPDF")
        return None
    except Exception as e:
        logger.error(f"Error extracting text from {pdf_path}: {str(e)}")
        return None

def parse_text_into_data(text_content):
    """Parse text content into structured data"""
    if not text_content:
        return None
    
    # Split into lines
    lines = [line.strip() for line in text_content.split('\n') if line.strip()]
    
    # Try to find table structure
    header_line = None
    for i, line in enumerate(lines):
        # Look for potential headers
        if any(keyword in line.lower() for keyword in ['id', 'name', 'item', 'size', 'category', 'price', 'costume']):
            header_line = i
            break
    
    if header_line is None:
        logger.warning("No table header found in the text")
        return None
    
    # Extract header columns
    header = lines[header_line].split()
    
    # Process data rows
    data = []
    for line in lines[header_line+1:]:
        # Skip lines that are too short
        if len(line.split()) < 3:
            continue
            
        # Split line into columns
        cols = line.split()
        
        # Ensure we have the right number of columns
        # If too many, combine excess columns into the last expected column
        if len(cols) > len(header):
            cols = cols[:len(header)-1] + [' '.join(cols[len(header)-1:])]
        
        # If too few, add "review" values
        while len(cols) < len(header):
            cols.append("review")
            
        data.append(dict(zip(header, cols)))
    
    return data

def save_to_csv(data, output_path):
    """Save parsed data to CSV file"""
    if not data:
        logger.warning(f"No data to save to {output_path}")
        return False
    
    try:
        # Get all field names
        fields = set()
        for item in data:
            fields.update(item.keys())
        
        fields = sorted(list(fields))
        
        # Write to CSV
        with open(output_path, 'w', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fields)
            writer.writeheader()
            writer.writerows(data)
            
        logger.info(f"Successfully wrote {len(data)} rows to {output_path}")
        return True
    except Exception as e:
        logger.error(f"Error writing CSV to {output_path}: {str(e)}")
        return False

def validate_and_clean_data(data):
    """Validate and clean data, filling missing values with 'review'"""
    if not data:
        return []
    
    cleaned_data = []
    standard_fields = ['id', 'name', 'category', 'size', 'status', 'price', 'location', 'condition', 'notes']
    
    # Create mapping of actual fields to standard fields
    field_mapping = {}
    for std_field in standard_fields:
        for actual_field in data[0].keys():
            if std_field in actual_field.lower():
                field_mapping[std_field] = actual_field
                break
    
    # Clean each item
    for idx, item in enumerate(data):
        clean_item = {}
        
        # Map known fields
        for std_field in standard_fields:
            if std_field in field_mapping and field_mapping[std_field] in item:
                clean_item[std_field] = item[field_mapping[std_field]]
            else:
                clean_item[std_field] = "review"
        
        # Generate ID if missing
        if clean_item['id'] == "review" and clean_item['name'] != "review":
            # Create ID from name
            name = clean_item['name']
            name_prefix = ''.join(c for c in name.lower() if c.isalnum())[:5]
            clean_item['id'] = f"{name_prefix}{idx:03d}"
        
        # Ensure status is valid
        valid_statuses = ['Available', 'In Use', 'Cleaning', 'In Repair']
        if clean_item['status'] == "review" or clean_item['status'] not in valid_statuses:
            clean_item['status'] = 'Available'
        
        cleaned_data.append(clean_item)
    
    return cleaned_data

def process_pdf_files():
    """Process all PDF files in the pdf_imports directory"""
    ensure_dirs()
    
    pdf_dir = "pdf_imports"
    csv_dir = "pdf_conversions"
    
    # Get all PDF files
    pdf_files = [f for f in os.listdir(pdf_dir) if f.lower().endswith('.pdf')]
    
    if not pdf_files:
        logger.info("No PDF files found in pdf_imports directory")
        return
    
    logger.info(f"Found {len(pdf_files)} PDF files to process")
    
    processed = 0
    failed = 0
    
    for pdf_file in pdf_files:
        pdf_path = os.path.join(pdf_dir, pdf_file)
        csv_file = os.path.splitext(pdf_file)[0] + '.csv'
        csv_path = os.path.join(csv_dir, csv_file)
        
        try:
            # Extract text from PDF
            text_content = extract_text_from_pdf(pdf_path)
            
            if text_content:
                # Parse into structured data
                parsed_data = parse_text_into_data(text_content)
                
                if parsed_data:
                    # Clean and validate
                    clean_data = validate_and_clean_data(parsed_data)
                    
                    # Save to CSV
                    if save_to_csv(clean_data, csv_path):
                        processed += 1
                    else:
                        failed += 1
                else:
                    logger.warning(f"Failed to parse content from {pdf_file}")
                    failed += 1
            else:
                logger.warning(f"Failed to extract text from {pdf_file}")
                failed += 1
        except Exception as e:
            logger.error(f"Error processing {pdf_file}: {str(e)}")
            logger.debug(traceback.format_exc())
            failed += 1
    
    logger.info(f"Processed {processed} files successfully, {failed} files failed")

if __name__ == "__main__":
    logger.info("Starting PDF to CSV conversion")
    process_pdf_files()
    logger.info("Conversion process complete")
EOF

chmod +x pdf_to_csv.py
echo -e "${GREEN}✓ Created improved PDF to CSV converter${NC}"
echo ""

# Update version.json
echo -e "${BLUE}Updating version information...${NC}"
echo '{
  "backend": "v0.5.0",
  "frontend": "v0.5.0"
}' > version.json
echo -e "${GREEN}✓ Updated version to v0.5.0${NC}"
echo ""

echo -e "${GREEN}Patch application complete!${NC}"
echo -e "${BLUE}Please restart the application to see the changes.${NC}"
