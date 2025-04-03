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
