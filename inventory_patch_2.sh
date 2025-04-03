#!/bin/bash

cat << 'ENHANCE_WARDROBE_PART2' > enhance_wardrobe_part2.sh
#!/bin/bash
set -e

# Continue updating the HTML template
cat << 'EOF' >> frontend/templates/test/gantt.html
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-collaborate">
            <label for="check-collaborate">Collaborate with costume designers and actors</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-trends">
            <label for="check-trends">Stay updated on current fashion trends</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-expand">
            <label for="check-expand">Continuously expand and diversify</label>
          </div>
        </div>
      </div>
      
      <div class="checklist-tips">
        <h4>Checklist Tips</h4>
        <ul>
          <li>Thoroughly inspect each item before adding it to inventory - look for damage, stains, or missing parts.</li>
          <li>Keep the inventory updated regularly as costumes are used, cleaned, or repaired.</li>
          <li>Record specific measurements rather than just general sizes for more precise fitting.</li>
          <li>Take photos of each item for easier identification and reference.</li>
          <li>Use consistent naming conventions for all inventory items.</li>
        </ul>
      </div>
    </div>
  </div>
  
  <div id="debug" class="content">
    <h2>Debug Data</h2>
    <pre id="debug-data" style="background:#f5f5f5; padding:10px; overflow:auto; max-height:500px;"></pre>
  </div>
  
  <script src="/static/js/test/gantt.js"></script>
</body>
</html>
EOF

# Create the enhanced JavaScript file
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
  document.getElementById('inventory-search').addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    const cards = document.querySelectorAll('.wardrobe-card');
    
    cards.forEach(card => {
      const text = card.textContent.toLowerCase();
      card.style.display = text.includes(searchTerm) ? '' : 'none';
    });
  });
  
  // Setup task filter
  if (document.getElementById('task-filter')) {
    document.getElementById('task-filter').addEventListener('change', function() {
      const status = this.value;
      const cards = document.querySelectorAll('.task-card');
      
      cards.forEach(card => {
        if (status === 'all' || card.getAttribute('data-status') === status) {
          card.style.display = '';
        } else {
          card.style.display = 'none';
        }
      });
    });
  }
  
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
      renderWardrobe(data.wardrobe_items, data.categories);
      renderTasks(data.tasks);
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
  if (!container) return;
  
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
    
    let itemHtml = `
      <strong>${timeStr}</strong> - 
      <strong>${entry.actor}</strong> - 
      ${entry.item} with 
      <em>${entry.dresser}</em> 
      (${entry.duration_minutes} min)
    `;
    
    if (entry.notes) {
      itemHtml += `<div class="notes">Note: ${entry.notes}</div>`;
    }
    
    item.innerHTML = itemHtml;
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
  if (!container) return;
  
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
      
      if (entry.notes) {
        event.title += ` - Note: ${entry.notes}`;
      }
      
      timeline.appendChild(event);
    });
    
    section.appendChild(timeline);
    container.appendChild(section);
  });
}

// Render enhanced wardrobe inventory
function renderWardrobe(items, categories) {
  const container = document.getElementById('wardrobe-grid');
  if (!container) return;
  
  container.innerHTML = '';
  
  if (!items || items.length === 0) {
    container.innerHTML = '<p>No wardrobe items found.</p>';
    return;
  }
  
  // Populate category filter
  const categoryFilter = document.getElementById('category-filter');
  if (categoryFilter) {
    categoryFilter.innerHTML = `<div class="category-tag active" data-category="all">All Items</div>`;
    
    // Get unique categories from items
    const uniqueCategories = [...new Set(items.map(item => item.category))];
    
    // Add category tags
    uniqueCategories.forEach(category => {
      if (category) {
        const tag = document.createElement('div');
        tag.className = 'category-tag';
        tag.setAttribute('data-category', category.toLowerCase());
        tag.textContent = category;
        tag.addEventListener('click', function() {
          // Toggle active class
          document.querySelectorAll('.category-tag').forEach(t => t.classList.remove('active'));
          this.classList.add('active');
          
          // Filter items
          const selectedCategory = this.getAttribute('data-category');
          const cards = document.querySelectorAll('.wardrobe-card');
          
          cards.forEach(card => {
            if (selectedCategory === 'all' || card.getAttribute('data-category').toLowerCase() === selectedCategory) {
              card.style.display = '';
            } else {
              card.style.display = 'none';
            }
          });
        });
        
        categoryFilter.appendChild(tag);
      }
    });
  }
  
  // Create wardrobe cards
  items.forEach(item => {
    const card = document.createElement('div');
    card.className = 'wardrobe-card';
    card.setAttribute('data-category', (item.category || '').toLowerCase());
    
    let statusClass = 'status-available';
    if (item.status) {
      statusClass = 'status-' + item.status.toLowerCase().replace(/\s+/g, '-');
    }
    
    card.innerHTML = `
      <h3>${item.name} (${item.id})</h3>
      <div class="wardrobe-card-content">
        <div>
          <span class="wardrobe-card-label">Size:</span>
          <span class="wardrobe-card-value">${item.size || 'N/A'}</span>
        </div>
        <div>
          <span class="wardrobe-card-label">Status:</span>
          <span class="wardrobe-card-value ${statusClass}">${item.status || 'Available'}</span>
        </div>
        <div>
          <span class="wardrobe-card-label">Category:</span>
          <span class="wardrobe-card-value">${item.category || 'Uncategorized'}</span>
        </div>
        <div>
          <span class="wardrobe-card-label">Location:</span>
          <span class="wardrobe-card-value">${item.location || 'Unknown'}</span>
        </div>
        <div>
          <span class="wardrobe-card-label">Condition:</span>
          <span class="wardrobe-card-value">${item.condition || 'Unknown'}</span>
        </div>
        ${item.notes ? `<div class="wardrobe-card-notes">${item.notes}</div>` : ''}
      </div>
    `;
    
    container.appendChild(card);
  });
}

// Render tasks
function renderTasks(tasks) {
  const container = document.getElementById('task-list');
  if (!container) return;
  
  container.innerHTML = '';
  
  if (!tasks || tasks.length === 0) {
    container.innerHTML = '<p>No tasks found.</p>';
    return;
  }
  
  // Create task cards
  tasks.forEach(task => {
    const status = (task.status || 'Not Started').toLowerCase().replace(/\s+/g, '-');
    const priority = (task.priority || 'Medium').toLowerCase();
    
    const card = document.createElement('div');
    card.className = 'task-card';
    card.setAttribute('data-status', status);
    
    const deadline = new Date(task.deadline);
    const formattedDeadline = deadline.toLocaleDateString() + ' ' + 
                             deadline.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    
    card.innerHTML = `
      <div class="task-header">
        <h3 class="task-title">${task.name}</h3>
        <span class="task-status ${status}">${task.status || 'Not Started'}</span>
      </div>
      <div class="task-details">
        <div class="task-assignee">Assigned to: ${task.assigned_to}</div>
        <div class="task-deadline">Deadline: ${formattedDeadline}</div>
        <div class="task-priority ${priority}">Priority: ${task.priority || 'Medium'}</div>
      </div>
    `;
    
    container.appendChild(card);
  });
}

// Render debug data
function renderDebugData(data) {
  const container = document.getElementById('debug-data');
  if (!container) return;
  
  container.textContent = JSON.stringify(data, null, 2);
}

// Populate form dropdowns
function populateFormDropdowns(data) {
  // Actor dropdown
  const actorSelect = document.getElementById('actor-select');
  if (!actorSelect) return;
  
  actorSelect.innerHTML = '';
  data.agents.actors.forEach(actor => {
    const option = document.createElement('option');
    option.value = actor;
    option.textContent = actor;
    actorSelect.appendChild(option);
  });
  
  // Dresser dropdown
  const dresserSelect = document.getElementById('dresser-select');
  if (dresserSelect) {
    dresserSelect.innerHTML = '';
    data.agents.dressers.forEach(dresser => {
      const option = document.createElement('option');
      option.value = dresser;
      option.textContent = dresser;
      dresserSelect.appendChild(option);
    });
  }
  
  // Item dropdown
  const itemSelect = document.getElementById('item-select');
  if (itemSelect) {
    itemSelect.innerHTML = '';
    data.wardrobe_items.forEach(item => {
      const option = document.createElement('option');
      option.value = item.id;
      option.textContent = `${item.name} (${item.id})`;
      itemSelect.appendChild(option);
    });
  }
  
  // Set default date/time
  const timeInput = document.getElementById('time-input');
  if (timeInput) {
    const now = new Date();
    now.setMinutes(Math.ceil(now.getMinutes() / 5) * 5); // Round to next 5 minutes
    timeInput.value = now.toISOString().slice(0, 16);
  }
}

// Add a new schedule entry
function addNewEntry() {
  const actor = document.getElementById('actor-select').value;
  const dresser = document.getElementById('dresser-select').value;
  const item = document.getElementById('item-select').value;
  const time = document.getElementById('time-input').value;
  const duration = parseInt(document.getElementById('duration-input').value);
  const notes = document.getElementById('notes-input').value;
  const status = document.getElementById('form-status');
  
  if (!actor || !dresser || !item || !time || isNaN(duration)) {
    status.textContent = 'Please fill all required fields correctly.';
    status.style.color = 'red';
    return;
  }
  
  // Create new entry
  const newEntry = {
    actor: actor,
    dresser: dresser,
    item: item,
    time: time + ':00', // Add seconds
    duration_minutes: duration,
    notes: notes
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
    document.getElementById('notes-input').value = '';
    
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

// Initialize checklist state
document.addEventListener('DOMContentLoaded', function() {
  // Load saved checklist state from localStorage if available
  const checkboxes = document.querySelectorAll('.checklist-item input[type="checkbox"]');
  checkboxes.forEach(checkbox => {
    const savedState = localStorage.getItem('costume_checklist_' + checkbox.id);
    if (savedState === 'true') {
      checkbox.checked = true;
    }
    
    // Save state when changed
    checkbox.addEventListener('change', function() {
      localStorage.setItem('costume_checklist_' + this.id, this.checked);
    });
  });
});
EOF

# Apply the new data
cp data/enhanced_wardrobe_data.json data/data.json

echo "✅ Added enhanced wardrobe inventory with categories and checklist"
echo "🔹 Restart your Flask server with: python3 backend/app.py"
echo "🔹 Then visit: http://127.0.0.1:5000/test/gantt"
ENHANCE_WARDROBE_PART2

chmod +x enhance_wardrobe_part2.sh
echo "✅ Created second part of enhance wardrobe script. Run it with: ./enhance_wardrobe_part2.sh"
