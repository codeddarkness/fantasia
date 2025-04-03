from flask import render_template

# Add this to your Flask routes in backend/app.py:
@app.route('/test/gantt')
def test_gantt():
    return render_template('test/gantt.html')
