# For MIS Project

# SynergyFlow - Project Management System

A comprehensive project management system built with Flask, SQLite, and Bootstrap. This system helps organizations manage their projects, tasks, and employees efficiently.

## Features

### 1. Project Management
- Create, view, edit, and delete projects
- Track project status (Not Started, In Progress, Completed)
- Set project start and end dates
- Add project descriptions
- Automatic date validation to ensure end dates are not earlier than start dates

### 2. Task Management
- Create and assign tasks to projects
- Assign tasks to specific employees
- Track task status and progress
- Set task deadlines with date validation
- Link tasks to specific projects

### 3. Employee Management
- Maintain employee records
- Assign employees to departments
- Track employee contact information
- Manage employee assignments to tasks

### 4. Advanced Reporting
- Project Statistics Report
  - View number of tasks per project
  - Track project status
  - Monitor project progress
- Employee Task Assignments Report
  - View all tasks assigned to each employee
  - Track employee workload
  - Monitor task status by employee

### 5. Search and Filter
- Search functionality for projects, tasks, and employees
- Real-time filtering of table data
- Easy access to specific records

## Technical Details

### Backend
- **Framework:** Flask (Python)
- **Database:** SQLite
- **Features:**
  - RESTful routing
  - Database migrations
  - Form validation
  - Date validation
  - Flash messages for user feedback

### Frontend
- **Framework:** Bootstrap 5
- **Features:**
  - Responsive design
  - Interactive tables
  - Form validation
  - Date picker controls
  - Search functionality
  - Modal confirmations
  - Dynamic navigation

### Database Schema
- Projects table
- Tasks table
- Employees table
- Departments table
- Various relationship tables

## Installation

1. Clone the repository
2. Install dependencies:
```bash
pip install -r requirements.txt
```
3. Initialize the database:
```bash
python app.py
```

## Usage

1. **Projects:**
   - Navigate to the Projects section
   - Create new projects with start/end dates
   - Assign tasks to projects
   - Track project progress

2. **Tasks:**
   - Create tasks within projects
   - Assign tasks to employees
   - Set task deadlines
   - Update task status

3. **Employees:**
   - Manage employee information
   - Track employee assignments
   - View employee workload

4. **Reports:**
   - Access the Reports dropdown menu
   - View project statistics
   - Monitor employee assignments

## Project Structure
```
MisProject/
├── app.py              # Main application file
├── schema.sql          # Database schema
├── static/
│   ├── css/
│   │   └── style.css  # Custom styles
│   └── js/
│       └── main.js    # JavaScript functions
├── templates/
│   ├── layout.html    # Base template
│   ├── index.html     # Homepage
│   ├── projects/      # Project templates
│   ├── tasks/         # Task templates
│   ├── employees/     # Employee templates
│   └── reports/       # Report templates
└── project.db         # SQLite database
```

## Features to be Added
- User authentication and authorization
- File attachment capabilities
- Email notifications
- Project timeline visualization
- Resource management
- Budget tracking


## License
This project is created for educational purposes as part of the Management Information Systems course.