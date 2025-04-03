cat << 'EOF' > data/scheduler_data_demo.json
{
  "version": "v0.3.0",
  "agents": {
    "actors": ["Alice", "Bob", "Charlie", "Daisy", "Edgar"],
    "dressers": ["Dana", "Eli"],
    "managers": ["Morgan"]
  },
  "wardrobe_items": [
    { "id": "hat001", "name": "Top Hat", "size": "M" },
    { "id": "dress001", "name": "Red Dress", "size": "S" },
    { "id": "coat001", "name": "Trench Coat", "size": "L" },
    { "id": "cape001", "name": "Velvet Cape", "size": "M" },
    { "id": "boots001", "name": "Leather Boots", "size": "L" }
  ],
  "schedules": [
    {
      "actor": "Alice",
      "dresser": "Dana",
      "item": "hat001",
      "time": "2025-04-02T18:00:00",
      "duration_minutes": 10
    },
    {
      "actor": "Bob",
      "dresser": "Eli",
      "item": "dress001",
      "time": "2025-04-02T18:15:00",
      "duration_minutes": 12
    },
    {
      "actor": "Charlie",
      "dresser": "Dana",
      "item": "coat001",
      "time": "2025-04-02T18:30:00",
      "duration_minutes": 8
    },
    {
      "actor": "Daisy",
      "dresser": "Eli",
      "item": "cape001",
      "time": "2025-04-02T19:00:00",
      "duration_minutes": 15
    },
    {
      "actor": "Edgar",
      "dresser": "Dana",
      "item": "boots001",
      "time": "2025-04-02T19:20:00",
      "duration_minutes": 10
    }
  ],
  "tasks": [
    {
      "name": "Steam Red Dress",
      "assigned_to": "Eli",
      "deadline": "2025-04-02T17:45:00"
    },
    {
      "name": "Brush Trench Coat",
      "assigned_to": "Dana",
      "deadline": "2025-04-02T18:10:00"
    },
    {
      "name": "Polish Boots",
      "assigned_to": "Morgan",
      "deadline": "2025-04-02T18:50:00"
    }
  ]
}
EOF

