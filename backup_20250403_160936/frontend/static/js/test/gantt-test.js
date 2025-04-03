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
