#!/bin/bash

cat << 'EXTENDED_OVERLAP_DATA_SCRIPT' > add_extended_overlap_data.sh
#!/bin/bash
set -e

echo "🔧 Adding extended overlapping data with longer durations..."

# Create new test data with extensive overlapping schedules
cat << 'EOF' > data/extended_overlap_data.json
{
  "version": "v0.3.5",
  "agents": {
    "actors": ["Alice", "Bob", "Charlie", "David", "Emily", "Frank", "Grace", "Henry", "Isabella", "Jack"],
    "dressers": ["Dana", "Eli", "Fiona"],
    "managers": ["Morgan", "Nina"]
  },
  "wardrobe_items": [
    { "id": "hat001", "name": "Top Hat", "size": "M", "status": "Available", "category": "Accessories" },
    { "id": "dress001", "name": "Red Evening Gown", "size": "S", "status": "In Use", "category": "Dresses" },
    { "id": "coat001", "name": "Trench Coat", "size": "L", "status": "Available", "category": "Outerwear" },
    { "id": "cape001", "name": "Velvet Cape", "size": "M", "status": "Cleaning", "category": "Outerwear" },
    { "id": "boots001", "name": "Leather Boots", "size": "42", "status": "Available", "category": "Footwear" },
    { "id": "hat002", "name": "Bowler Hat", "size": "S", "status": "Available", "category": "Accessories" },
    { "id": "dress002", "name": "Blue Cocktail Dress", "size": "M", "status": "Available", "category": "Dresses" },
    { "id": "suit001", "name": "Tuxedo", "size": "L", "status": "Available", "category": "Formal Wear" },
    { "id": "suit002", "name": "Victorian Suit", "size": "M", "status": "Available", "category": "Formal Wear" },
    { "id": "gloves001", "name": "White Gloves", "size": "S", "status": "Available", "category": "Accessories" },
    { "id": "costume001", "name": "Fairy Costume", "size": "S", "status": "Available", "category": "Costumes" },
    { "id": "costume002", "name": "Wizard Robe", "size": "L", "status": "Available", "category": "Costumes" },
    { "id": "costume003", "name": "Knight Armor", "size": "M", "status": "Available", "category": "Costumes" },
    { "id": "costume004", "name": "Princess Gown", "size": "S", "status": "Available", "category": "Costumes" },
    { "id": "costume005", "name": "Space Suit", "size": "L", "status": "Available", "category": "Costumes" }
  ],
  "schedules": [
    {
      "actor": "Alice",
      "dresser": "Dana",
      "item": "dress001",
      "time": "2025-04-03T18:00:00",
      "duration_minutes": 25,
      "notes": "Full costume change with accessories"
    },
    {
      "actor": "Bob",
      "dresser": "Dana",
      "item": "suit001",
      "time": "2025-04-03T18:15:00",
      "duration_minutes": 20,
      "notes": "Formal wear with multiple pieces"
    },
    {
      "actor": "Charlie",
      "dresser": "Dana",
      "item": "coat001",
      "time": "2025-04-03T18:10:00",
      "duration_minutes": 15,
      "notes": "Quick change between scenes"
    },
    {
      "actor": "Isabella",
      "dresser": "Dana",
      "item": "costume004",
      "time": "2025-04-03T18:30:00",
      "duration_minutes": 30,
      "notes": "Complex costume with multiple layers"
    },
    {
      "actor": "David",
      "dresser": "Eli",
      "item": "suit002",
      "time": "2025-04-03T19:00:00",
      "duration_minutes": 25,
      "notes": "Period costume with many pieces"
    },
    {
      "actor": "Emily",
      "dresser": "Eli",
      "item": "costume001",
      "time": "2025-04-03T19:10:00",
      "duration_minutes": 35,
      "notes": "Fairy costume with wings and accessories"
    },
    {
      "actor": "Frank",
      "dresser": "Eli",
      "item": "costume002",
      "time": "2025-04-03T19:05:00",
      "duration_minutes": 20,
      "notes": "Wizard costume with hat and props"
    },
    {
      "actor": "Alice",
      "dresser": "Fiona",
      "item": "dress002",
      "time": "2025-04-03T19:45:00",
      "duration_minutes": 25,
      "notes": "Quick change from red to blue gown"
    },
    {
      "actor": "Grace",
      "dresser": "Fiona",
      "item": "costume003",
      "time": "2025-04-03T19:50:00",
      "duration_minutes": 40,
      "notes": "Heavy armor costume requiring assistance"
    },
    {
      "actor": "Henry",
      "dresser": "Fiona",
      "item": "costume005",
      "time": "2025-04-03T19:30:00",
      "duration_minutes": 35,
      "notes": "Space suit with helmet and accessories"
    },
    {
      "actor": "Jack",
      "dresser": "Dana",
      "item": "hat001",
      "time": "2025-04-03T20:00:00",
      "duration_minutes": 10,
      "notes": "Hat and gloves only"
    },
    {
      "actor": "Charlie",
      "dresser": "Eli",
      "item": "boots001",
      "time": "2025-04-03T20:10:00",
      "duration_minutes": 15,
      "notes": "Footwear change only"
    },
    {
      "actor": "David",
      "dresser": "Fiona",
      "item": "cape001",
      "time": "2025-04-03T20:15:00",
      "duration_minutes": 20,
      "notes": "Add cape to existing costume"
    },
    {
      "actor": "Alice",
      "dresser": "Dana",
      "item": "hat002",
      "time": "2025-04-03T20:30:00",
      "duration_minutes": 15,
      "notes": "Final costume adjustment"
    },
    {
      "actor": "Emily",
      "dresser": "Dana",
      "item": "gloves001",
      "time": "2025-04-03T20:35:00",
      "duration_minutes": 10,
      "notes": "Add gloves to costume"
    }
  ],
  "tasks": [
    {
      "name": "Steam Red Evening Gown",
      "assigned_to": "Eli",
      "deadline": "2025-04-03T17:45:00",
      "status": "Completed",
      "priority": "High"
    },
    {
      "name": "Repair Trench Coat Button",
      "assigned_to": "Dana",
      "deadline": "2025-04-03T18:10:00",
      "status": "In Progress",
      "priority": "Medium"
    },
    {
      "name": "Clean Velvet Cape",
      "assigned_to": "Fiona",
      "deadline": "2025-04-03T18:50:00",
      "status": "Pending",
      "priority": "Low"
    },
    {
      "name": "Polish Leather Boots",
      "assigned_to": "Morgan",
      "deadline": "2025-04-03T19:30:00",
      "status": "Not Started",
      "priority": "Medium"
    },
    {
      "name": "Repair Fairy Wings",
      "assigned_to": "Nina",
      "deadline": "2025-04-03T19:00:00",
      "status": "In Progress",
      "priority": "High"
    },
    {
      "name": "Inventory Space Suit Accessories",
      "assigned_to": "Morgan",
      "deadline": "2025-04-03T17:30:00",
      "status": "Completed",
      "priority": "Low"
    },
    {
      "name": "Adjust Knight Armor Sizing",
      "assigned_to": "Eli",
      "deadline": "2025-04-03T19:15:00",
      "status": "Pending",
      "priority": "Medium"
    }
  ]
}
EOF

# Update the HTML file to better handle longer durations
cat << 'EOF' > frontend/templates/test/extended_overlap.html
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler - Extended Overlap View</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
    h1, h2 { color: #333; }
    
    /* Controls */
    .controls { margin-bottom: 20px; padding: 10px; background: #f5f5f5; border-radius: 4px; }
    #date-selector { padding: 8px; margin-right: 10px; }
    #refresh-btn { padding: 8px 16px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
    
    /* Dresser sections */
    .dresser-section { 
      margin-bottom: 30px; 
      border: 1px solid #ddd; 
      border-radius: 4px; 
      overflow: hidden;
    }
    
    .dresser-header { 
      background: #f5f5f5; 
      padding: 10px; 
      font-weight: bold; 
      border-bottom: 1px solid #ddd;
    }
    
    /* Timeline */
    .timeline-container {
      position: relative;
      height: 120px;
      padding: 10px 0;
      margin-top: 20px;
      overflow-x: auto;
    }
    
    .hour-markers {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 20px;
      display: flex;
    }
    
    .hour-marker {
      position: relative;
      width: 60px;
      flex-grow: 1;
      text-align: center;
      font-size: 12px;
      color: #666;
    }
    
    .hour-marker:after {
      content: '';
      position: absolute;
      top: 20px;
      left: 0;
      height: 100px;
      width: 1px;
      background: #eee;
    }
    
    .timeline-event {
      position: absolute;
      top: 30px;
      height: 40px;
      background: #4CAF50;
      color: white;
      border-radius: 4px;
      font-size: 12px;
      padding: 5px;
      box-sizing: border-box;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      z-index: 1;
    }
    
    .timeline-event.overlap {
      background: #f44336;
    }
    
    /* Detail view */
    .detail-section {
      padding: 15px;
    }
    
    .schedule-item {
      background: #f9f9f9;
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 10px;
      margin-bottom: 10px;
      display: flex;
      justify-content: space-between;
    }
    
    .schedule-item.overlap {
      border-left: 4px solid #f44336;
    }
    
    .schedule-time {
      font-weight: bold;
      margin-right: 10px;
    }
    
    .schedule-actor {
      flex: 1;
    }
    
    .schedule-duration {
      color: #666;
    }
    
    .schedule-notes {
      grid-column: span 3;
      font-style: italic;
      margin-top: 5px;
      color: #666;
    }
    
    /* Legend */
    .legend {
      display: flex;
      gap: 20px;
      margin-bottom: 20px;
      padding: 10px;
      background: #f9f9f9;
      border-radius: 4px;
    }
    
    .legend-item {
      display: flex;
      align-items: center;
    }
    
    .legend-color {
      width: 20px;
      height: 20px;
      margin-right: 5px;
      border-radius: 4px;
    }
    
    .normal { background: #4CAF50; }
    .conflict { background: #f44336; }
  </style>
</head>
<body>
  <h1>Extended Costume Change Schedule</h1>
  
  <div class="controls">
    <label for="date-selector">Select date:</label>
    <input type="date" id="date-selector">
    <button id="refresh-btn">Refresh</button>
  </div>
  
  <div class="legend">
    <div class="legend-item">
      <div class="legend-color normal"></div>
      <span>Normal Schedule</span>
    </div>
    <div class="legend-item">
      <div class="legend-color conflict"></div>
      <span>Scheduling Conflict</span>
    </div>
  </div>
  
  <div id="schedule-container">
    <!-- Schedule content will be added here -->
  </div>
  
  <script>
    // Global data
    let scheduleData = null;
    
    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
      // Set date to today
      const dateSelector = document.getElementById('date-selector');
      const today = new Date().toISOString().split('T')[0];
      dateSelector.value = today;
      
      // Set up refresh button
      document.getElementById('refresh-btn').addEventListener('click', function() {
        fetchData();
      });
      
      // Initial fetch
      fetchData();
    });
    
    // Fetch data from API
    function fetchData() {
      const date = document.getElementById('date-selector').value;
      
      fetch('/api/data')
        .then(response => response.json())
        .then(data => {
          scheduleData = data;
          renderSchedule(data, date);
        })
        .catch(error => {
          console.error('Error fetching data:', error);
        });
    }
    
    // Check for overlap between two time ranges
    function checkOverlap(start1, duration1, start2, duration2) {
      const s1 = new Date(start1).getTime();
      const e1 = s1 + (duration1 * 60 * 1000);
      const s2 = new Date(start2).getTime();
      const e2 = s2 + (duration2 * 60 * 1000);
      
      return (s1 < e2 && s2 < e1);
    }
    
    // Render schedule
    function renderSchedule(data, date) {
      const container = document.getElementById('schedule-container');
      container.innerHTML = '';
      
      const schedules = data.schedules || [];
      const filtered = schedules.filter(entry => entry.time.startsWith(date));
      
      if (filtered.length === 0) {
        container.innerHTML = '<p>No schedule entries found for the selected date.</p>';
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
      
      // Process each dresser's schedule
      Object.keys(dressers).forEach(dresserName => {
        const dresserEntries = dressers[dresserName];
        
        // Mark overlapping entries
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
        
        // Create section
        const section = document.createElement('div');
        section.className = 'dresser-section';
        
        // Add header
        const header = document.createElement('div');
        header.className = 'dresser-header';
        header.textContent = `Dresser: ${dresserName}`;
        section.appendChild(header);
        
        // Create timeline
        const timelineContainer = document.createElement('div');
        timelineContainer.className = 'timeline-container';
        
        // Add hour markers (5pm to 9pm)
        const hourMarkers = document.createElement('div');
        hourMarkers.className = 'hour-markers';
        
        for (let hour = 17; hour <= 21; hour++) {
          const marker = document.createElement('div');
          marker.className = 'hour-marker';
          marker.textContent = `${hour}:00`;
          hourMarkers.appendChild(marker);
        }
        
        timelineContainer.appendChild(hourMarkers);
        
        // Calculate timeline dimensions
        const startTime = new Date(`${date}T17:00:00`);
        const endTime = new Date(`${date}T21:00:00`);
        const timelineWidth = timelineContainer.clientWidth;
        const timelineDuration = endTime - startTime;
        const pixelsPerMillisecond = timelineWidth / timelineDuration;
        
        // Add events to timeline
        dresserEntries.forEach(entry => {
          const entryTime = new Date(entry.time);
          const left = (entryTime - startTime) * pixelsPerMillisecond;
          const width = entry.duration_minutes * 60 * 1000 * pixelsPerMillisecond;
          
          const event = document.createElement('div');
          event.className = 'timeline-event' + (entry.hasOverlap ? ' overlap' : '');
          event.style.left = `${left}px`;
          event.style.width = `${width}px`;
          event.textContent = `${entry.actor} - ${entry.item}`;
          event.title = `${entry.actor} - ${entry.item} (${entry.duration_minutes} min)`;
          
          if (entry.notes) {
            event.title += ` - ${entry.notes}`;
          }
          
          timelineContainer.appendChild(event);
        });
        
        section.appendChild(timelineContainer);
        
        // Create detail section
        const detailSection = document.createElement('div');
        detailSection.className = 'detail-section';
        
        // Sort entries by time
        dresserEntries.sort((a, b) => new Date(a.time) - new Date(b.time));
        
        // Add detail items
        dresserEntries.forEach(entry => {
          const time = new Date(entry.time);
          const formattedTime = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
          
          const item = document.createElement('div');
          item.className = 'schedule-item' + (entry.hasOverlap ? ' overlap' : '');
          
          // Create item content
          item.innerHTML = `
            <div class="schedule-time">${formattedTime}</div>
            <div class="schedule-actor">${entry.actor} - ${entry.item}</div>
            <div class="schedule-duration">${entry.duration_minutes} min</div>
          `;
          
          if (entry.notes) {
            const notes = document.createElement('div');
            notes.className = 'schedule-notes';
            notes.textContent = entry.notes;
            item.appendChild(notes);
          }
          
          detailSection.appendChild(item);
        });
        
        section.appendChild(detailSection);
        container.appendChild(section);
      });
    }
  </script>
</body>
</html>
EOF

# Create a route for the extended overlap view
cat << 'EOF' > add_extended_route.py
#!/usr/bin/env python3
import os

def add_route_to_app():
    app_file = "backend/app.py"
    
    # Read the current content
    with open(app_file, "r") as f:
        content = f.read()
    
    # Check if the route already exists
    if "@app.route('/test/extended')" in content:
        print("✅ Extended overlap route already exists")
        return
    
    # Find the position to insert - before if __name__ 
    new_route = """
@app.route('/test/extended')
def test_extended():
    return render_template('test/extended_overlap.html')
"""
    
    # Insert the route
    if "if __name__ == \"__main__\"" in content:
        content = content.replace("if __name__ == \"__main__\"", new_route + "\nif __name__ == \"__main__\"")
        
        # Write back to the file
        with open(app_file, "w") as f:
            f.write(content)
        
        print("✅ Added extended overlap route to app.py")
    else:
        print("❌ Could not find the right position to insert the route")
        print("Please manually add the following to your app.py file:")
        print(new_route)

if __name__ == "__main__":
    add_route_to_app()
EOF

# Make the Python script executable
chmod +x add_extended_route.py

# Apply the new data
cp data/extended_overlap_data.json data/data.json

# Add the route to app.py
python3 add_extended_route.py

echo "✅ Added extended overlapping data with longer durations"
echo "🔹 Restart your Flask server with: python3 backend/app.py"
echo "🔹 Then visit: http://127.0.0.1:5000/test/extended"
EXTENDED_OVERLAP_DATA_SCRIPT

chmod +x add_extended_overlap_data.sh
echo "✅ Created script to add extended overlapping data. Run it with: ./add_extended_overlap_data.sh"
