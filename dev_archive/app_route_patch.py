# Add this to the backend/app.py file before the if __name__ == "__main__" line:

@app.route('/test/gantt')
def test_gantt():
    return render_template('test/gantt.html')
