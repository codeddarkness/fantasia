# Patch  – Smart Port Handling

### 🧠 Summary
- Adds port availability check to `app.py`
- Automatically identifies the PID using port 5000
- Prompts the user to kill or select an alternate port
- Prevents Flask from crashing if the port is already bound

### 📁 Files Modified
- `backend/app.py`

### 📅 Date
2025-04-02

### ✅ How to Apply
```bash
python3 apply_patch.py
# Enter: 
```

### 🔁 Related Version
- Updated `version.json` to ``
