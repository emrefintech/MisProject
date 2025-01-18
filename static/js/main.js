// Confirmation modal
function confirmDelete(id, type) {
    if (confirm(`Are you sure you want to delete this ${type}?`)) {
        window.location.href = `/${type}s/delete/${id}`;
    }
}

// Table search function
function searchTable(tableId, inputId) {
    let input = document.getElementById(inputId);
    let table = document.getElementById(tableId);
    let tr = table.getElementsByTagName("tr");

    input.addEventListener("keyup", function() {
        let filter = input.value.toLowerCase();
        for (let i = 1; i < tr.length; i++) {
            let td = tr[i].getElementsByTagName("td");
            let found = false;
            for (let j = 0; j < td.length; j++) {
                if (td[j].textContent.toLowerCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }
            tr[i].style.display = found ? "" : "none";
        }
    });
}

// Date validation functions
function validateDates(startDateId, endDateId, errorMessageId) {
    const startDate = document.getElementById(startDateId);
    const endDate = document.getElementById(endDateId);
    const errorDiv = document.getElementById(errorMessageId);

    function validate() {
        if (startDate.value && endDate.value) {
            if (new Date(endDate.value) < new Date(startDate.value)) {
                errorDiv.textContent = "End date cannot be earlier than start date";
                endDate.value = '';
                return false;
            } else {
                errorDiv.textContent = "";
                return true;
            }
        }
        return true;
    }

    startDate.addEventListener('change', validate);
    endDate.addEventListener('change', validate);

    // Add validation to form submission
    const form = startDate.closest('form');
    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validate()) {
                e.preventDefault();
            }
        });
    }
}

// Initialize components
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize search functionality
    const searchInputs = document.querySelectorAll('[id$="Search"]');
    searchInputs.forEach(input => {
        const tableId = input.id.replace('Search', 'Table');
        searchTable(tableId, input.id);
    });

    // Initialize date validations
    if (document.getElementById('start_date')) {
        validateDates('start_date', 'end_date', 'date-error');
    }
});
