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
