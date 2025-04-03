// Global data
let globalData = null;
let selectedItems = [];

// Initialize
document.addEventListener('DOMContentLoaded', function() {
  // Fetch initial data
  fetchData();
  
  // Setup event listeners
  document.getElementById('add-item-btn').addEventListener('click', openAddItemModal);
  document.getElementById('edit-selected-btn').addEventListener('click', editSelectedItem);
  document.getElementById('delete-selected-btn').addEventListener('click', deleteSelectedItems);
  document.getElementById('select-all').addEventListener('change', toggleSelectAll);
  document.getElementById('category-filter').addEventListener('change', filterItemsByCategory);
  document.getElementById('search-box').addEventListener('input', filterItemsBySearch);
  
  // Modal events
  document.querySelectorAll('.close, .close-btn').forEach(el => {
    el.addEventListener('click', closeModal);
  });
  
  document.getElementById('item-form').addEventListener('submit', saveItem);
  
  // Close modal when clicking outside
  window.addEventListener('click', function(event) {
    const modal = document.getElementById('item-modal');
    if (event.target === modal) {
      closeModal();
    }
  });
});

// Fetch data from API
function fetchData() {
  fetch('/api/data')
    .then(response => response.json())
    .then(data => {
      globalData = data;
      populateCategoryFilter(data.categories);
      populateCategorySelect(data.categories);
      renderInventoryTable(data.wardrobe_items);
    })
    .catch(error => {
      console.error('Error fetching data:', error);
      alert('Failed to load inventory data. Please try again.');
    });
}

// Populate category filter dropdown
function populateCategoryFilter(categories) {
  const select = document.getElementById('category-filter');
  select.innerHTML = '<option value="all">All Categories</option>';
  
  if (categories && categories.length > 0) {
    categories.forEach(cat => {
      const option = document.createElement('option');
      option.value = cat.id;
      option.textContent = cat.name;
      select.appendChild(option);
    });
  } else {
    // If no categories are defined, extract from items
    const uniqueCategories = [...new Set(globalData.wardrobe_items.map(item => item.category))].filter(Boolean);
    
    uniqueCategories.forEach(cat => {
      const option = document.createElement('option');
      option.value = cat.toLowerCase().replace(/\s+/g, '_');
      option.textContent = cat;
      select.appendChild(option);
    });
  }
}

// Populate category select in the modal
function populateCategorySelect(categories) {
  const select = document.getElementById('item-category');
  select.innerHTML = '';
  
  if (categories && categories.length > 0) {
    categories.forEach(cat => {
      const option = document.createElement('option');
      option.value = cat.name;
      option.textContent = cat.name;
      select.appendChild(option);
    });
  } else {
    // If no categories are defined, extract from items
    const uniqueCategories = [...new Set(globalData.wardrobe_items.map(item => item.category))].filter(Boolean);
    
    uniqueCategories.forEach(cat => {
      const option = document.createElement('option');
      option.value = cat;
      option.textContent = cat;
      select.appendChild(option);
    });
  }
}

// Render inventory table
function renderInventoryTable(items) {
  const tbody = document.querySelector('#inventory-table tbody');
  tbody.innerHTML = '';
  
  if (!items || items.length === 0) {
    const row = document.createElement('tr');
    row.innerHTML = '<td colspan="10">No inventory items found.</td>';
    tbody.appendChild(row);
    return;
  }
  
  items.forEach(item => {
    const row = document.createElement('tr');
    row.setAttribute('data-id', item.id);
    row.setAttribute('data-category', (item.category || '').toLowerCase().replace(/\s+/g, '_'));
    
    const checkboxCell = document.createElement('td');
    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.className = 'item-checkbox';
    checkbox.addEventListener('change', updateSelectedItems);
    checkboxCell.appendChild(checkbox);
    
    let statusClass = 'status-available';
    if (item.status) {
      statusClass = 'status-' + item.status.toLowerCase().replace(/\s+/g, '-');
    }
    
    row.innerHTML += `
      <td>${item.id}</td>
      <td>${item.name}</td>
      <td>${item.category || 'Uncategorized'}</td>
      <td>${item.size || 'N/A'}</td>
      <td class="${statusClass}">${item.status || 'Available'}</td>
      <td>$${item.price || 'N/A'}</td>
      <td>${item.location || 'Unknown'}</td>
      <td>${item.condition || 'Unknown'}</td>
      <td>
        <button class="edit-btn" data-id="${item.id}">Edit</button>
        <button class="delete-btn" data-id="${item.id}">Delete</button>
      </td>
    `;
    
    row.insertBefore(checkboxCell, row.firstChild);
    tbody.appendChild(row);
  });
  
  // Add event listeners to edit/delete buttons
  document.querySelectorAll('.edit-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      const itemId = this.getAttribute('data-id');
      openEditItemModal(itemId);
    });
  });
  
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      const itemId = this.getAttribute('data-id');
      deleteItem(itemId);
    });
  });
}

// Update selected items array
function updateSelectedItems() {
  const checkboxes = document.querySelectorAll('.item-checkbox:checked');
  selectedItems = Array.from(checkboxes).map(cb => cb.closest('tr').getAttribute('data-id'));
  
  // Update buttons state
  document.getElementById('edit-selected-btn').disabled = selectedItems.length !== 1;
  document.getElementById('delete-selected-btn').disabled = selectedItems.length === 0;
}

// Toggle select all checkboxes
function toggleSelectAll() {
  const selectAll = document.getElementById('select-all');
  const checkboxes = document.querySelectorAll('.item-checkbox');
  
  checkboxes.forEach(cb => {
    cb.checked = selectAll.checked;
  });
  
  updateSelectedItems();
}

// Filter items by category
function filterItemsByCategory() {
  const category = document.getElementById('category-filter').value;
  const rows = document.querySelectorAll('#inventory-table tbody tr');
  
  rows.forEach(row => {
    if (category === 'all' || row.getAttribute('data-category') === category) {
      row.style.display = '';
    } else {
      row.style.display = 'none';
    }
  });
}

// Filter items by search term
function filterItemsBySearch() {
  const searchTerm = document.getElementById('search-box').value.toLowerCase();
  const rows = document.querySelectorAll('#inventory-table tbody tr');
  
  rows.forEach(row => {
    const text = row.textContent.toLowerCase();
    if (text.includes(searchTerm)) {
      row.style.display = '';
    } else {
      row.style.display = 'none';
    }
  });
}

// Open modal to add new item
function openAddItemModal() {
  document.getElementById('modal-title').textContent = 'Add New Item';
  document.getElementById('item-form').reset();
  
  // Generate a new ID
  const prefix = prompt('Enter item type prefix (e.g., "hat", "dress", "suit"):', 'item');
  
  if (prefix) {
    // Find the highest number for this prefix
    const existingIds = globalData.wardrobe_items
      .filter(item => item.id.startsWith(prefix))
      .map(item => parseInt(item.id.replace(prefix, ''), 10) || 0);
    
    const nextNumber = existingIds.length > 0 ? Math.max(...existingIds) + 1 : 1;
    const newId = `${prefix}${String(nextNumber).padStart(3, '0')}`;
    
    document.getElementById('item-id').value = newId;
    document.getElementById('item-id-code').value = newId;
  }
  
  document.getElementById('item-modal').style.display = 'block';
}

// Open modal to edit existing item
function openEditItemModal(itemId) {
  const item = globalData.wardrobe_items.find(i => i.id === itemId);
  if (!item) return;
  
  document.getElementById('modal-title').textContent = 'Edit Item';
  document.getElementById('item-id').value = item.id;
  document.getElementById('item-name').value = item.name || '';
  document.getElementById('item-category').value = item.category || '';
  document.getElementById('item-size').value = item.size || '';
  document.getElementById('item-status').value = item.status || 'Available';
  document.getElementById('item-price').value = item.price || '';
  document.getElementById('item-location').value = item.location || '';
  document.getElementById('item-condition').value = item.condition || 'Good';
  document.getElementById('item-notes').value = item.notes || '';
  document.getElementById('item-id-code').value = item.id;
  
  document.getElementById('item-modal').style.display = 'block';
}

// Close the modal
function closeModal() {
  document.getElementById('item-modal').style.display = 'none';
}

// Save item (add new or update existing)
function saveItem(event) {
  event.preventDefault();
  
  const itemId = document.getElementById('item-id').value;
  const idCode = document.getElementById('item-id-code').value;
  
  // Prepare item data
  const itemData = {
    id: idCode,
    name: document.getElementById('item-name').value,
    category: document.getElementById('item-category').value,
    size: document.getElementById('item-size').value,
    status: document.getElementById('item-status').value,
    price: parseFloat(document.getElementById('item-price').value),
    location: document.getElementById('item-location').value,
    condition: document.getElementById('item-condition').value,
    notes: document.getElementById('item-notes').value
  };
  
  // Check if this is a new item or an update
  const existingIndex = globalData.wardrobe_items.findIndex(i => i.id === itemId);
  
  if (existingIndex >= 0) {
    // Update existing item
    globalData.wardrobe_items[existingIndex] = itemData;
  } else {
    // Add new item
    globalData.wardrobe_items.push(itemData);
  }
  
  // Send update to API
  updateData();
  
  // Close modal
  closeModal();
}

// Edit selected item
function editSelectedItem() {
  if (selectedItems.length !== 1) return;
  openEditItemModal(selectedItems[0]);
}

// Delete selected items
function deleteSelectedItems() {
  if (selectedItems.length === 0) return;
  
  const confirm = window.confirm(`Are you sure you want to delete ${selectedItems.length} item(s)?`);
  if (!confirm) return;
  
  // Remove items from data
  globalData.wardrobe_items = globalData.wardrobe_items.filter(item => !selectedItems.includes(item.id));
  
  // Send update to API
  updateData();
  
  // Reset selection
  selectedItems = [];
  document.getElementById('select-all').checked = false;
}

// Delete a single item
function deleteItem(itemId) {
  const confirm = window.confirm('Are you sure you want to delete this item?');
  if (!confirm) return;
  
  // Remove item from data
  globalData.wardrobe_items = globalData.wardrobe_items.filter(item => item.id !== itemId);
  
  // Send update to API
  updateData();
}

// Update data via API
function updateData() {
  fetch('/api/update', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(globalData)
  })
  .then(response => response.json())
  .then(() => {
    // Refresh the table
    renderInventoryTable(globalData.wardrobe_items);
    // Update buttons state
    updateSelectedItems();
  })
  .catch(error => {
    console.error('Error updating data:', error);
    alert('Failed to update inventory data. Please try again.');
  });
}
