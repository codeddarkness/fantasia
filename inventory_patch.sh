#!/bin/bash

cat << 'ENHANCED_WARDROBE_SCRIPT' > enhance_wardrobe.sh
#!/bin/bash
set -e

echo "🔧 Enhancing costume inventory and scheduler..."

# Create new data with detailed inventory categories
cat << 'EOF' > data/enhanced_wardrobe_data.json
{
  "version": "v0.4.0",
  "agents": {
    "actors": ["Alice", "Bob", "Charlie", "David", "Emily", "Frank"],
    "dressers": ["Dana", "Eli", "Fiona"],
    "managers": ["Morgan"]
  },
  "wardrobe_items": [
    { "id": "hat001", "name": "Top Hat", "size": "M", "status": "Available", "category": "Accessories", "location": "Hat Box A", "condition": "Good", "notes": "Black velvet, needs brushing" },
    { "id": "dress001", "name": "Red Evening Gown", "size": "S", "status": "In Use", "category": "Dresses", "location": "Rack 3", "condition": "Excellent", "notes": "Silk, Act 2 opening scene" },
    { "id": "coat001", "name": "Trench Coat", "size": "L", "status": "Available", "category": "Outerwear", "location": "Rack 1", "condition": "Good", "notes": "Beige, missing one button" },
    { "id": "cape001", "name": "Velvet Cape", "size": "M", "status": "Cleaning", "category": "Outerwear", "location": "Cleaning", "condition": "Fair", "notes": "Purple, needs hem repair" },
    { "id": "boots001", "name": "Leather Boots", "size": "42", "status": "Available", "category": "Footwear", "location": "Shoe Rack B", "condition": "Good", "notes": "Brown, needs polishing" },
    { "id": "hat002", "name": "Bowler Hat", "size": "S", "status": "Available", "category": "Accessories", "location": "Hat Box B", "condition": "Excellent", "notes": "Black felt" },
    { "id": "dress002", "name": "Blue Cocktail Dress", "size": "M", "status": "Available", "category": "Dresses", "location": "Rack 3", "condition": "Excellent", "notes": "Sequined, Act 1 finale" },
    { "id": "suit001", "name": "Tuxedo", "size": "L", "status": "Available", "category": "Tops & Bottoms", "location": "Rack 2", "condition": "Excellent", "notes": "Black, with cummerbund" },
    { "id": "suit002", "name": "Victorian Suit", "size": "M", "status": "Available", "category": "Tops & Bottoms", "location": "Rack 2", "condition": "Good", "notes": "Grey, three-piece" },
    { "id": "gloves001", "name": "White Gloves", "size": "S", "status": "Available", "category": "Accessories", "location": "Drawer A", "condition": "Excellent", "notes": "Cotton, formal" },
    { "id": "wig001", "name": "Blonde Wig", "size": "One Size", "status": "Available", "category": "Props", "location": "Wig Stand 1", "condition": "Good", "notes": "Long, wavy" },
    { "id": "mask001", "name": "Venetian Mask", "size": "One Size", "status": "Available", "category": "Props", "location": "Props Box C", "condition": "Excellent", "notes": "Gold with black detail" },
    { "id": "corset001", "name": "Victorian Corset", "size": "S", "status": "Available", "category": "Undergarments", "location": "Drawer B", "condition": "Good", "notes": "White, needs new laces" },
    { "id": "shirt001", "name": "Ruffled Shirt", "size": "M", "status": "Available", "category": "Tops", "location": "Rack 4", "condition": "Excellent", "notes": "White, Victorian style" },
    { "id": "skirt001", "name": "Full Circle Skirt", "size": "M", "status": "In Repair", "category": "Bottoms", "location": "Sewing Room", "condition": "Fair", "notes": "Red, hem needs repair" },
    { "id": "jacket001", "name": "Military Jacket", "size": "L", "status": "Available", "category": "Outerwear", "location": "Rack 1", "condition": "Excellent", "notes": "Blue with gold trim" },
    { "id": "shoes001", "name": "Tap Shoes", "size": "38", "status": "Available", "category": "Footwear", "location": "Shoe Rack A", "condition": "Good", "notes": "Black, need new taps" },
    { "id": "socks001", "name": "Striped Socks", "size": "M", "status": "Available", "category": "Undergarments", "location": "Drawer C", "condition": "Excellent", "notes": "Red and white" }
  ],
  "schedules": [
    {
      "actor": "Alice",
      "dresser": "Dana",
      "item": "dress001",
      "time": "2025-04-03T18:00:00",
      "duration_minutes": 15,
      "notes": "Complete look with blonde wig and mask"
    },
    {
      "actor": "Bob",
      "dresser": "Dana",
      "item": "suit001",
      "time": "2025-04-03T18:10:00",
      "duration_minutes": 12,
      "notes": "Add white gloves and top hat"
    },
    {
      "actor": "Charlie",
      "dresser": "Dana",
      "item": "coat001",
      "time": "2025-04-03T18:05:00",
      "duration_minutes": 8,
      "notes": "Quick change, needs help with boots"
    },
    {
      "actor": "Alice",
      "dresser": "Fiona",
      "item": "dress002",
      "time": "2025-04-03T19:10:00",
      "duration_minutes": 15,
      "notes": "Complete transition from red to blue gown"
    },
    {
      "actor": "David",
      "dresser": "Eli",
      "item": "suit002",
      "time": "2025-04-03T19:20:00",
      "duration_minutes": 10,
      "notes": "Add pocket watch and bowler hat"
    },
    {
      "actor": "Emily",
      "dresser": "Eli",
      "item": "cape001",
      "time": "2025-04-03T19:15:00",
      "duration_minutes": 12,
      "notes": "Be careful with cape clasps"
    },
    {
      "actor": "Frank",
      "dresser": "Fiona",
      "item": "hat001",
      "time": "2025-04-03T19:50:00",
      "duration_minutes": 5,
      "notes": "Quick headwear change only"
    },
    {
      "actor": "Alice",
      "dresser": "Eli",
      "item": "hat002",
      "time": "2025-04-03T18:20:00",
      "duration_minutes": 10,
      "notes": "Add hat after wig is secured"
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
      "name": "Inventory Check - Accessories",
      "assigned_to": "Dana",
      "deadline": "2025-04-03T16:00:00",
      "status": "Completed",
      "priority": "High"
    },
    {
      "name": "Organize Wig Collection",
      "assigned_to": "Fiona",
      "deadline": "2025-04-03T17:30:00",
      "status": "Completed",
      "priority": "Medium"
    }
  ],
  "categories": [
    {"id": "tops", "name": "Tops", "description": "T-shirts, blouses, shirts, sweaters"},
    {"id": "bottoms", "name": "Bottoms", "description": "Pants, skirts, shorts"},
    {"id": "dresses", "name": "Dresses", "description": "Casual, formal, costumes"},
    {"id": "outerwear", "name": "Outerwear", "description": "Jackets, coats, capes"},
    {"id": "footwear", "name": "Footwear", "description": "Shoes, boots, sandals"},
    {"id": "accessories", "name": "Accessories", "description": "Hats, scarves, belts, gloves"},
    {"id": "undergarments", "name": "Undergarments", "description": "Bras, underwear, socks"},
    {"id": "costumes", "name": "Costumes", "description": "Historical, fantasy, modern"},
    {"id": "props", "name": "Props", "description": "Wigs, masks, jewelry"}
  ],
  "locations": [
    {"id": "rack1", "name": "Rack 1", "description": "Main costume rack - Outerwear"},
    {"id": "rack2", "name": "Rack 2", "description": "Main costume rack - Suits and formal wear"},
    {"id": "rack3", "name": "Rack 3", "description": "Main costume rack - Dresses and gowns"},
    {"id": "rack4", "name": "Rack 4", "description": "Secondary rack - Tops and shirts"},
    {"id": "shoe_rack_a", "name": "Shoe Rack A", "description": "Shoe storage - Women's footwear"},
    {"id": "shoe_rack_b", "name": "Shoe Rack B", "description": "Shoe storage - Men's footwear"},
    {"id": "drawer_a", "name": "Drawer A", "description": "Small accessories - Gloves, scarves"},
    {"id": "drawer_b", "name": "Drawer B", "description": "Undergarments - Period pieces"},
    {"id": "drawer_c", "name": "Drawer C", "description": "Undergarments - General"},
    {"id": "hat_box_a", "name": "Hat Box A", "description": "Formal hats and headwear"},
    {"id": "hat_box_b", "name": "Hat Box B", "description": "Casual hats and headwear"},
    {"id": "props_box_c", "name": "Props Box C", "description": "Masks and facial accessories"},
    {"id": "wig_stand_1", "name": "Wig Stand 1", "description": "Wig storage and display"},
    {"id": "cleaning", "name": "Cleaning", "description": "Items currently being cleaned"},
    {"id": "sewing_room", "name": "Sewing Room", "description": "Items being repaired or altered"}
  ]
}
EOF

# Update the test page to include the enhanced wardrobe view
cat << 'EOF' > frontend/templates/test/gantt.html
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler - Wardrobe Management</title>
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
    .tabs { display: flex; flex-wrap: wrap; border-bottom: 1px solid #ccc; margin-bottom: 20px; }
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
    
    .schedule-item .notes {
      font-style: italic;
      margin-top: 5px;
      font-size: 0.9em;
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
    
    /* Wardrobe styles */
    .wardrobe-container {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }
    
    .inventory-panel {
      flex: 1;
      min-width: 300px;
    }
    
    .category-filter {
      display: flex;
      flex-wrap: wrap;
      gap: 5px;
      margin-bottom: 15px;
    }
    
    .category-tag {
      background-color: #f1f1f1;
      padding: 5px 10px;
      border-radius: 15px;
      font-size: 12px;
      cursor: pointer;
      transition: all 0.2s;
    }
    
    .category-tag.active {
      background-color: #4CAF50;
      color: white;
    }
    
    .wardrobe-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 15px;
      margin-top: 20px;
    }
    
    .wardrobe-card {
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 15px;
      background-color: #fff;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    
    .wardrobe-card h3 {
      margin-top: 0;
      margin-bottom: 10px;
      font-size: 16px;
      color: #333;
    }
    
    .wardrobe-card-content {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 8px;
      font-size: 14px;
    }
    
    .wardrobe-card-content div {
      display: flex;
    }
    
    .wardrobe-card-label {
      font-weight: bold;
      margin-right: 5px;
      color: #666;
    }
    
    .wardrobe-card-value {
      flex: 1;
    }
    
    .wardrobe-card-notes {
      grid-column: 1 / span 2;
      margin-top: 10px;
      font-style: italic;
      color: #666;
    }
    
    /* Task styles */
    .task-list {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 15px;
    }
    
    .task-card {
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 15px;
      background-color: #fff;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    
    .task-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }
    
    .task-title {
      font-weight: bold;
      margin: 0;
    }
    
    .task-status {
      font-size: 12px;
      padding: 3px 8px;
      border-radius: 10px;
      color: white;
    }
    
    .task-status.completed { background-color: #4CAF50; }
    .task-status.in-progress { background-color: #2196F3; }
    .task-status.pending { background-color: #FFC107; }
    .task-status.not-started { background-color: #9E9E9E; }
    
    .task-details {
      font-size: 14px;
      color: #666;
    }
    
    .task-details div {
      margin-bottom: 5px;
    }
    
    .task-assignee {
      font-weight: bold;
    }
    
    .task-deadline {
      color: #E91E63;
    }
    
    .task-priority.high { color: #f44336; }
    .task-priority.medium { color: #FF9800; }
    .task-priority.low { color: #4CAF50; }
    
    /* Status indicators */
    .status-available { color: green; }
    .status-in-use { color: blue; }
    .status-cleaning { color: orange; }
    .status-in-repair { color: red; }
    
    /* Search */
    .search-box { 
      width: 100%; 
      padding: 10px; 
      margin-bottom: 15px; 
      font-size: 16px; 
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    
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
    
    /* Checklist section */
    .checklist-container {
      background-color: #f9f9f9;
      padding: 15px;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    
    .checklist-section {
      margin-bottom: 15px;
    }
    
    .checklist-title {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 10px;
      color: #333;
    }
    
    .checklist-items {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 5px;
    }
    
    .checklist-item {
      display: flex;
      align-items: center;
    }
    
    .checklist-item input[type="checkbox"] {
      margin-right: 8px;
    }
    
    .checklist-tips {
      margin-top: 20px;
      padding: 10px;
      background-color: #e8f5e9;
      border-radius: 4px;
    }
    
    .checklist-tips h4 {
      margin-top: 0;
      color: #2e7d32;
    }
    
    .checklist-tips ul {
      margin: 0;
      padding-left: 20px;
    }
    
    .checklist-tips li {
      margin-bottom: 5px;
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
    <div class="tab" data-tab="wardrobe">Inventory</div>
    <div class="tab" data-tab="entry">Add New</div>
    <div class="tab" data-tab="tasks">Tasks</div>
    <div class="tab" data-tab="checklist">Checklist</div>
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
  
  <div id="wardrobe" class="content">
    <h2>Wardrobe Inventory</h2>
    <div class="controls">
      <input type="text" id="inventory-search" class="search-box" placeholder="Search inventory...">
      <div class="category-filter" id="category-filter">
        <!-- Categories will be added here dynamically -->
      </div>
    </div>
    <div class="wardrobe-container">
      <div class="inventory-panel">
        <div class="wardrobe-grid" id="wardrobe-grid">
          <!-- Wardrobe cards will be added here dynamically -->
        </div>
      </div>
    </div>
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
      <div class="form-row">
        <label class="form-label">Notes:</label>
        <textarea id="notes-input" class="form-input" rows="3" placeholder="Add any special instructions or notes..."></textarea>
      </div>
      <button id="add-entry-btn" class="form-button">Add Schedule Entry</button>
      <div id="form-status" style="margin-top: 10px; color: green;"></div>
    </div>
  </div>
  
  <div id="tasks" class="content">
    <h2>Wardrobe Tasks</h2>
    <div class="controls">
      <select id="task-filter" class="form-input">
        <option value="all">All Tasks</option>
        <option value="completed">Completed</option>
        <option value="in-progress">In Progress</option>
        <option value="pending">Pending</option>
        <option value="not-started">Not Started</option>
      </select>
    </div>
    <div class="task-list" id="task-list">
      <!-- Tasks will be added here dynamically -->
    </div>
  </div>
  
  <div id="checklist" class="content">
    <h2>Wardrobe Inventory Checklist</h2>
    <div class="checklist-container">
      <div class="checklist-section">
        <div class="checklist-title">Clothing Categories</div>
        <div class="checklist-items">
          <div class="checklist-item">
            <input type="checkbox" id="check-tops">
            <label for="check-tops">Tops: T-shirts, blouses, shirts, sweaters</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-bottoms">
            <label for="check-bottoms">Bottoms: Pants, skirts, shorts</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-dresses">
            <label for="check-dresses">Dresses: Casual, formal, costumes</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-outerwear">
            <label for="check-outerwear">Outerwear: Jackets, coats, capes</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-footwear">
            <label for="check-footwear">Footwear: Shoes, boots, sandals</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-accessories">
            <label for="check-accessories">Accessories: Hats, scarves, belts, gloves</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-undergarments">
            <label for="check-undergarments">Undergarments: Bras, underwear, socks</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-costumes">
            <label for="check-costumes">Costumes: Historical, fantasy, modern</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-props">
            <label for="check-props">Props: Wigs, masks, jewelry</label>
          </div>
        </div>
      </div>
      
      <div class="checklist-section">
        <div class="checklist-title">Organization Tasks</div>
        <div class="checklist-items">
          <div class="checklist-item">
            <input type="checkbox" id="check-organize">
            <label for="check-organize">Organize by color, style, and size</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-repairs">
            <label for="check-repairs">Keep track of repairs and alterations</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-update">
            <label for="check-update">Regularly update inventory</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-discard">
            <label for="check-discard">Donate or discard unused items</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-clean">
            <label for="check-clean">Maintain cleanliness and orderliness</label>
          </div>
          <div class="checklist-item">
            <input type="checkbox" id="check-ready">
            <label for="check-ready">Ensure wardrobe is ready for each production</label>

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
