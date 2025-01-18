from flask import Flask, render_template, request, jsonify, redirect, url_for, flash
import sqlite3
from datetime import datetime
import os

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'  # Required for flash messages

DATABASE = 'project.db'

def get_db():
    db = sqlite3.connect(DATABASE)
    db.row_factory = sqlite3.Row
    return db

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r', encoding='utf-8') as f:
            db.cursor().executescript(f.read())
        db.commit()

def validate_dates(start_date, end_date):
    if not start_date or not end_date:
        return True
    try:
        start = datetime.strptime(start_date, '%Y-%m-%d')
        end = datetime.strptime(end_date, '%Y-%m-%d')
        return end >= start
    except ValueError:
        return False

@app.route('/')
def index():
    return render_template('index.html')

# Projects CRUD
@app.route('/projects')
def projects():
    db = get_db()
    projects = db.execute('SELECT * FROM Projects').fetchall()
    return render_template('projects/list.html', projects=projects)

@app.route('/projects/new', methods=['GET', 'POST'])
def project_new():
    if request.method == 'POST':
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        
        if not validate_dates(start_date, end_date):
            flash('End date cannot be earlier than start date', 'error')
            return render_template('projects/form.html')
            
        db = get_db()
        db.execute('''INSERT INTO Projects (ProjectName, StartDate, EndDate, Description, Status)
                     VALUES (?, ?, ?, ?, ?)''',
                  [request.form['name'], request.form['start_date'],
                   request.form['end_date'], request.form['description'],
                   request.form['status']])
        db.commit()
        flash('Project created successfully!')
        return redirect(url_for('projects'))
    return render_template('projects/form.html')

@app.route('/projects/edit/<int:id>', methods=['GET', 'POST'])
def project_edit(id):
    db = get_db()
    if request.method == 'POST':
        db.execute('''UPDATE Projects SET ProjectName=?, StartDate=?, EndDate=?,
                     Description=?, Status=? WHERE ProjectID=?''',
                  [request.form['name'], request.form['start_date'],
                   request.form['end_date'], request.form['description'],
                   request.form['status'], id])
        db.commit()
        flash('Project updated successfully!')
        return redirect(url_for('projects'))
    project = db.execute('SELECT * FROM Projects WHERE ProjectID = ?', [id]).fetchone()
    return render_template('projects/form.html', project=project)

@app.route('/projects/delete/<int:id>')
def project_delete(id):
    db = get_db()
    db.execute('DELETE FROM Projects WHERE ProjectID = ?', [id])
    db.commit()
    flash('Project deleted successfully!')
    return redirect(url_for('projects'))

# Employees CRUD
@app.route('/employees')
def employees():    
    db = get_db()
    employees = db.execute('''
        SELECT e.*, d.DepartmentName 
        FROM Employees e 
        LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
    ''').fetchall()
    return render_template('employees/list.html', employees=employees)

@app.route('/employees/new', methods=['GET', 'POST'])
def employee_new():
    if request.method == 'POST':
        db = get_db()
        db.execute('''INSERT INTO Employees 
                     (FirstName, LastName, Email, Phone, HireDate, DepartmentID)
                     VALUES (?, ?, ?, ?, ?, ?)''',
                  [request.form['first_name'], request.form['last_name'],
                   request.form['email'], request.form['phone'],
                   request.form['hire_date'], request.form['department_id']])
        db.commit()
        flash('Employee created successfully!')
        return redirect(url_for('employees'))
    
    db = get_db()
    departments = db.execute('SELECT * FROM Departments').fetchall()
    return render_template('employees/form.html', departments=departments)

@app.route('/employees/edit/<int:id>', methods=['GET', 'POST'])
def employee_edit(id):
    db = get_db()
    if request.method == 'POST':
        db.execute('''UPDATE Employees 
                     SET FirstName=?, LastName=?, Email=?, Phone=?, 
                     HireDate=?, DepartmentID=? 
                     WHERE EmployeeID=?''',
                  [request.form['first_name'], request.form['last_name'],
                   request.form['email'], request.form['phone'],
                   request.form['hire_date'], request.form['department_id'], id])
        db.commit()
        flash('Employee updated successfully!')
        return redirect(url_for('employees'))
    
    employee = db.execute('SELECT * FROM Employees WHERE EmployeeID = ?', [id]).fetchone()
    departments = db.execute('SELECT * FROM Departments').fetchall()
    return render_template('employees/form.html', employee=employee, departments=departments)

@app.route('/employees/delete/<int:id>')
def employee_delete(id):
    db = get_db()
    db.execute('DELETE FROM Employees WHERE EmployeeID = ?', [id])
    db.commit()
    flash('Employee deleted successfully!')
    return redirect(url_for('employees'))

# Tasks CRUD
@app.route('/tasks')
def tasks():
    db = get_db()
    tasks = db.execute('''
        SELECT t.*, p.ProjectName, e.FirstName, e.LastName 
        FROM Tasks t
        LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
        LEFT JOIN Employees e ON t.AssignedEmployeeID = e.EmployeeID
    ''').fetchall()
    return render_template('tasks/list.html', tasks=tasks)

@app.route('/tasks/new', methods=['GET', 'POST'])
def task_new():
    if request.method == 'POST':
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        
        if not validate_dates(start_date, end_date):
            flash('End date cannot be earlier than start date', 'error')
            return render_template('tasks/form.html', 
                                projects=get_db().execute('SELECT * FROM Projects').fetchall(),
                                employees=get_db().execute('SELECT * FROM Employees').fetchall())
            
        db = get_db()
        db.execute('''INSERT INTO Tasks 
                     (TaskName, Description, StartDate, EndDate, Status, ProjectID, AssignedEmployeeID)
                     VALUES (?, ?, ?, ?, ?, ?, ?)''',
                  [request.form['name'], request.form['description'],
                   request.form['start_date'], request.form['end_date'],
                   request.form['status'], request.form['project_id'],
                   request.form['assigned_to']])
        db.commit()
        flash('Task created successfully!')
        return redirect(url_for('tasks'))
    
    db = get_db()
    projects = db.execute('SELECT * FROM Projects').fetchall()
    employees = db.execute('SELECT * FROM Employees').fetchall()
    return render_template('tasks/form.html', projects=projects, employees=employees)

@app.route('/tasks/edit/<int:id>', methods=['GET', 'POST'])
def task_edit(id):
    db = get_db()
    if request.method == 'POST':
        db.execute('''UPDATE Tasks 
                     SET TaskName=?, Description=?, StartDate=?, EndDate=?, Status=?,
                     ProjectID=?, AssignedEmployeeID=?
                     WHERE TaskID=?''',
                  [request.form['name'], request.form['description'],
                   request.form['start_date'], request.form['end_date'],
                   request.form['status'], request.form['project_id'],
                   request.form['assigned_to'], id])
        db.commit()
        flash('Task updated successfully!')
        return redirect(url_for('tasks'))
    
    task = db.execute('SELECT * FROM Tasks WHERE TaskID = ?', [id]).fetchone()
    projects = db.execute('SELECT * FROM Projects').fetchall()
    employees = db.execute('SELECT * FROM Employees').fetchall()
    return render_template('tasks/form.html', task=task, projects=projects, employees=employees)

@app.route('/tasks/delete/<int:id>')
def task_delete(id):
    db = get_db()
    db.execute('DELETE FROM Tasks WHERE TaskID = ?', [id])
    db.commit()
    flash('Task deleted successfully!')
    return redirect(url_for('tasks'))

# Advanced Queries
@app.route('/project-stats')
def project_stats():
    db = get_db()
    stats = db.execute('''
        SELECT 
            p.ProjectName,
            p.Status,
            COUNT(t.TaskID) as TaskCount
        FROM Projects p
        LEFT JOIN Tasks t ON p.ProjectID = t.ProjectID
        GROUP BY p.ProjectID, p.ProjectName, p.Status
        ORDER BY p.ProjectName
    ''').fetchall()
    return render_template('reports/project_stats.html', stats=stats)

@app.route('/employee-tasks')
def employee_tasks():
    db = get_db()
    assignments = db.execute('''
        SELECT 
            e.FirstName,
            e.LastName,
            t.TaskName,
            p.ProjectName,
            t.Status as TaskStatus,
            t.StartDate,
            t.EndDate
        FROM Employees e
        LEFT JOIN Tasks t ON e.EmployeeID = t.AssignedEmployeeID
        LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
        WHERE t.TaskID IS NOT NULL
        ORDER BY e.LastName, e.FirstName, p.ProjectName
    ''').fetchall()
    return render_template('reports/employee_tasks.html', assignments=assignments)

if __name__ == '__main__':
    init_db()
    app.run(debug=True)
