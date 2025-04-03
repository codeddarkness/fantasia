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
